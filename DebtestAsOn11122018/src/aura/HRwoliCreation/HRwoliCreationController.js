({
	onChange : function(component, event, helper) {
		
	},
    handleCostChange : function(component, event, handler){
        console.log("noice gary");
        var LabCost = event.getParam("oLabCost");
        var MatCost = event.getParam("oMatCost");
        var Id = event.getParam("Product2Id");
        console.log("lab: " + LabCost);
        console.log("Mat: " + MatCost);
        console.log("**ID: " + Id);
        
        component.set("v.LabourCost" , LabCost);
        component.set("v.MaterialCost" , MatCost);
        component.set("v.ProductId" , Id);
    },
    handleRoomId : function(component, event, helper){
        var compRoomId = event.getParam("roomId");
        console.log("roomId" + compRoomId);
        
        component.set("v.Room" , compRoomId);
    },
    
    doInit : function(component, event, helper){      
        
        var woRecordID = component.get("v.recordId");
        console.log("***TESTwoRecordID " + woRecordID);
              
    }, 
    
    ClickCreate : function(component, event, helper){
        var createWOLI = component.get("v.newWOLI");
        console.log("newWOLI" + JSON.stringify(createWOLI));
        
        helper.createWOLI(component, createWOLI);
    }
    
    
})