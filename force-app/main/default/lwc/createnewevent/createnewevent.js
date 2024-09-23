import { LightningElement, api } from 'lwc';
import { NavigationMixin } from 'lightning/navigation';

import EVENT_OBJECT from "@salesforce/schema/Event__c";
import NAME_FIELD from "@salesforce/schema/Event__c.Name__c";
import ORGANIZER_FIELD from "@salesforce/schema/Event__c.Event_Organizer__c";
import START_DATE_FIELD from "@salesforce/schema/Event__c.Start_Date_Time__c";
import END_DATE_FIELD from "@salesforce/schema/Event__c.End_Date_Time__c";
import MAX_SEATS_FIELD from "@salesforce/schema/Event__c.Max_Seats__c";
import EVENT_DETAIL_FIELD from "@salesforce/schema/Event__c.EventDetail__c";

export default class CreateNewEvent extends NavigationMixin(LightningElement) {
    @api objectApiName; //only on record page
    @api recordId;
    myFields = [NAME_FIELD, ORGANIZER_FIELD, START_DATE_FIELD, END_DATE_FIELD, MAX_SEATS_FIELD, EVENT_DETAIL_FIELD];

    handleSuccessOnCreate(event){
        //Access id of record : event.detail.id

        //Navigation of the component
        let pageReference = {
            type: 'standard__recordPage',
            attributes: {
                recordId: event.detail.id,
                objectApiName: this.objectApiName,
                actionName: 'view'
            }
         }
        this[NavigationMixin.Navigate](pageReference)
    }
}