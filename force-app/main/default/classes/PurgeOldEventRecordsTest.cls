 @isTest
public class PurgeOldEventRecordsTest {

    @TestSetup
    static void prepareTestData(){
        TestFactoryUtility.createEventsList();
    }

    @isTest
    static void testBatchExecutionWithValidData() {
        Date dt = Date.today().addDays(-61);
        List<Event__c> eventList = [SELECT Id, Name FROM Event__c Where End_Date_Time__c > :dt and live__c = false];
        System.Assert.areEqual(200, eventList.size(), 'TEstSetupData Event records created successfully');
        Test.startTest();
        Id batchID = Database.executeBatch(new PurgeOldEventRecords(), 200);
        Test.stopTest();
        AsyncApexJob job = [SELECT Id, Status, NumberOfErrors FROM AsyncApexJob WHERE Id = :batchID];

        
        System.assertEquals('Completed', job.Status, 'Batch job completed successfully.');
        System.assertEquals(eventList.size(), 200, 'Events were deleted as expected.'); 
    }

}
