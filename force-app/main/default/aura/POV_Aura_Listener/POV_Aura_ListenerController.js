({
    
    // LISTENER
    handleReceiveMessage: function (component, event, helper) {
        if (event != null) {
            const message = event.getParam('messageBody');
            const source = event.getParam('source');
            component.set("v.receivedMessage", 'Message: ' + message + '.\n\n Sent From: ' + source);
        }
    }
});