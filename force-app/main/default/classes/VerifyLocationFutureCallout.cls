public with sharing class VerifyLocationFutureCallout {

    // Method to update Location records outside the @future context
    public static void updateLocations(List<Location__c> locationsToUpdate) {
        try {
            update locationsToUpdate;
        } catch (Exception e) {
            System.debug('Exception updating the locations: ' + e.getMessage());
            ErrorLogUtil.insertErrorLog('Callout Exception', e.getMessage(), 'VerifyLocationCallout.updateLocations()');
        }
    }

    @Future(callout=true)
    public static void verify(Set<ID> locIds) {
        List<Location__c> locations = [select Id, Name, Street__c, City__c, State__c, Verified__c from Location__c where Id IN :locIds];
        List<Location__c> updateLocations = new List<Location__c>();
        for (Location__c location : locations) {
            System.debug('Before triggering the verify call verification status = ' + location.Verified__c);
            Boolean isVerified = VerifyLocationService.callSmartyStreetsAPI(location.Street__c, location.City__c, location.State__c);
            location.Verified__c = isVerified;
            System.debug('After triggering the verify call verification status = ' + isVerified);
            updateLocations.add(location);
        }
        updateLocations(updateLocations); 
    }

    public static void verifyLocation(List<Location__c> locationList) {
        Set<ID> locationIds = new Set<ID>();
        for (Location__c location : locationList) {
            locationIds.add(location.Id);
        }
        verify(locationIds);
    }

}