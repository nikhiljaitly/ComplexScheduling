({

    afterScriptsLoaded : function(component, event, helper) { 
        component.set('v.scriptsLoaded', true);
        console.log("script loaded");
    },

})