({
	initClaimPlanner : function(component) {
    var that = this;
    that.getClaimData(component);
	},
  getClaimData : function(component) {
      var action = component.get("c.initClaimPlanner"); 
      action.setParams({
          claimId : component.get("v.recordId")
      });
      action.setCallback(this, function(response) {
          var state = response.getState();
          if (state === "SUCCESS" && response.getReturnValue() != '') {
            component.set("v.claimInfo", response.getReturnValue());
            console.log(component.get("v.claimInfo"));
          }
          else if(state === "ERROR"){
              console.log('A problem occurred: ' + JSON.stringify(response.error));
          }
      });
      $A.enqueueAction(action);
  }
})