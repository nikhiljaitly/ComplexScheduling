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
                var claimServiceTreeData = this.transformClaimServiceData(response.getReturnValue());
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
    transformClaimServiceData : function(claimServiceData) {
        // populate first level in tree
        var claimServiceDataTree = [];
        for (var x = 0; x < claimServiceData.length; x++) {
            var currWorkOrder = claimServiceData[x];
            var newTreeItem = {};
            newTreeItem.label = currWorkOrder.workTypeName + " (" + currWorkOrder.workOrderNumber + ")" 
            newTreeItem.name = "NotSelectable";
            newTreeItem.metatext = currWorkOrder.workOrderStatus
            newTreeItem.expanded = true;
            // populate 2nd level in tree
            newTreeItem.items = [];
            for (var y = 0; y < currWorkOrder.srvAppointments.length; y++) {
                var currAppt = currWorkOrder.srvAppointments[y];
                var newSlotTreeItem = {};
                newSlotTreeItem.label = currAppt.srvApptNumber + " - " + currAppt.srvApptSubject;
                newSlotTreeItem.name = currAppt.srvApptId;
                newSlotTreeItem.metatext = "Status: " + currAppt.srvApptStatus;
                newSlotTreeItem.expanded = false;
                newTreeItem.items.push(newSlotTreeItem);
            }
            claimServiceDataTree.push(newTreeItem);
        }
        return claimServiceDataTree;
    },
})