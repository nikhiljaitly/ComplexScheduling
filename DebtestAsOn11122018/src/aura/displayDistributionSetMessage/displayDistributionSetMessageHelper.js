({
    showToast : function(type, message) {        
        console.log('toasthelper'); 
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            "message": message,
            "type": type,
            "duration": 10000,
            "mode": "dismissible",
        });
        toastEvent.fire();        
    },
    
    // This function call when component loads.   
    resetFlag : function(component, event, helper, type, message) {
         console.log('resethepler');
        console.log('recordId ' + component.get("v.recordId"));
        var action = component.get("c.ResetCostCentreTrade");
        action.setParams({
            'workorderId': component.get("v.recordId")
        })
        action.setCallback(this, function(response) {
            //store state of response
            var state = response.getState();
            if (state === "SUCCESS") {
                var storeResponse = response.getReturnValue();
                console.log('Response ' + JSON.stringify(storeResponse));                
            }
        });
        $A.enqueueAction(action);
        
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            "message": message,
            "type": type,
            "duration": 10000,
            "mode": "dismissible",
        });
        toastEvent.fire();    
        
    }  
    
})