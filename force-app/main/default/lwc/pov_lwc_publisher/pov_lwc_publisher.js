import {
    LightningElement,
    track,
    wire
} from 'lwc';
import {
    MessageContext,
    APPLICATION_SCOPE,
    publish
} from 'lightning/messageService';
import POVMC from "@salesforce/messageChannel/POVMessageChannel__c";
export default class pov_lwc_publisher extends LightningElement {
    @track msg = '';

    // Wired message Context
    @wire(MessageContext)
    context;

    handleChange(event) {
        this.msg = event.detail.value;
    }

    handlePublish() {
            let payload = {
                source: "LWC",
                messageBody: this.msg
            };
            publish(this.context, POVMC, payload);
        
    }
}