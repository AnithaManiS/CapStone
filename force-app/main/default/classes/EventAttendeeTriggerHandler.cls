public with sharing class EventAttendeeTriggerHandler {
    public static void sendConfirmationEmail(List<Event_Attendee__c> newRecordList) {
        
        // Collect all event IDs from the new records
        Set<Id> eventIds = new Set<Id>();
        for (Event_Attendee__c ea : newRecordList) {
            eventIds.add(ea.Event__c);
        }

        // Query all events at once
        Map<Id, Event__c> eventDetailsMap = new Map<Id, Event__c>([
            SELECT Id, Name, Start_Date_Time__c, Location__r.Name, Event_Organizer__r.Name
            FROM Event__c
            WHERE Id IN :eventIds
        ]);

        // Process each attendee
        for (Event_Attendee__c ea : newRecordList) {
            Event__c event = eventDetailsMap.get(ea.Event__c);
            Attendee__c attendee = [SELECT Name, Email__c FROM Attendee__c WHERE Id = :ea.Attendee__c];

            String eventName = event.Name;
            DateTime eventDate = event.Start_Date_Time__c;
            String attendeeName = attendee.Name;
            String attendeeEmail = attendee.Email__c;
            String eventLocation = event.Location__r.Name; 
            String eventOrganizer = event.Event_Organizer__r.Name;

            // Create and configure the email message
            Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
            String emailSubject = 'Pass for the ' + eventName;
            String emailBody = String.format('<html><head></head><body><p>Dear {0},</p> <p>Thank you for registering for {1} which will be organized on {2} & will be held in {3}. We are excited to have you, see you at the event.</p> <p>Find the Google Map Location for the Event Here: <a href="https://www.google.com/maps/search/?api=1&query={4}">Google Maps Link</a></p>  <p>Thanks,</p> <p> {5}</p></body></html>', 
                new String[]{attendeeName, eventName, eventDate.format(), eventLocation, EncodingUtil.urlEncode(eventLocation, 'UTF-8'), eventOrganizer});
            mail.setSubject(emailSubject);
            mail.setHtmlBody(emailBody);
            mail.setToAddresses(new String[] {attendeeEmail});

            try {
                // Send the email
                Messaging.sendEmail(new List<Messaging.SingleEmailMessage>{mail});
            } catch (Exception e) {
                System.debug('Error sending email: ' + e.getMessage());
                ErrorLogUtil.insertErrorLog('Error - EventAttendee Confirmation email Trigger', e.getMessage(), 'EventAttendeeTriggerHandler.sendConfirmationEmail()');
            }
        }
    }
}