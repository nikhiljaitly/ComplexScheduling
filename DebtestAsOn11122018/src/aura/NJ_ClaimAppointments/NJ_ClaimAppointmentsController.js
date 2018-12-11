({
	init : function(component, event, helper) {
		console.log("***[ClaimSrvApptManagerController.init] Initialising Component...");
        console.log("***[ClaimSrvApptManagerController.init] Claim Id = " + component.get("v.claimId"));
        helper.populateClaimServiceData(component);
	},
    changeExpandedView : function(component, event, helper) {
        let expandView = component.get("v.expandedView");
        component.set("v.expandedView", !expandView);
    },
    
    // handle selection in tree
    // process selection and fire an application
    // event for interested components
    handleClaimServiceDataTreeSelect: function (component, event) {
        
        event.preventDefault();
        var treeSelection = event.getParam('name');
        var eventMessageTypeValue = "";
        var eventSelectedAppt = "";
        if (treeSelection !== "NotSelectable") {
        	console.log('***[ClaimSrvApptManagerController.handleClaimServiceDataTreeSelect] Selected Appointment:' + event.getParam('name'));    
            eventMessageTypeValue = "APPOINTMENT_SELECTED";
            eventSelectedAppt = event.getParam('name');
        } else {
        	console.log('***[ClaimSrvApptManagerController.handleClaimServiceDataTreeSelect] Selected:' + event.getParam('name'));
            eventMessageTypeValue = "NON_APPOINTMENT_SELECTED";
            eventSelectedAppt = event.getParam('name');
        }
        // fire an event to indicate a service appointment has been selected
        // Get the application event by using the
        // e.<namespace>.<event> syntax
        var appEvent = $A.get("e.c:ClaimSrvApptManagerSelectionEvent");
        appEvent.setParams({
            "messageType" : eventMessageTypeValue,
            "selectedAppt" : eventSelectedAppt
        });
        appEvent.fire();
    },
    handleSvcApptMgrScheduledEvent: function(component, event, helper) {
        console.log("[ClaimSrvApptManagerController.handleSvcApptMgrScheduledEvent] Handling SvcApptMgrScheduledEvent...");
        // refresh Worder Order and SA List
        helper.populateClaimServiceData(component);
        
    },
    
})