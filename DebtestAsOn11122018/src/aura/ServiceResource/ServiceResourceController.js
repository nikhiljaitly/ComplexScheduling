({
    doInit : function(component, event, helper){
        console.log('doInit:');
        var action = component.get("c.getServiceResources"); 
        action.setCallback(this, function(response) {
            var state = response.getState();
            console.log('listOfServiceResource',response.getReturnValue());
            if (state === "SUCCESS" && response.getReturnValue() != '') {
                component.set("v.listOfServiceResource", response.getReturnValue());
            }
            else if(state === "ERROR"){
                console.log('A problem occurred: ' + JSON.stringify(response.error));
            }
        });                
        $A.enqueueAction(action);
	},
    redirectToRecord : function(component, event, helper){
        console.log(event.target.id);
        var navEvt;
        navEvt = $A.get("e.force:navigateToSObject");
        navEvt.setParams({
            "recordId": event.target.id,
            "isredirect": true
        });
        navEvt.fire();      
    }
})