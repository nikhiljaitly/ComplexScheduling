({
	doInit : function(component, event, helper){
        console.log('doInit Service:'+component.get("v.recordId"));
        var action = component.get("c.getAllServiceAppointments"); 
        action.setParams({
            parentId : component.get("v.recordId")
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            console.log('Data ',response.getReturnValue());
            if (state === "SUCCESS" && response.getReturnValue() != '') {
                component.set("v.listOfAllServices", response.getReturnValue());
                component.set("v.numRecords",response.getReturnValue().length);
            }
            else if(state === "ERROR"){
                console.log('A problem occurred: ' + JSON.stringify(response.error));
            }
        });
        
        $A.enqueueAction(action);
	}
})