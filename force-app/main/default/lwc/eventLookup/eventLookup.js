import { LightningElement } from 'lwc';

export default class EventLookup extends LightningElement {
    // fieldsToCreate = ['Name','Rating','Phone','Industry']
    fields        = ['Name__c', 'Start_Date_Time__c', 'Location__c'];
    handleLookup = (event) => {
        let data = event.detail.data;
        if(data && data.record){
            // populate the selected record in the correct parent Id field
            this.allRecord[data.index][data.parentAPIName] = data.record.Id;
        }else{
            // clear the parent Id field
            this.allRecord[data.index][data.parentAPIName] = undefined;
        }
    }
}