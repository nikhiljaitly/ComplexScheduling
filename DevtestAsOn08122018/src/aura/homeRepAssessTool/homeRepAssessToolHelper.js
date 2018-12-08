({
	retrieveCase : function(component) {

		console.log('***Retrieving Case...');

		component.set("v._assessment_items",[]);
		this.toggleProductSelection(component);
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

	toggleProductSelection : function(component){
		console.log("***Toggling Product Selection...");
        var assessItems = component.get("v._assessment_items");
        if(assessItems.length > 0){
			console.log("***Show Products = FALSE");
        	component.set("v.showProductSelection", false);
        }else{
			console.log("***Show Products = TRUE");
            component.set("v.showProductSelection", true);
        }
    },
    createAssessmentItems : function(component,assessmentItems, recordId) {

        console.log("[homeRepAssessToolHelper.createAssessmentItems] Creating Assessment Items...");
        
        var createAssessmentItems = component.get("c.createAssessmentItems");
        createAssessmentItems.setParams({
            "assessmentItemJSON":JSON.stringify(assessmentItems),
            "recordId": recordId
        });
                
        createAssessmentItems.setCallback(this, function(response){
            var state = response.getState();
            component.set("v.showSpinner",false);
            if(component.isValid() && state === "SUCCESS"){
                console.log("[homeRepAssessToolHelper.createAssessmentItems] Successfully Created Assessment Report Items...");
                if(response.getReturnValue().IsSuccess){
                    component.set("v._assessment_items",[]);                    
                    this.retrieveCase(component);
                    // show toast message
                    var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({
                        mode: 'sticky',
                        type: 'success',
                        message: 'Report Assessment Item(s) successfully created',
                    });
                    console.log('***Displaying Toast...');
                    toastEvent.fire();
                    $A.get('e.force:refreshView').fire();	                    
                }else{
                    this.handleErrorOfAssessmentItemsCreation(response, component);  
                }
            }else{
                console.log("Failed with state: "+ state);
            }
        });
        console.log("[homeRepAssessToolHelper.createAssessmentItems] Invoking Apex to Create Assessment Report Items...");
        $A.enqueueAction(createAssessmentItems);
    },
    handleErrorOfAssessmentItemsCreation : function(response, component){
        var oppAssTable = component.find("assessmentItemTable");
        oppProdTable.handleError(response);
    },
})