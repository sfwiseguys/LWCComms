import {
    LightningElement
} from 'lwc';
import {
    subscribe,
    unsubscribe,
    onError,
    setDebugFlag,
    isEmpEnabled
} from 'lightning/empApi';

import {
    ShowToastEvent
} from 'lightning/platformShowToastEvent';

export default class Pov_emp_lwc extends LightningElement {
    channelName = '/event/POV_Platform_Event__e';
    isSubscribeDisabled = false;
    isUnsubscribeDisabled = !this.isSubscribeDisabled;
    receivedMessage;

    subscription = {};

    // Initializes the component
    connectedCallback() {
        // Register error listener       
        this.registerErrorListener();
       
    }

    // Handles subscribe button click
    handleSubscribe() {

        // ARROW function is very important here. We have to use arrow function as it does not have its own scope
        const messageCallback = (response) => {
            this.handleResponse(response);
        }

        // Invoke subscribe method of empApi. Pass reference to messageCallback
        subscribe(this.channelName, -1, messageCallback).then(response => {
            // Response contains the subscription information on subscribe call
            console.log('Subscription request sent to: ', JSON.stringify(response.channel));
            this.subscription = response;
            this.toggleSubscribeButton(true);
        });

        
    }

    handleResponse(response){
        console.log('*** Inside outsideprocessing'+JSON.stringify(response));
        this.receivedMessage = response.data.payload.Message__c;
        console.log(this.receivedMessage);
    }

    
    // Handles unsubscribe button click
    handleUnsubscribe() {
        this.toggleSubscribeButton(false);

        // Invoke unsubscribe method of empApi
        unsubscribe(this.subscription, response => {
            console.log('unsubscribe() response: ' + JSON.stringify(response));
            
            // Response is true for successful unsubscribe
        });
    }

    toggleSubscribeButton(enableSubscribe) {
        this.isSubscribeDisabled = enableSubscribe;
        this.isUnsubscribeDisabled = !enableSubscribe;
    }

    registerErrorListener() {
        // Invoke onError empApi method
        onError(error => {
            console.log('Received error from server: ', JSON.stringify(error));
            // Error contains the server-side error
        });
    }
}