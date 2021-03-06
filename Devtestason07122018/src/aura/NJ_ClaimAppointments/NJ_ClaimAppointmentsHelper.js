({
	populateClaimServiceData : function(component) {
		console.log("***[ClaimSrvApptManagerHelper.populateClaimServiceData] Getting Claim Service Data...");
        // display the spinner
        component.set("v.isProcessing",true);
        
		// set up and execute call to Apex Controller
        var claimId = component.get("v.claimId");
        console.log("***[ClaimSrvApptManagerHelper.populateClaimServiceData] Retrieving Service Data for Claim Id: " + claimId);
        var getClaimServiceData = component.get("c.getClaimServiceData");
		getClaimServiceData.setParams(
			{
				"claimId": claimId
			}
		);
		getClaimServiceData.setCallback(this, function(response){
			console.log("***[ClaimSrvApptManagerHelper.populateClaimServiceData] Executing populateClaimServiceData.setCallback()");
			var state = response.getState();
			if(component.isValid() && state === "SUCCESS"){
				console.log("***[ClaimSrvApptManagerHelper.populateClaimServiceData] Received Response:");
				console.log(response.getReturnValue());
				 
                // transform the Claim Service Data returned into format suitable for
                // lightning:tree component
                var claimServiceTreeData = this.transformClaimServiceData(component, JSON.parse(response.getReturnValue()));
                component.set("v.claimServiceData", claimServiceTreeData);
                //console.log("***[ClaimSrvApptManagerHelper.populateClaimServiceData] Transformed Claim Service Data:");
                //console.log(claimServiceTreeData);                
			}else{
				console.log("***[ClaimSrvApptManagerHelper.populateClaimServiceData] Failed with state: "+ state);
			}
            // hide the spinner
        	component.set("v.isProcessing",false);
		});
		$A.enqueueAction(getClaimServiceData);
    },
    // helper method to transform claim service data returned
    // by Apex Controller into a suitable format for lightning:tree
    transformClaimServiceData : function(component, claimServiceData) {
        // populate first level in tree
        var claimServiceDataTree = [];
        for (var x = 0; x < claimServiceData.length; x++) {
            var index = x+1;
            var currWorkOrder = claimServiceData[x];
            var newTreeItem = {};
            component.set("v.claimInfo", currWorkOrder.claimNumber);
            newTreeItem.label = index+". "+ currWorkOrder.workTypeName + " - " + currWorkOrder.appointmentNumber + " - "+ currWorkOrder.appointmentDuration + "-" + currWorkOrder.workOrderNumber;
            newTreeItem.name = currWorkOrder.appointmentId;
           newTreeItem.metatext = currWorkOrder.appointmentStatus;
            newTreeItem.expanded = false;
            // populate 2nd level in tree
            newTreeItem.items = [];
            if(currWorkOrder.workScopeList){
                console.log('here');
                for (var y = 0; y < currWorkOrder.workScopeList.length; y++) {
                    var workScope = currWorkOrder.workScopeList[y];
                    var newSlotTreeItem = {};
                    newSlotTreeItem.label = (y+1)+'. '+ workScope.productName;
                    newSlotTreeItem.name = currWorkOrder.appointmentNumber;
                    newSlotTreeItem.metatext = workScope.prodDescription;

                    newSlotTreeItem.expanded = false;
                    newTreeItem.items.push(newSlotTreeItem);
                }
            }
            claimServiceDataTree.push(newTreeItem);
            
        }
        console.log(claimServiceDataTree);
        return claimServiceDataTree;
    },
   
 /*   getClaimInfo: function(component, event, helper) {
 
      //call apex class method
      var action = component.get('c.getClaimNumber');
 
      action.setCallback(this, function(response) {
        //store state of response
        var state = response.getState();
        if (state === "SUCCESS") {
          //set response value in claimNoWrapper attribute on component.
          component.set('v.claimNoWrapper', response.getReturnValue());
        }
      });
      $A.enqueueAction(action);
    }, */
  
})