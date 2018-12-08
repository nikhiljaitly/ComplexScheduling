({
	onSave : function(component, event, helper) {

	    // Ask Lightning Data Service to save the record
        component.find("recordLoader").saveRecord($A.getCallback(function(saveResult) {
            if (saveResult.state === "SUCCESS") {

                // Display popup confirmation to the user
                var resultsToast = $A.get("e.force:showToast");
                resultsToast.setParams({
                    "title": "Saved",
                    "message": "The record was updated."});
                resultsToast.fire();
                
                // Navigate back to the record view
                var navigateEvent = $A.get("e.force:navigateToSObject");
                navigateEvent.setParams({ "recordId": component.get('v.recordId') });
                navigateEvent.fire();
            }
            else {
                // Basic error handling
                component.set('v.recordError', 
                    'Error: ' + saveResult.state + ', message: ' + JSON.stringify(saveResult.error));
            }
        }));
	},
    onCancel : function(component, event, helper) {    
        // Navigate back to the record view
        var navigateEvent = $A.get("e.force:navigateToSObject");
        navigateEvent.setParams({ "recordId": component.get('v.recordId') });
        navigateEvent.fire();
    }
})