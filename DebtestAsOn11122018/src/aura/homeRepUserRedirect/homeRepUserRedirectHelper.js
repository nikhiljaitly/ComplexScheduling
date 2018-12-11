({
  handleActionError : function(aState, aError, aSource){
    // Handle error after access to database
    if (aState === "INCOMPLETE") {
      console.log(aSource + " No response from server or client is offline.")
    } else if (aState === "ERROR") {
      if (aError) 
        if (aError[0] && aError[0].message) 
          console.log(aSource + " Error message: " + aError[0].message);
    } else 
      console.log("Unknown error");
  },

  redirectToContact: function(component, event, helper) {
    var navEvt, state;

    var action = component.get("c.getContactId");
    action.setCallback(this, function(response) {
        state = response.getState();
        if (state === "SUCCESS" && response.getReturnValue() !='null') {
            var loggedUser = JSON.parse(response.getReturnValue());
            navEvt = $A.get("e.force:navigateToSObject");
            navEvt.setParams({
                "recordId": loggedUser.ContactId,
                "slideDevName": "detail"
            });
            navEvt.fire();
        } else
          this.handleActionError(state, response.getError(), 'executeUpdateCallback');
    });
    $A.enqueueAction(action);
}
})