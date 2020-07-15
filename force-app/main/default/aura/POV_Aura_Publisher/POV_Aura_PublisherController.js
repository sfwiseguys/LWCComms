({
    
    //PUBLISHER
    handlePublish: function(component, event, helper) {
        let sendingmsg = component.get("v.message");
        const payload = {
            source: "Aura",
            messageBody: sendingmsg
        };
        component.find("SENDPOVMC").publish(payload);
    },

});