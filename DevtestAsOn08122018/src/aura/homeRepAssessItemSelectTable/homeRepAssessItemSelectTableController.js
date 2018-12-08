({
	init : function(component, event, helper) {
		console.log("***Initialising homeRepAssessmentItemSelectTable...");
	},
	createAssessmentItems : function(component, event, helper){
        var selectedItemNum = component.get("v.selectedItemNum");
        console.log("[createAssessmentItems] " + selectedItemNum + " Products Selected...");
        console.log("[createAssessmentItems] Creating Assessment Items...");
        if(selectedItemNum > 0){
            helper.fireCreateAssessmentItemsEvent(component);
        }
    },
    checkAllCheckBoxes : function(component, event, helper){        
        var selectedProductMap = component.get("v.selectedProductMap");
        if(!selectedProductMap){
            selectedProductMap = {};
        }

		var currentRecords = component.get("v.productCandidatesInCurrentPage");
        var target = event.getSource();
        var checked = target.get("v.value");
        
        if(target.get("v.name") === "selectAll"){
            helper.checkAllCheckBoxes(selectedProductMap, currentRecords, checked);
            component.set("v.productCandidatesInCurrentPage", currentRecords);
        }else{
	        var recordId = target.get("v.name");	            
            helper.checkOneUnit(selectedProductMap, recordId, checked);
            component.set("v.checkedAll", 
                         helper.checkIfNeedToCheckAllCheckBoxes(selectedProductMap,currentRecords));
        }
        component.set("v.selectedProductMap", selectedProductMap);
    },
    autoUpdateCheckBox : function(component, event, helper){
        var selectedProductMap = component.get("v.selectedProductMap");
        if(!selectedProductMap){
            selectedProductMap = {};
        }
		var currentRecords = component.get("v.productCandidatesInCurrentPage");
        component.set("v.checkedAll", 
                      helper.checkIfNeedToCheckAllCheckBoxes(selectedProductMap,currentRecords));
    },
    updateSelectedItems : function(component, event, helper){
        var selectedProductMap = component.get("v.selectedProductMap");
        var index = 0;
        for(var key in selectedProductMap){
            if(selectedProductMap[key]){
                index ++;
            }
        }
        component.set("v.selectedItemNum", index);
       
    },
    clearSelectedItems : function(component, event, helper){	
        component.set("v.selectedProductMap", {});
        component.set("v.checkedAll",false);
        
    },
    toggleFilterBar : function(component, event, helper){
        console.log("***Toggling Filter Bar...");
        var showFilter = component.get("v.showFilterBar");
        showFilter = !showFilter;
        component.set("v.showFilterBar", showFilter);
    },
    updateFilterListStyle : function(component){
        console.log("***Updating Filter List Style...");
        var showFilter = component.get("v.showFilterBar");
        if(showFilter){
            $A.util.addClass(component.find("filterList"),"slds-is-selected");
        }else{
            $A.util.removeClass(component.find("filterList"),"slds-is-selected");            
        }
    }
})