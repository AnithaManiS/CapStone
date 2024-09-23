trigger EventSpeakerTrigger on Event_Speaker__c (before insert,before update) {
    if(trigger.isBefore){
        if(Trigger.isInsert){
            EventSpeakerTriggerHandler.beforeInsert(trigger.new);
        }
        if(Trigger.isUpdate){
            EventSpeakerTriggerHandler.beforeUpdate(trigger.new,trigger.oldMap);
        }
    }
}