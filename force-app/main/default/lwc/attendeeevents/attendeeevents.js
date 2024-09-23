import { LightningElement, api, wire } from 'lwc';
import fetchEvents from '@salesforce/apex/EventAttendeeController.fetchEvents';

export default class AttendeeEvents extends LightningElement {
    @api recordId;
    upcomingEvents = [];
    pastEvents = [];
    
    errorMessage;
    activeSectionName = ''; // To control accordion expansion

    handleToggleSection(event) {
        this.activeSectionName = event.detail.openSections[0]; // Get the first open section
    }

    @wire(fetchEvents, { attendeeId: '$recordId' })
    wiredEvents({ error, data }) {
        if (data) {
            if (data.length > 0) {
                this.upcomingEvents = data[0];
            }
            if (data.length > 1) {
                this.pastEvents = data[1];
            }
            this.errorMessage = undefined;
        } else if (error) {
            this.errorMessage = 'Error loading events. Please try again later.';
            console.error(error);
        }
    }

}