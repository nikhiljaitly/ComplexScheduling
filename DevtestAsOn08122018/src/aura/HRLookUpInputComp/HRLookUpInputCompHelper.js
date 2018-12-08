({
	searchHelper : function(component, event, helper) {
        var prodId = component.get("v.selectedRecordId");
        var woID = component.get("v.woRecordID");
        //why is v.selectedRecordId an array?
        //console.log("prodID" + JSON.stringify(prodId));
        //console.log("woID" + woID);
        
        
		var action = component.get("c.productPricesByState");
        action.setParams({"ProductId":prodId[0] , "workOrderId":woID});
        
        //console.log("***action: " + action);
        //console.log("***prodId: " + action.getParam('ProductId'));
        //console.log("***woId: " + action.getParam('workOrderId'));
        
            action.setCallback(this,function(response){
            var state = action.getState();
                console.log('***State: ' + state);
                
                if(state === "SUCCESS"){
                    var productDetails = response.getReturnValue();
                    console.log("productDetails: " + JSON.stringify(productDetails));
                    
                    
                    var compLabCost = (productDetails[0].Labour_Price__c);
                    var compMatCost = (productDetails[0].Material_Price__c);
                    var compProductId = (productDetails[0].Product2Id);
                    
                    console.log("***labour cost: " + compLabCost);
                    console.log("***Material Cost: " + compMatCost);
                    console.log('*** ID: ' + compProductId);
                    //send values via event
                    if(compLabCost > 0.00 || compMatCost > 0.00){
                        // call the event   
        				var compEvent = component.getEvent("moveCosts");
                        
        				// set the woRecordID to the event attribute.  
        				compEvent.setParams({"oLabCost" : compLabCost , 
                                             "oMatCost" : compMatCost ,
                                             "Product2Id" : compProductId});
                        
                        //console.log("***Event: " + JSON.stringify(compEvent));
        				// fire the event  
        				compEvent.fire(); 
                    }
                    /*component.set("v.sLabCost" , compLabCost);
                    component.set("v.sMatCost" , compMatCost);*/
                }
                else{
                    console.log("***apex error");
                }
            });
        	$A.enqueueAction(action);
       
    }
})