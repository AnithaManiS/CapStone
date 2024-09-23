public with sharing class ErrorLogUtil {
    /** Inserts an Error Log record with dynamic details.
        @param logTitle    The title or brief description of the error.
        @param logDetails  Detailed information about the error, including stack traces if applicable.
        @param processName The name of the process or functionality where the error occurred.
    */
public static void insertErrorLog(String logTitle, String logDetails, String processName) {

    // Construct the Error Log record
    Error_Log__c errorLog = new Error_Log__c(
            Log_Date_Time__c = Datetime.now(),
            Log_Details__c = logDetails,
            Process_Name__c = processName
    );

    try {
        // insert the Error Log
        Database.SaveResult result = Database.insert(errorLog, false);
        
        System.debug('Error log record has been inserted with the Id: ' + result.getId());
        // Error_Log__c errorObj = [SELECT Id FROM Error_Log__c WHERE Id = :result.getId()];
        // System.debug('New error object: ' + errorObj.Id + result.getId());

    } catch (Exception e) {
        System.debug('Exception during ErrorLog insert: ' + e);
    }
}

}