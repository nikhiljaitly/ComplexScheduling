({
	createWOLI : function(component, woli) {
		var addWOLI = component.get("c.addWOLI");
        //product params
        var prodLabCost = component.get("v.LabourCost");
        var prodMatCost = component.get("v.Materialcost");
        var prodId = component.get("v.ProductId");
        var woId = component.get("v.recordId");
        
        woli.Product2Id = prodId;
        woli.Labour_Cost__c = prodLabCost;
        woli.Material_Cost__c = prodMatCost;
        woli.WorkOrderId = woId;
        
        console.log("****woli: " + JSON.stringify(woli));
        
        addWOLI.setParams({"WOLI" : woli});
        console.log("addWOLI" + addWOLI);
        
        addWOLI.setCallback(this,function(response){
            var state= addWOLI.getState();
            console.log("state: " + state);
        });
        $A.enqueueAction(addWOLI);
	}
})