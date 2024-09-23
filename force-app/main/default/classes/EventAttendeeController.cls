public with sharing class EventAttendeeController {
    @AuraEnabled(cacheable=true)
    public static List<List<Event__c>> fetchEvents(String attendeeId) {
        List<List<Event__c>> eventsToReturn = new List<List<Event__c>>();
        try {
            List<Event_Attendee__c> eventAttendeeList = [select id, event__c, attendee__c from Event_Attendee__c where attendee__c =: attendeeId];
            if(eventAttendeeList.size() > 0) {
                Set<Id> eventIds = new Set<Id>();
                for(Event_Attendee__c ea : eventAttendeeList){
                    eventIds.add(ea.event__c);
                }
                eventsToReturn.add([select id, name, Start_Date_Time__c, End_Date_Time__c, Location__c, Event_Organizer__c, Live__c
                from Event__c where id in: eventIds and End_Date_Time__c >= TODAY and Live__c = true
                order by Start_Date_Time__c]);

                eventsToReturn.add([select id, name, Start_Date_Time__c, End_Date_Time__c, Location__c, Event_Organizer__c, Live__c
                from Event__c where id in: eventIds and End_Date_Time__c < TODAY and Live__c = true
                order by Start_Date_Time__c]);
            }
            return eventsToReturn;
        } catch(Exception e) {
            System.debug('Exception occurred fetching the events for the user' + e.getMessage());
            throw new AuraHandledException(e.getMessage());
        }
    }
}