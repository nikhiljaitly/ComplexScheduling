({
	doInit : function(component, event, helper){
        console.log('doInit:');
        var action = component.get("c.fetchWorkOrderLineItems"); 
        action.setParams({
            objectId: component.get("v.recordId")
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            console.log('WorkOrderLineItem',response.getReturnValue());
            if (state === "SUCCESS" && response.getReturnValue() != '') {
                component.set("v.listOfWorkOderLineItem", response.getReturnValue());
            }
            else if(state === "ERROR"){
                console.log('A problem occurred: ' + JSON.stringify(response.error));
            }
        });                
        $A.enqueueAction(action);
	},
     handleEdit: function (cmp, event, helper) {
        var selectedMenuItemValue = event.getParam("value");
        console.log('selectedMenuItemValue'+selectedMenuItemValue);
        cmp.set("v.selectedId", selectedMenuItemValue); //id retrieved earlier
        var editRecordEvent = $A.get("e.force:editRecord");
        editRecordEvent.setParams({
             "recordId": selectedMenuItemValue
       });
        editRecordEvent.fire();
    }
})