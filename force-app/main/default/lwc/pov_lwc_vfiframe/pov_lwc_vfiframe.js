import {
    LightningElement,
    wire
} from 'lwc';

import getVFOrigin from '@salesforce/apex/POV_Controller.getVFOrigin';

export default class pov_lwc_vfiframe extends LightningElement {
    msg = '';
    receivedMessage = '';
    error;



    // Wire getVFOrigin Apex method to a Property
    @wire(getVFOrigin)
    vfOrigin;


    /*****Called on LOAD of LWC  *****/
    connectedCallback() {
        // Binding EventListener here when Data received from VF
        window.addEventListener("message", this.handleVFResponse.bind(this));
    }

    handleVFResponse(message) {
        if (message.origin === this.vfOrigin.data) {
            this.receivedMessage = message.data;
        }
    }


    handleChange(event) {
        this.msg = event.detail.value;
    }

    handleFiretoVF() {
        let message = this.msg;
        //Firing an event to send data to VF
        this.template.querySelector("iframe").contentWindow.postMessage(message, this.vfOrigin.data);
    }
}