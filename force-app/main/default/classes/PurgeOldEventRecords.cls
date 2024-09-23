public with sharing class PurgeOldEventRecords implements Database.Batchable<sObject>,Database.stateful{
    public Date dt = Date.today().addDays(-61);
    public Database.QueryLocator start(Database.BatchableContext bc)
    {
        return Database.getQueryLocator('SELECT Id, Name FROM Event__c Where End_Date_Time__c > :dt and live__c = false' );
    }

    public void execute(Database.BatchableContext bc, List<Event__c> eventList)
    {
        List<Id> eventIds = new List<Id>();
        for(Event__c event : eventList)
        {
            eventIds.add(event.Id);
        }
        try {
            Database.delete(eventIds, false);
        } catch (Exception ex) {
            System.debug(ex.getMessage());
            ErrorLogUtil.insertErrorLog('Error - PurgeOldEventRecords delete old records', ex.getMessage(), 'PurgeOldEventRecords.execute()');
        }
    }
    
    public void finish(Database.BatchableContext bc){
        //System.debug('Batch is complete');

        AsyncApexJob purgeBatchJob = [SELECT Id, Status, NumberOfErrors, JobItemsProcessed,
        TotalJobItems FROM AsyncApexJob WHERE Id = :bc.getJobId()];
        // Send an email to the Apex job's submitter notifying of job completion.
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        //String[] toAddresses = new String[] {'sfdcpanther@gmail.com'};
        String[] toAddresses = new String[] {'animani@publicisgroupe.com'};
        mail.setToAddresses(toAddresses);
        mail.setSubject('Batch Job status to purge the old event records: ' + purgeBatchJob.Status);
        mail.setPlainTextBody('The PurgeOldEventRecords batch job processed items = ' + purgeBatchJob.TotalJobItems +
        ' batches with '+ purgeBatchJob.NumberOfErrors + ' failures.');

        try {
            // Send the email
            Messaging.sendEmail(new List<Messaging.SingleEmailMessage>{mail});
        } catch (Exception e) {
            System.debug('Error sending email: ' + e.getMessage());
            ErrorLogUtil.insertErrorLog('Error - PurgeOldEventRecords Confirmation email', e.getMessage(), 'PurgeOldEventRecords.finish()');

        }
    }

}