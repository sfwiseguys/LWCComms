import {
    LightningElement
} from 'lwc';

import publishEvent from '@salesforce/apex/POV_Controller.publishEvent';

export default class Pov_emp_fire_lwc extends LightningElement {

    message;


    handleChange(event) {
        this.message = event.detail.value;
    }

    firePlatformEvent() {

        if (!this.message) {
            return;
        }
        publishEvent({
                message: this.message
            })
            .then((result) => {
                console.log('Apex Called. Platform Event Fired.');
            })
            .catch((error) => {
                console.log('Apex error = ' + error);
            })

    }
}