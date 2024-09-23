public with sharing class EventSpeakerTriggerHandler {

/**
 * This method is invoked before the insertion of Event_Speaker__c records.
 * It ensures that each speaker is assigned to only one event at any given time by checking against existing records.
 */
public static void beforeInsert(List<Event_Speaker__c> newEvntSpkr) {
    // A set to store unique IDs of speakers involved in the insertion.
    Set<Id> speakerIds = new Set<Id>();
    
    // Collect speaker IDs from the new event speaker records being inserted.
    for (Event_Speaker__c eventSpeaker : newEvntSpkr) {
        if (eventSpeaker.Speaker__c != null) { 
            speakerIds.add(eventSpeaker.Speaker__c);
        }
    }
    
    // Query to find all existing Event_Speaker__c records that reference the speakers in the insertion,
    // excluding the records currently being inserted.
    List<Event_Speaker__c> existingEventSpeakers = [
        SELECT Id, Speaker__c 
        FROM Event_Speaker__c 
        WHERE Speaker__c IN :speakerIds ];
    
    // Create a map to quickly check if a speaker is already booked for another event.
    Map<Id, Event_Speaker__c> existingEventSpeakersMap = new Map<Id, Event_Speaker__c>();
    for (Event_Speaker__c existingEventSpeaker : existingEventSpeakers) {
        existingEventSpeakersMap.put(existingEventSpeaker.Speaker__c, existingEventSpeaker);
    }
    
    // Loop through the records being inserted to enforce the business rule.
    for (Event_Speaker__c eventSpeaker : newEvntSpkr) {
        // Check if the speaker is already booked for another event.
        if (existingEventSpeakersMap.containsKey(eventSpeaker.Speaker__c)) {
            // Add an error to the record if a speaker is already assigned to an event.
            eventSpeaker.addError('This speaker is already booked for another event.'); 
        }
    }
}


/**
 * This method is invoked before the update operation on Event_Speaker__c records.
 * It ensures that each speaker is only assigned to one event at any given time.
 *
 * @param newEvntSpkr The list of Event_Speaker__c records that are being updated.
 * @param oldEvntSpkrMap A map of the original values of the Event_Speaker__c records before the update, keyed by record ID.
 */
    public static void beforeUpdate(List<Event_Speaker__c> newEvntSpkr, Map<Id, Event_Speaker__c> oldEvntSpkrMap) {
        
        // A set to store unique IDs of speakers involved in the update.
        Set<Id> speakerIds = new Set<Id>();
        
        // Collect speaker IDs from the new event speaker records.
        for (Event_Speaker__c eventSpeaker : newEvntSpkr) {
            if (eventSpeaker.Speaker__c != null) { 
                speakerIds.add(eventSpeaker.Speaker__c);
            }
        }
        
        // Query to find all Event_Speaker__c records that reference the speakers in the update,
        // excluding the records currently being updated.
        // below Trigger.newMap.keySet() is equivalent to Map<Id, Event_Speaker__c> oldEvntSpkrMap's keyset
        List<Event_Speaker__c> existingSpeakerEvents = [
            SELECT Id, Speaker__c 
            FROM Event_Speaker__c 
            WHERE Speaker__c IN :speakerIds 
                  AND Id NOT IN :Trigger.newMap.keySet()
        ];

        // Create a map to quickly check if a speaker is already booked for another event.
        Map<Id, Event_Speaker__c> existingEventSpeakersMap = new Map<Id, Event_Speaker__c>();
        for (Event_Speaker__c existingEventSpeaker : existingSpeakerEvents) {
            existingEventSpeakersMap.put(existingEventSpeaker.Speaker__c, existingEventSpeaker);
        }
    
        // Loop through the records being updated to enforce business rules.
        for(Event_Speaker__c eventSpkr : newEvntSpkr) {
            // Check if the event ID on the record is different from the speaker ID and if it has changed from its previous value.
            if(existingEventSpeakersMap.containsKey(eventSpkr.Speaker__c) && 
            (oldEvntSpkrMap.get(eventSpkr.Id).Event__c != eventSpkr.Event__c)){
                // Add an error to the record if a speaker is assigned to more than one event.
                eventSpkr.addError('A speaker can be only assigned to one event');
            }
        }
    }
}