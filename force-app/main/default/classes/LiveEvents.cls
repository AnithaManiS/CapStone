@RestResource(urlMapping='/LiveEvents/*')
global with sharing class LiveEvents {

    @HttpGet
    global static List<EventDetails> getLiveEvents() {
        // Query for live events starting after today
        List<Event__c> events = [SELECT Id, NAme__c, Event_Type__c, Start_Date_Time__c, 
        End_Date_Time__c, Live__c, Event_Organizer__c, People_Attending__c, 
        Remaining_Seats__c FROM Event__c where Live__c = true AND Start_Date_Time__c >= TODAY];
        
        // Prepare the response list
        List<EventDetails> eventDetailsList = new List<EventDetails>();

        // Iterate over the events and populate the response
        for (Event__c evt : events) {
            EventDetails eventDetails = new EventDetails();
            eventDetails.eventId = evt.Id;
            eventDetails.eventName = evt.name__c;
            eventDetails.eventType = evt.Event_Type__c;
            eventDetails.startDateTime = evt.Start_Date_Time__c;
            eventDetails.endDateTime = evt.End_Date_Time__c;
            eventDetails.isLive = evt.Live__c;
            eventDetails.organizer = evt.Event_Organizer__c;
            eventDetails.peopleAttending = evt.People_Attending__c;
            eventDetails.remainingSeats = evt.Remaining_Seats__c;

            eventDetailsList.add(eventDetails);
        }

        return eventDetailsList;
    }

    // Inner class to define the structure of the JSON response
    global class EventDetails {
        global String eventId;
        global String eventName;
        global String eventType;
        global DateTime startDateTime;
        global DateTime endDateTime;
        global Boolean isLive;
        global String organizer;
        global Decimal peopleAttending;
        global Decimal remainingSeats;  

    }
}