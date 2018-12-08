({
	initClaimPlanner : function(component) {
    var that = this;
    that.getClaimData(component);
	},
  getClaimData : function(component) {
      var action = component.get("c.initClaimPlanner"); 
      var that = this;
      action.setParams({
          claimId : component.get("v.recordId")
      });
      action.setCallback(this, function(response) {
          var state = response.getState();
          if (state === "SUCCESS" && response.getReturnValue() != '') {
            var claimInfo = response.getReturnValue();
            component.set("v.claimInfo", claimInfo);
            component.set("v.hasWorkOrder", claimInfo.hasWorkOrder);
            if(claimInfo.hasWorkOrder === false) {
              that.displayError(component, "Error", "This claim doesn't have any work orders");
            } 
            console.log(component.get("v.claimInfo"));
          }
          else if(state === "ERROR"){
              console.log('A problem occurred: ' + JSON.stringify(response.error));
          }
      });
      $A.enqueueAction(action);
  },
  displayError : function(component, title, messg) {
        component.set("v.showError", true);
        component.set("v.errorTitle", title);
        component.set("v.errorMesg", messg);
    },
})