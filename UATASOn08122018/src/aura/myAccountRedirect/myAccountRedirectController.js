({
    doInit: function(component, event, helper) {
console.log('Hide');
        var loggedInUser;
        var state;
        var navEvt;
        
        var action = component.get("c.getContactId");
        action.setCallback(this, function(response) {
            state = response.getState();
            if (state === "SUCCESS") {
                console.log('Hide');
                //document.getElementsByClassName('forceChatterScroller')[0].style.display='None';
                loggedInUser = JSON.parse(response.getReturnValue());
/*
                navEvt = $A.get("e.force:navigateToURL");
                navEvt.setParams({
                    "url": '/my-account/'+loggedInUser.Contact.AccountId,
                    "isredirect":false,
                    'recordId':loggedInUser.Contact.AccountId,
                    "slideDevName": "detail"
*/
            navEvt = $A.get("e.force:navigateToSObject");
            navEvt.setParams({
                "recordId": loggedInUser.Contact.AccountId,
                "slideDevName": "detail"

                });
                navEvt.fire();
                
            }
        });
        $A.enqueueAction(action);
    }
})