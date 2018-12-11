({
    onSuccess : function(component, event, helper) {
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            "title": "Success!",
            "message": "The record has been Saved successfully."
        });
        //helper.showToast(type, message);
       toastEvent.fire();
    },
    onSubmit : function(component, event, helper) {
    },
    onLoad : function(component, event, helper) {
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            "title": "Loaded!",
            "message": "The record has been Loaded successfully ."
        });
        //helper.showToast(type, message);
        toastEvent.fire();     
    },
    onError : function(component, event, helper) {
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            "title": "Error!",
            "message": "Error."
        });
        toastEvent.fire();
    },
    
    /*doInit : function(component, event, helper){
        console.log('***doInit begin');
        var action = component.get("c.HRpricebookEntry"); 
        
        action.setParams({
           objectId: component.get("v.recordId")
        });
        console.log('In DoInit*****');
        console.log(component.get("v.recordId"));
        action.setCallback(this, function(response) {
            
            var state = response.getState();
            console.log('*****State****');
            console.log(state);
            
            if (state === "SUCCESS" ) {
                component.set("v.listOfPriceBookEntries", response.getReturnValue());
                component.find("productLookup").set("v.value", component.get("v.listOfPriceBookEntries"));
                console.log('listOfPriceBookEntries: ' + JSON.stringify(component.get("v.listOfPriceBookEntries")));
            }
            else if(state === "ERROR"){
                console.log('A problem occurred: ' + JSON.stringify(response.error));
            }
        });
        console.log(action);
        $A.enqueueAction(action);        
        
	}*/
    
    
    getValueFromCompEvent : function(component, event, helper){
        console.log('***getValueFromCompEvent begin');
        var showLabVal = event.getParam("PassLabVal");
        console.log('showLabVal ' + showLabVal);
        component.set("v.labourCost", showLabVal);
        console.log('eventLabCost1 ' + component.get("v.labourCost"));
	}
    
})