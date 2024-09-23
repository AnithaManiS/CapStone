public with sharing class EventDetailsController {
    
    @AuraEnabled(cacheable=true)
    public static List<Speaker__c> fetchSpeaker(String cacheKey, String eventId) {
        System.debug('eventId: ' + eventId);
        try {
            List<Event_Speaker__c> eventSpeaker = [SELECT Id, Event__c, Speaker__c FROM Event_Speaker__c where Event__c = :eventId];
            if (eventSpeaker != null && !eventSpeaker.isEmpty()) {
                List<Speaker__c> speaker = [SELECT Id, Name, Phone__c, ProfileURL__c, Email__c FROM Speaker__c where Id = :eventSpeaker[0].Speaker__c];
                System.debug('speaker: ' + speaker[0].Id);
                System.debug('speaker Name: ' + speaker[0].Name);
                return speaker;
            } else {
                System.debug('Speaker not found: ');
                return null;
            }
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }    
    }

    @AuraEnabled(cacheable=true)
    public static List<Location__c> fetchLocation(String cacheKey, String eventId) {
        System.debug('eventId: ' + eventId);
        Location__c eventLocation;
        try {
            return [select Id, name, street__c, city__c, postal_code__c, state__c, country__c from location__c where id in (select Location__c from event__C where id = :eventId)];
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }    
    }

    @AuraEnabled(cacheable=true)
    public static List<Attendee__c> fetchAttendees(String cacheKey, String eventId) {
        System.debug('eventId: ' + eventId);
        try {
            List<Event_Attendee__c> eventAttendee = [SELECT Id, Event__c, Attendee__c FROM Event_Attendee__c where Event__c = :eventId];
            if (eventAttendee.size() != 0 && eventAttendee.size() != null) {
                Set<Id> speakerIds = new Set<Id>();
                for(Event_Attendee__c ea : eventAttendee){
                    speakerIds.add(ea.Attendee__c);
                }
                List<Attendee__c> attendees = [SELECT Id, Name, Phone__c, Email__c FROM Attendee__c where Id = : speakerIds];
                System.debug('Attendee: ' + attendees[0].Id);
                System.debug('Attendee Name: ' + attendees[0].Name);
                return attendees;
            } else {
                System.debug('Attendee not found: ');
                return null;
            }
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }    
    }

    @AuraEnabled(cacheable=true)
    public static List<Event__c> fetchLiveEvents(String searchName, String searchLocation, Date searchStartDate) {
        try {
            String query = 'SELECT Id, Name__c, Event_Type__c, Start_Date_Time__c, End_Date_Time__c, Live__c, Event_Organizer__c, People_Attending__c, Remaining_Seats__c FROM Event__c where Live__c = true AND Start_Date_Time__c >= TODAY';
            if (String.isNotBlank(searchName)) {
                searchName = '%' + searchName + '%';
                query += ' AND Name__c LIKE :searchName';
            }
            if (searchStartDate != null) {
                // Datetime searchDateTime = DateTime.newInstance(searchStartDate);
                Datetime searchDateTime = DateTime.newInstance(searchStartDate.year(), searchStartDate.month(), searchStartDate.day());
                System.debug('searchDateTime: ' + searchDateTime);
                query += ' AND Start_Date_Time__c >= :searchStartDate';
            }
            if (String.isNotBlank(searchLocation)) {
                searchLocation = '%' + searchLocation + '%';
                query += ' AND Location__c IN ( Select Id from Location__c where city__c LIKE :searchLocation)';
            }
            System.debug('Query' + query);
            query += ' ORDER BY Start_Date_Time__c';
            return Database.query(query);
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }    
    }
}