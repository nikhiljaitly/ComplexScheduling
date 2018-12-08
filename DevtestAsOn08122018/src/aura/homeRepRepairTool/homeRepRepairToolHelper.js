({
	retrieveCase : function(component) {
		
		console.log('***Retrieving Case...');
		
		var repairItems = component.get("v._repair_items");
		console.log("***Repair Items: ");
		console.log(repairItems);
		if (!repairItems) {
			component.set("v._repair_items",[]);	
		}
		this.toggleProductSelection(component, true);
		component.set("v.showSpinner",true);
		var recordId = component.get("v.recordId");
		console.log("***Record Id = " + recordId);
		var getCase = component.get("c.getCaseRecord");
		getCase.setParams(
			{
				"caseId": recordId
			}
		);
		getCase.setCallback(this, function(response){
			console.log("***Executing getCase.setCallback()");
			var state = response.getState();
			component.set("v.showSpinner",false);
			if(component.isValid() && state === "SUCCESS"){
				component.set("v._record", response.getReturnValue());
				console.log("***Received Response:");
				console.log(response.getReturnValue());
			}else{
				console.log("Failed with state: "+ state);
			}
		});
		$A.enqueueAction(getCase);
	},

	retrieveRooms : function(component) {
		
		console.log('***Retrieving Case Rooms...');
		
		component.set("v._rooms",[]);
		this.toggleProductSelection(component, true);
		component.set("v.showSpinner",true);
		var recordId = component.get("v.recordId");
		console.log("***Record Id = " + recordId);
		var getCaseRooms = component.get("c.getCaseRooms");
		getCaseRooms.setParams(
			{
				"caseId": recordId
			}
		);
		getCaseRooms.setCallback(this, function(response){
			console.log("***Executing getCaseRooms.setCallback()");
			var state = response.getState();
			component.set("v.showSpinner",false);
			if(component.isValid() && state === "SUCCESS"){
				component.set("v._rooms", response.getReturnValue());
				console.log("***Received Response:");
				console.log(response.getReturnValue());
			}else{
				console.log("Failed with state: "+ state);
			}
		});
		$A.enqueueAction(getCaseRooms);
	},
		
	toggleProductSelection : function(component, displayProductsFlag){
		console.log("***Toggling Product Selection...");
		console.log("***Product Display Flag = " + displayProductsFlag);
		if (displayProductsFlag === true) {
			component.set("v.showProductSelection", true);
		} else {
			component.set("v.showProductSelection", false);
		}
		/*var repairItems = component.get("v._repair_items");
		if(repairItems.length > 0){
			console.log("***Show Products = FALSE");
			component.set("v.showProductSelection", false);
		}else{
			console.log("***Show Products = TRUE");
			component.set("v.showProductSelection", true);
		}*/
	},
	createRepairItems : function(component,repairItems, recordId) {
		
		console.log("[homeRepRepairToolHelper.createRepairItems] Creating Repair Items...");
				
		var pricebookId = component.get("v._pricebookId");
		var createRepairItems = component.get("c.createRepairItems");
		var payload = this.convertRepairItemsForBackend(repairItems);
		console.log("[homeRepRepairToolHelper.createRepairItems] Generated Payload:");
		console.log(payload);
		createRepairItems.setParams({
			"repairItemJSON":JSON.stringify(payload),
			"recordId": recordId,
			"pricebookId": pricebookId
		});
						
		createRepairItems.setCallback(this, function(response){
			var state = response.getState();
			component.set("v.showSpinner",false);
			if(component.isValid() && state === "SUCCESS"){
				console.log("[homeRepRepairToolHelper.createRepairItems] Successfully Created Repair Items...");
				if(response.getReturnValue().IsSuccess){
					component.set("v._repair_items",[]);                    
					this.retrieveCase(component);
					// show toast message
                    var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({
                        mode: 'sticky',
                        type: 'success',
                        message: 'Work Order(s) successfully created',
                    });
                    console.log('***Displaying Toast...');
                    toastEvent.fire();
					$A.get('e.force:refreshView').fire();	                    
				}else{
					this.handleErrorOfRepairItemsCreation(response, component);  
				}
			}else{
				console.log("Failed with state: "+ state);
			}
		});
		console.log("[homeRepRepairToolHelper.createRepairItems] Invoking Apex to Create Repair Items...");
		$A.enqueueAction(createRepairItems);
	},
	handleErrorOfRepairItemsCreation : function(response, component){
		//var oppAssTable = component.find("assessmentItemTable");
		//oppProdTable.handleError(response);
		console.error("[createRepairItems] Error during Work Order Creation");
		console.log(response);
	},
	convertRepairItemsForBackend : function(repairItems) {
		var convertedItems = [];
		repairItems.forEach(function(r) {
			// convert to more compact format for backend
			// with essential fields only
			var convertedItem = {};
			convertedItem.caseId = r.claim.Id;
			convertedItem.pbEntryId = r.pBEntry.Id;
			convertedItem.quantity = r.Quantity;
			convertedItem.unitPrice = r.UnitPrice;
			convertedItem.roomId = r.room.Id;
			convertedItem.workActionId = r.pBEntry.Product2.Work_Action__c;
			convertedItem.workItemDescription = r.pBEntry.Product2.Work_Item_Description__c;
			convertedItems.push(convertedItem);
		});
		return convertedItems;
	}
})