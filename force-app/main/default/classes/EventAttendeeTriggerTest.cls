@isTest
public class EventAttendeeTriggerTest {

    @isTest
    public static void testAfterInsertTrigger() {

        Location__c location = new Location__c();
        location.Name = 'Mock Location';
        location.City__c = 'MockCity';
        location.State__c = 'MockState';
        location.Country__c = 'Afghanistan';
        location.Postal_Code__c = '123456';
        try {
            insert location;
        } catch (Exception ex) {
            System.debug('Exception while creating test Event__c objects' + ex.getMessage());
        }

        List<Event_Organizer__c> eventOrganisers = new List<Event_Organizer__c>();
        Event_Organizer__c evntOrg = new Event_Organizer__c(Name = 'Test Organizer', Email__c = 'testorganizer@gmail.com', Phone__c = '1284903753');
        eventOrganisers.add(evntOrg);
        try {
            insert eventOrganisers;
        } catch (Exception ex) {
            System.debug('Exception while creating test Event__c objects' + ex.getMessage());
        }

        List<Event__c> events = new List<Event__c>();
        Event__c event = new Event__c();
        event.Name__c = 'MaxFit - In Person Event';
        event.Event_Type__c = 'Virtual';
        event.Start_Date_Time__c = datetime.newInstance(2024, 10, 27, 19, 30, 00);
        event.End_Date_Time__c = datetime.newInstance(2024, 10, 28, 20, 30, 00);
        event.Max_Seats__c = 10;
        event.Live__c = true;
        event.Event_Organizer__c = eventOrganisers[0].Id;
        event.location__c = location.Id;
        
        events.add(event);
        try {
            insert events;
        } catch (Exception ex) {
            System.debug('Exception while creating test Event__c objects' + ex.getMessage());
        }
		
		List<Attendee__c> attendees = new List<Attendee__c>();
        Attendee__c attendee = new Attendee__c();
        attendee.Name = 'Maxheadless';
        attendee.Email__c = 'test@gmail.com';
        attendee.Phone__c = '4534534534';
        attendees.add(attendee);
        try {
            insert attendees;
        } catch (Exception ex) {
            System.debug('Exception while creating test Attendee__c objects' + ex.getMessage());
        }

        Event_Attendee__c evntAtt1 = new Event_Attendee__c();
        Id attendeeId = attendees[0].id;
        Id eventId = events[0].id;

        evntAtt1.Event__c = eventId;
        evntAtt1.Attendee__c = attendeeId;

        Test.startTest();
        insert evntAtt1;
        test.stopTest();
        Event_Attendee__c evntAtt = [SELECT Id,Attendee__c FROM Event_Attendee__c where Id = :evntAtt1.Id and attendee__c = :attendeeId];
        System.assertNotEquals(null, evntAtt);
    }
}
