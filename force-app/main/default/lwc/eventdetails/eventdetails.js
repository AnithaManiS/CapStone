import { LightningElement, api, wire } from 'lwc';
import { getRecord, getFieldValue, getFieldDisplayValue } from 'lightning/uiRecordApi';
import { NavigationMixin } from 'lightning/navigation';
import { encodeDefaultFieldValues } from 'lightning/pageReferenceUtils';

import NAME_FIELD from '@salesforce/schema/Event__c.Name__c';
import START_DATE_TIME_FIELD from '@salesforce/schema/Event__c.Start_Date_Time__c';
import END_DATE_TIME_FIELD from '@salesforce/schema/Event__c.End_Date_Time__c';

import fetchSpeaker from '@salesforce/apex/EventDetailsController.fetchSpeaker';
import fetchLocation from '@salesforce/apex/EventDetailsController.fetchLocation';
import fetchAttendees from '@salesforce/apex/EventDetailsController.fetchAttendees';


export default class EventDetails extends NavigationMixin(LightningElement) {
  @api recordId;
  eventName;
  eventStartDateTime;
  eventEndDateTime;
  speaker;
  location;
  attendees;

  // defaultValues = encodeDefaultFieldValues({
  //   Event__c: this.recordId
  // });
 
  speakerColumns = [
    { label: 'Name', fieldName: 'Name' },
    { label: 'Phone', fieldName: 'Phone__c' },
    { label: 'Email', fieldName: 'Email__c' },
    { label: 'Profile', fieldName: 'ProfileURL__c' }
  ];

  locationColumns = [
    { label: 'Name', fieldName: 'Name' },
    { label: 'Street', fieldName: 'Street__c' },
    { label: 'City', fieldName: 'City__c' },
    { label: 'Postal Code', fieldName: 'Postal_Code__c' },
    { label: 'State', fieldName: 'State__c' },
    { label: 'Country', fieldName: 'Country__c' }
  ];

  attendeeColumns = [
    { label: 'Name', fieldName: 'Name' },
    { label: 'Phone', fieldName: 'Phone__c' },
    { label: 'Email', fieldName: 'Email__c' }
  ];


  @wire(getRecord, { recordId: '$recordId', fields: [NAME_FIELD, START_DATE_TIME_FIELD, END_DATE_TIME_FIELD] })
  wiredEventRecord({ error, data }) {
    if (data) {
      console.log('Event record of ' + JSON.stringify(data));
      this.eventName = getFieldValue(data, NAME_FIELD);
      this.eventStartDateTime = getFieldValue(data, START_DATE_TIME_FIELD);
      this.eventEndDateTime = getFieldValue(data, END_DATE_TIME_FIELD);
    } else if (error) {
      console.error(error);
    }
  }

  @wire(fetchSpeaker, { cacheKey: 'speaker-' + '$recordId', eventId: '$recordId' })
  wiredSpeakers({ error, data }) {
    if (data) {
      console.log('speakers Data from Apex ' + JSON.stringify(data));
      this.speaker = data;
    } else if (error) {
      console.log('speakers Data error from Apex ' + JSON.stringify(error) + JSON.stringify(data));
      console.error(error);
    }
  }

  @wire(fetchLocation, { cacheKey: 'location-' + '$recordId', eventId: '$recordId' })
  wiredLocation({ error, data }) {
    if (data) {
      console.log('Event location from Apex ' + JSON.stringify(data));
      this.location = data;
    } else if (error) {
      console.log('Location Data error from Apex ' + JSON.stringify(error) + JSON.stringify(data));
      console.error(error);
    }
  }

  @wire(fetchAttendees, { cacheKey: 'attendee-' + '$recordId', eventId: '$recordId' })
  wiredAttendees({ error, data }) {
    if (data) {
      console.log('attendees Data from Apex ' + data);
      this.attendees = data;
    } else if (error) {
      console.log('attendees Data error from Apex ' + data);
      console.error(error);
    }
  }

  handleNewSpeaker() {
    console.log('Navigating to new speaker page for the event: ' + this.recordId);
    let defaultValues = {
      Event__c: this.recordId
    }
    let encodedDefaultValues = encodeDefaultFieldValues(defaultValues);

    this[NavigationMixin.Navigate]({
      type: 'standard__objectPage',
      attributes: {
        objectApiName: 'Event_Speaker__c',
        actionName: 'new'
      },
      state: {
        defaultFieldValues: encodedDefaultValues
      }
    });
  }

  handleNewAttendee() {
    console.log('Navigating to new attendee page for the event: ' + this.recordId);

    let defaultValues = {
      Event__c: this.recordId
    }
    let encodedDefaultValues = encodeDefaultFieldValues(defaultValues);

    this[NavigationMixin.Navigate]({
      type: 'standard__objectPage',
      attributes: {
        objectApiName: 'Event_Attendee__c', 
        actionName: 'new'
      },
      state: {
        defaultFieldValues: encodedDefaultValues
      }
    });
  }

}