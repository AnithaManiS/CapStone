@isTest
public with sharing class EventSpeakerTriggerTest {

@isTest
public static void testBeforeInsertTrigger()
    {
        Event__c event = TestFactoryUtility.createEvents();
        Speaker__c speaker = TestFactoryUtility.createSpeakers();
        Event_Speaker__c eventSpeaker = new Event_Speaker__c();
        eventSpeaker.Event__c = event.Id;
        eventSpeaker.Speaker__c = speaker.Id;
        insert eventSpeaker;
       
        Event_Speaker__c evntSpkr = new Event_Speaker__c();
        evntSpkr.Event__c = event.Id;
        evntSpkr.Speaker__c = speaker.Id;

        try {
            Test.startTest();
            insert evntSpkr;
            test.stopTest();
        } catch (Exception ex) {
            System.Assert.isTrue(ex.getMessage().contains('This speaker is already booked for another event'));
        }
        
    }

    @isTest
    public static void testBeforeUpdateTrigger()
    {
        List<Event_Speaker__c> evntSpkrs = new List<Event_Speaker__c>();

        Event_Speaker__c eventSpeaker1 = new Event_Speaker__c();
        Event__c event1 = TestFactoryUtility.createEvents();
        Speaker__c speaker1 = TestFactoryUtility.createSpeakers();
        eventSpeaker1.Event__c = event1.Id;
        eventSpeaker1.Speaker__c = speaker1.Id;
        insert eventSpeaker1;
       
        // Event_Speaker__c eventSpeaker2 = new Event_Speaker__c();
        Event__c event2 = TestFactoryUtility.createEvents();
        // Speaker__c speaker2 = TestFactoryUtility.createSpeakers();
        // eventSpeaker2.Event__c = event2.Id;
        // eventSpeaker2.Speaker__c = speaker2.Id;
        
        // evntSpkrs.add(eventSpeaker1);
        // evntSpkrs.add(eventSpeaker2);
        // insert evntSpkrs;

        Event_Speaker__c evntSpkr = [SELECT Id, Event__c, Speaker__c FROM Event_Speaker__c];

        try {
            Test.startTest();
            evntSpkr.Event__c = event2.Id;
            update evntSpkr;
            test.stopTest();
        } catch (System.SObjectException ex) {
            //System.Assert.isTrue(ex.getMessage().contains('Field is not writeable: Event_Speaker__c.Speaker__c'));
        }
    }
   
   
}