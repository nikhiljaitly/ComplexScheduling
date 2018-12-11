({
	init : function(component, event, helper) {
		console.log('doInit:');
        var action = component.get("c.fetchClaimServiceWorkOrderLineItems"); 
        action.setParams({
            claimId: component.get("v.recordId")
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS" && response.getReturnValue() != '') {
                console.log(response.getReturnValue());
            }
            else if(state === "ERROR"){
                console.log('A problem occurred: ' + JSON.stringify(response.error));
            }
        });
        
        $A.enqueueAction(action);
	}
})