({
	retrieveProductCandidates: function(component){
		
        var sfCase = component.get("v._case");
        
		var getProductCandidate = component.get("c.getProductCandidate");
		var pricebookId = component.get("v._pricebookId");
		console.log("***Retrieving Product Candidates from Pricebook "+ pricebookId);
		getProductCandidate.setParams({
            "pricebook2Id": pricebookId
        });
        
        getProductCandidate.setCallback(this, function(response){
            var state = response.getState();
            if(component.isValid() && state === "SUCCESS"){
				console.log("Successfully Retrieved Product Candidates:");
				console.log(response.getReturnValue());
                component.set("v.productCandidates", response.getReturnValue());   
            }else{
                console.log("Failed with state: "+ state);
            }
        });
        
        $A.enqueueAction(getProductCandidate);
    },
    
    search: function(component){
        var sfcase = component.get("v._case");
        var pricebookId = component.get("v._pricebookId");
		var filterInfo = component.get("v._filter");
        var orderBy = component.get("v.orderBy");
        filterInfo = filterInfo ? filterInfo : {};
        filterInfo.orderBy = orderBy;
        var applyFilter = component.get("c.applyFilterSearch");
        console.log("***Using Filter String = " + JSON.stringify(filterInfo));
        applyFilter.setParams({
            "pricebook2Id": pricebookId,
            "filterInfoStr": JSON.stringify (filterInfo)
        });
        
        applyFilter.setCallback(this, function(response){
            var state = response.getState();
            if(component.isValid() && state === "SUCCESS"){
                component.set("v.productCandidates",response.getReturnValue());
                console.log(response.getReturnValue());   
            }else{
                console.log("Failed with state: "+ state);
            }
        });
        
        $A.enqueueAction(applyFilter);
	},
})