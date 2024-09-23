    public with sharing class VerifyLocationService {

        public static Boolean callSmartyStreetsAPI(String street, String city, String state) {
            Integration_Settings__mdt smartyStreetsSettings = Integration_Settings__mdt.getInstance('SmartyStreetsSettings');
            String endpoint = smartyStreetsSettings.SmartyStreets__c + '/street-address?street='+ street +'&city='+ city +'&state=' + state + '&auth-id=' + smartyStreetsSettings.SmartyStreetsAuthId__c + '&auth-token=' + smartyStreetsSettings.SmartyStreetsAuthToken__c;
            System.debug('endpoint : ' + endpoint);
            Http http = new Http();
            Httprequest request = new Httprequest();
            request.setMethod('GET');
            request.setEndpoint(endpoint);
            try {
                Httpresponse response = http.send(request);
                System.debug('Get Status ' + response.getStatus());
                System.debug('Get Status Code ' + response.getStatusCode());
                System.debug('Get Response Body' + response.getBody());
                if (response.getStatusCode() == 200) {
                    return true;
                }
            } catch (Exception ex) {
                System.debug('Exception triggering call to the external address verification api' + ex.getMessage());
                ErrorLogUtil.insertErrorLog('VerifyLocationCallout', ex.getMessage(), 'VerifyLocationCallout.callSmartyStreetsAPI()');
            }
            return false;
        }

        // public static void verifyLocations(Set<Id> locIds) {
        //     List<Location__c> locationsToUpdate = new List<Location__c>();
        //     for (Location__c location : [select Id, Name, Street__c, City__c, State__c, Verified__c 
        //                                     from Location__c where Id IN :locIds]) {
        //         System.debug('Before triggering the verify call verification status = ' + location.Verified__c);
        //         Boolean isVerified = callSmartyStreetsAPI(location.Street__c, location.City__c, location.State__c);
        //         location.Verified__c = isVerified;
        //         System.debug('After triggering the verify call verification status = ' + isVerified);
        //         locationsToUpdate.add(location);
        //     }

        //     if (!locationsToUpdate.isEmpty()) {
        //         try {
        //             update locationsToUpdate;
        //         } catch (Exception e) {
        //             System.debug('Exception updating locations: ' + e.getMessage());
        //             ErrorLogUtil.insertErrorLog('VerifyLocationCallout udpate locations exception', e.getMessage(), 'VerifyLocationCallout.verifyLocations()');
        //         }
        //     }
        // }
    }