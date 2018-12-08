({
	init : function(component, event, helper) {
		console.log('***Initialising the Home Repair Assessment Tool...');
		helper.retrieveCase(component);
	},
	afterCaseLoads: function(component, event, helper){
		console.log('***Executing afterCaseLoads()...');
        component.set("v.showSpinner", false);
	},
	createAssessmentItem : function(component, event, helper) {
		var selectedProducts = event.getParam("_selected_products");
		console.log("[homeRepAssessTool.createAssessmentItem] Creating Assessment Items:");
		console.log(selectedProducts);
		component.set("v._assessment_items", selectedProducts);
        helper.toggleProductSelection(component);
	},
    handleAssessmentItems : function(component, event, helper){
    	var command = event.getParam("command");
        if(command === "save"){
            var assessmentItems = component.get("v._assessment_items");
            var recordId = component.get("v.recordId");
            console.log("***[homeRepAssessToolController.handleAssessmentItems] Record Id = " + recordId);
            console.log("***[homeRepAssessToolController.handleAssessmentItems] Items to be Saved:");
            console.log(assessmentItems);
            if(assessmentItems.length > 0){
                helper.createAssessmentItems(component,assessmentItems, recordId);
            }
        }else if (command === "cancel"){
            component.set("v._assessment_items",[]);
            helper.retrieveCase(component);
        }
    }
})