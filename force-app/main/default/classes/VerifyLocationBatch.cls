public class VerifyLocationBatch implements Database.Batchable<sObject>, Database.Stateful {

    private Set<Id> locationIds = new Set<Id>();
    public VerifyLocationBatch(Set<Id> locIds) {
        this.locationIds.addAll(locIds);
    }

    public Database.QueryLocator start(Database.BatchableContext bc) {
        return Database.getQueryLocator([SELECT Id, Name, Street__c, City__c, State__c, Verified__c 
                                          FROM Location__c 
                                          WHERE Id IN :locationIds]);
    }

    public void execute(Database.BatchableContext bc, List<Location__c> scope) {
        for (Location__c location : scope) {
            System.debug('Before triggering the verify call verification status = ' + location.Verified__c);
            try {
                Boolean isVerified = VerifyLocationService.callSmartyStreetsAPI(location.Street__c, location.City__c, location.State__c);
                location.Verified__c = isVerified;
                System.debug('After triggering the verify call verification status = ' + isVerified);
            } catch (Exception ex) {
                System.debug('Exception triggering the verify call verification api' + ex.getMessage());
                ErrorLogUtil.insertErrorLog('VerifyLocationBatch', ex.getMessage(), 'VerifyLocationBatch.execute()');
            }
        try {
            update scope;
        } catch (Exception ex) {
            System.debug('Exception updating the locations' + ex.getMessage());
            ErrorLogUtil.insertErrorLog('VerifyLocationBatch execute', ex.getMessage(), 'VerifyLocationBatch.execute()');
        }
    }

    public void finish(Database.BatchableContext bc) {
        System.debug('Finish method' + bc.getJobId());

        AsyncApexJob a = [SELECT Id, Status, NumberOfErrors, JobItemsProcessed,
        TotalJobItems, CreatedBy.Email
        FROM AsyncApexJob WHERE Id =
        :bc.getJobId()];
        System.debug('The batch Apex job processed ' + a.TotalJobItems +
        ' batches with '+ a.NumberOfErrors + ' failures. Error: ' + a.getErrors());
    }

 }