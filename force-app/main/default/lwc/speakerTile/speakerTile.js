import { LightningElement, wire, api } from 'lwc';
import { getRecord, getFieldValue } from 'lightning/uiRecordApi';

import NAME_FIELD from '@salesforce/schema/Speaker__c.Name';
import EMAIL_FIELD from '@salesforce/schema/Speaker__c.Email__c';
import PHONE_FIELD from '@salesforce/schema/Speaker__c.Phone__c';


export default class SpeakerTile extends LightningElement {
    @api recordId;
    speakerName;
    speakerEmail;
    speakerPhone;

    @wire(getRecord, { recordId: '$recordId', fields: [NAME_FIELD, EMAIL_FIELD, PHONE_FIELD] })
    wiredSpeakerTileRecord({ error, data }) {
    if (data) {
      console.log('Speaker record of ' + JSON.stringify(data));
      this.speakerName = getFieldValue(data, NAME_FIELD);
      this.speakerEmail = getFieldValue(data, EMAIL_FIELD);
      this.speakerPhone = getFieldValue(data, PHONE_FIELD);
    } else if (error) {
      console.error(error);
    }
  }
}