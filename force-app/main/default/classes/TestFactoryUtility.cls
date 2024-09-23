@IsTest
public with sharing class TestFactoryUtility {

    public static Location__c createLocation(){
        Location__c location = new Location__c();
        UUID randomUUID = UUID.randomUUID();
        String loc = 'testLocation' + randomUUID.toString();
        location.Name = loc;
        location.City__c = 'MockCity';
        location.State__c = 'MockState';
        location.Country__c = 'Afghanistan';
        location.Postal_Code__c = '123456';
        try {
            insert location;
        } catch (Exception ex) {
            System.debug('Exception while creating test Event__c objects' + ex.getMessage());
        }
        return location;

    }

    public static Event_Organizer__c createTestEventOrganizer() {
        // Create a list of Event Organizer records
        List<Event_Organizer__c> eventOrganisers = new List<Event_Organizer__c>();
        UUID randomUUID = UUID.randomUUID();
        String email = 'test' + randomUUID.toString() + '@gmail.com';
        Event_Organizer__c evntOrg = new Event_Organizer__c(Name = 'Test Organizer', Email__c = email, Phone__c = '1284903753');
        eventOrganisers.add(evntOrg);
        try {
            insert eventOrganisers;
        } catch (Exception ex) {
            System.debug('Exception while creating test Event__c objects' + ex.getMessage());
        }
        return eventOrganisers[0];
    }

    public static Event__c createEvents() {
        List<Event__c> events = new List<Event__c>();
        Event_Organizer__c organizer = createTestEventOrganizer();
        Event__c event = new Event__c();
        event.Name__c = 'MaxFit - In Person Event';
        event.Event_Type__c = 'Virtual';
        event.Start_Date_Time__c = datetime.newInstance(2024, 10, 27, 19, 30, 00);
        event.End_Date_Time__c = datetime.newInstance(2024, 10, 28, 20, 30, 00);
        event.Max_Seats__c = 10;
        event.Live__c = true;
        event.Event_Organizer__c = organizer.Id;
        event.location__c = createLocation().Id;
        
        events.add(event);
        try {
            insert events;
        } catch (Exception ex) {
            System.debug('Exception while creating test Event__c objects' + ex.getMessage());
        }  
        return events[0];

    }

    public static Attendee__c createAttendees(){
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
        return attendees[0];

    }

    // // public static List<Event_Attendee__c> insertEventAttendees(){
    // public static Event_Attendee__c insertEventAttendees(){

    //     List<Event_Attendee__c> evntAtt = new List<Event_Attendee__c>();
    //     Event_Attendee__c evntAtt1 = new Event_Attendee__c();
    //     //evntAtt1.Name = 'Test Attendee';
    //     evntAtt1.Attendee__c = createAttendees().Id;
    //     evntAtt1.Event__c = createEvents().Id;
    //     evntAtt.add(evntAtt1);
    //     // try {
    //     //     insert evntAtt;
    //     // } catch (Exception ex) {
    //     //     System.debug('Exception while creating test EventAttendees__c objects' + ex.getMessage());
    //     //     // ErrorLogUtil.insertErrorLog('Error - creating eventAttendee records', ex.getMessage(), 'TestFactoryUtility.insertEventAttendees()');
    //     //     // return null;
    //     // } 
    //     return evntAtt1;
    //     // return evntAtt;

    // }

    public static Speaker__c createSpeakers(){
        UUID randomUUID = UUID.randomUUID();
        String email = 'spkr' + randomUUID.toString() + '@gmail.com';
        Speaker__c speaker = new Speaker__c(Name='Mike', Email__c = email, Phone__c='1234567890', Company__c='Test');
        try {
            insert speaker;
        } catch (Exception ex) {
            System.debug('Exception while creating test Speaker__c objects' + ex.getMessage());
        }  
        return speaker;
    }
        

    public static void createEventsList() {
        List<Event__c> events = new List<Event__c>();
        Event_Organizer__c organizer = createTestEventOrganizer();
        Location__c location = createLocation();
        for (Integer i=0;i<200;i++){
            Event__c event = new Event__c();
            event.Name__c = 'MaxFit - In Person Event' + i;
            event.Event_Type__c = 'Virtual';
            event.Start_Date_Time__c = datetime.newInstance(2024, 8, 27, 19, 30, 00);
            event.End_Date_Time__c = datetime.newInstance(2024, 8, 28, 20, 30, 00);
            event.Max_Seats__c = 10;
            event.Live__c = true;
            event.Event_Organizer__c = organizer.Id;
            event.location__c = location.Id;
            events.add(event);
        }
        try {
            List<Database.SaveResult> result = Database.insert(events, false);
        } catch (Exception ex) {
            System.debug('Exception while creating test Event__c objects' + ex.getMessage());
        }  
    }

}