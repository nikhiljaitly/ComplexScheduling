({
	init : function(component, event, helper) {
        console.log('***Initialising the Home Repair Repair Item Tool...');
        // hardcoded pricebook id is VERY bad and should be moved to custom
		// setting in a production build
		component.set("v._pricebookId", "01s7F000005F7weQAC");
        helper.retrieveCase(component);
        helper.retrieveRooms(component);
	},
	afterCaseLoads: function(component, event, helper){
		console.log('***Executing afterCaseLoads()...');
        component.set("v.showSpinner", false);
        helper.toggleProductSelection(component, true);
	},
	createRepairItem : function(component, event, helper) {
        var selectedProducts = event.getParam("_selected_products");
        var existingRepItems = component.get("v._repair_items");
        var newRepairItems = existingRepItems.concat(selectedProducts);
        console.log("[homeRepRepairTool.createRepairItem] Existing Repair Items:");
		console.log(existingRepItems);
		console.log("[homeRepRepairTool.createRepairItem] Adding Repair Items:");
        console.log(selectedProducts);
        console.log("[homeRepRepairTool.createRepairItem] Concatenated Repair Items:")
        console.log(newRepairItems);
        //component.set("v._repair_items", selectedProducts);
        component.set("v._repair_items", newRepairItems);
        helper.toggleProductSelection(component, false);
	},
    handleRepairItems : function(component, event, helper){
    	var command = event.getParam("command");
        if(command === "save"){
            var repairItems = component.get("v._repair_items");
            var recordId = component.get("v.recordId");
            console.log("***[homeRepRepairToolController.handleRepairItems] Record Id = " + recordId);
            console.log("***[homeRepRepairToolController.handleRepairItems] Items to be Saved:");
            console.log(repairItems);
            // re-enable when developing backend functionality
            if(repairItems.length > 0){
                helper.createRepairItems(component,repairItems, recordId);
            }
        }else if (command === "cancel"){
            //component.set("v._repair_items",[]);
            helper.retrieveCase(component);
            helper.retrieveRooms(component);
        }
    },
})