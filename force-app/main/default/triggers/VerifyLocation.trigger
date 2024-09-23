trigger VerifyLocation on Location__c (after insert, after update) {
    if (Trigger.isAfter && (Trigger.isInsert || Trigger.isUpdate)) {
        Set<Id> locationIds = new Set<Id>();
        for (Location__c location : Trigger.new) {
            locationIds.add(location.Id);
        }
        // Execute the batch asynchronously
        try {
            Database.executeBatch(new VerifyLocationBatch(locationIds), 10);
        } catch (Exception e)  {
            System.debug('Exception thrown from VerifyLocationBatch: ' + e.getMessage());
            ErrorLogUtil.insertErrorLog('VerifyLcoation batchable exception', e.getMessage(), 'VerifyLocation.trigger');
        }
    }
}