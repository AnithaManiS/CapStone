import { LightningElement, wire, track } from 'lwc';
import { NavigationMixin } from 'lightning/navigation';
import { refreshApex } from '@salesforce/apex';

import fetchLiveEvents  from '@salesforce/apex/EventDetailsController.fetchLiveEvents';

export default class EventList extends NavigationMixin(LightningElement) {
    searchName = '';
    searchLocation = '';
    searchStartDate = new Date();
    events;
    columns = [
        {
            label: 'Event Name', 
            fieldName: 'EventURL',
            type: 'url',
            typeAttributes: {
                label: { fieldName: 'Name__c' },
                target: '_blank',
            }
        },
        { label: 'Event Type', fieldName: 'Event_Type__c' },
        { label: 'Start Date', fieldName: 'Start_Date_Time__c' },
        { label: 'End Date', fieldName:  'End_Date_Time__c' },
        { label: 'Seats Available', fieldName: 'Remaining_Seats__c' }
    ];

    @wire(fetchLiveEvents, {
        searchName: '$searchName', 
        searchLocation: '$searchLocation',
        searchStartDate: '$searchStartDate'
    }) 
    wiredData(result) {
        if (result.data) {
            console.log('events fetched' + JSON.stringify(result.data));
            this.events = result.data.map(event => ({
                ...event,
                EventURL: '/' + event.Id 
            }));
        } else if (result.error) {
            console.error('events fetch error' + result.error); 
            this.events = [];
        }
    }

    openEventDetails(event) {
        const action = event.detail.action;
        const row = event.detail.row;
        console.log('event row action: ' + action);
        if (action.name === 'view') {
            console.log('navigating to record: ' + row.Id);
            this[NavigationMixin.Navigate]({
            type: 'standard__recordPage',
            attributes: {
                recordId: row.Id,
                actionName: 'view',
            }
            });
        }
    } 

    handleSearchNameChange(event) {
        this.searchName = event.target.value;
    }

    handleSearchStartDateChange(event) {
        this.searchStartDate = event.target.value;
    }

    handleSearchLocationChange(event) {
        this.searchLocation = event.target.value;
    }

    handleSearch() {
        refreshApex(this.events);
    }
 
}