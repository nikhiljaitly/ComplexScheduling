({
	init : function(component, event, helper) {
		console.log("***Initialising homeRepRepairItemSelection");

		// hardcoded pricebook id is VERY bad and should be moved to custom
		// setting in a production build
		component.set("v._pricebookId", "01s7F000007pJLA");

	},
	//Get the Product Candidates from the search
	getProductCandidates : function(component, event, helper) {
			console.log("[getProductCandidates] Retrieving Products...");
            helper.retrieveProductCandidates(component);
	},
	toggleFilterBar : function(component, event, helper){
        var showFilterBar = component.get("v.showFilterBar");
        if(showFilterBar){
	        $A.util.removeClass(component.find("productFilterBar"),"slds-hide")
        }else{
            $A.util.addClass(component.find("productFilterBar"),"slds-hide")
        }
    },
    applyFilter : function(component, event, helper){
        helper.search(component);
    }
})