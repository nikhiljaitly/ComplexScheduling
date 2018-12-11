({
    scriptsLoaded : function(component, event, helper) { 
        component.set('v.scriptsLoaded', true);
    },
    handleClaimManager : function(component, event, helper) {
    	  helper.drawChart(component, helper);
    }
})