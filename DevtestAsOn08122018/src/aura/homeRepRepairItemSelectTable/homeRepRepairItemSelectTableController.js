({
	init : function(component, event, helper) {
        console.log("***Initialising homeRepRepairItemSelectTable...");
	},
	createRepairItems : function(component, event, helper){
        var selectedItemNum = component.get("v.selectedItemNum");
        console.log("[createRepairItems] " + selectedItemNum + " Products Selected...");
        console.log("[createRepairItems] Creating Repair Items...");
        if(selectedItemNum > 0){
            helper.fireCreateRepairItemsEvent(component);
        }
    },
    checkAllCheckBoxes : function(component, event, helper){
        var selectedProductMap = component.get("v.selectedProductMap");
        var selectedProductRoomMap = component.get("v.selectedProductRoomMap");
        var selectedProductList = component.get("v.selectedProductList");
        var claim = component.get("v._case");

        console.log("[checkAllBoxes] Initial Values:");
        console.log(selectedProductMap);


        if(!selectedProductMap){
            selectedProductMap = {};
            selectedProductRoomMap = {};
            selectedProductList = [];
        }

        var currentRecords = component.get("v.productCandidatesInCurrentPage");
        var currentRoom = component.get("v.selectedRoom");
        var target = event.getSource();
        var checked = target.get("v.value");
        
        if(target.get("v.name") === "selectAll"){
            console.log("[checkAllBoxes] Select All Invoked...");
            helper.checkAllCheckBoxes(selectedProductMap, currentRecords, checked, selectedProductRoomMap,currentRoom, claim);
            component.set("v.productCandidatesInCurrentPage", currentRecords);
        }else{
            console.log("[checkAllBoxes] Single Selection Invoked...");
	        var recordId = target.get("v.name");	            
            helper.checkOneUnit(selectedProductMap, recordId, checked, selectedProductRoomMap,currentRoom, selectedProductList,currentRecords, claim);
            component.set("v.checkedAll", 
                         helper.checkIfNeedToCheckAllCheckBoxes(selectedProductMap,currentRecords));
        }
        component.set("v.selectedProductMap", selectedProductMap);
        console.log("[checkAllBoxes] Selected Product Map:");
        console.log(selectedProductMap);
        component.set("v.selectedProductRoomMap", selectedProductRoomMap);
        console.log("[checkAllBoxes] Selected Product Room Map:");
        console.log(selectedProductRoomMap);
        component.set("v.selectedProductList", selectedProductList);
        console.log("[checkAllBoxes] Selected Product List:");
        console.log(selectedProductList);
    },
    autoUpdateCheckBox : function(component, event, helper){
        var selectedProductMap = component.get("v.selectedProductMap");
        var selectedProductRoomMap = component.get("v.selectedProductRoomMap");
        var selectedProductList = component.get("v.selectedProductList");
        if(!selectedProductMap){
            selectedProductMap = {};
            selectedProductRoomMap = {};
            selectedProductList = [];
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
        //component.set("v.selectedProductMap", {});
        //component.set("v.selectedProductRoomMap", {});
        console.log("***Clearing Selected Items...");
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
    },
    handleSelectedRoomChange : function(component, event, helper) {
        console.log("[homeRepRepairItemSelectTableController] - Handling Selected Room Changed Event...");
        var selectedRoom = event.getParam("_selected_room");
		component.set("v.selectedRoom", selectedRoom);
    }
})