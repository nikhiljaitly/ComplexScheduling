({
    doInit : function(component, event ,helper){
        //This function is used for intializing the timer after which the toast will disapper on its own
        var timer = component.get("v.timer");
        var toastType=component.get("v.toastType");
        
        if(timer!=undefined){
            //to hide the toast after mentioned time
            clearTimeout(timer);
            var timerSetOut = setTimeout(function() {
                $A.getCallback(function() {
                    component.set("v.displayToast", false);
                })();
            }, timer);
        }
    },    
    closeToast :function(component, event, helper) {
        helper.closeToastHelper(component, event, helper);
    },
   
})