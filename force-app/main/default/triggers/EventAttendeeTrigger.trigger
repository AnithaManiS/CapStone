trigger EventAttendeeTrigger on Event_Attendee__c (after insert) {
    if(trigger.isAfter) {
        EventAttendeeTriggerHandler.sendConfirmationEmail(trigger.new);
    }
}