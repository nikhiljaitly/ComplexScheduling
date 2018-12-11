({
	// fire an event to indicate assessment items are being created
	fireCreateAssessmentItemsEvent : function(component){
        var createAssessmentItems = component.getEvent("createAssessmentItems"); 
        var selectedProductMap = component.get("v.selectedProductMap");
        var productCandidates = component.get("v.productCandidates");
        var selectedProducts = [];
        selectedProducts = this.convertSelectedProducts(selectedProductMap, productCandidates);
        createAssessmentItems.setParams({
            "_selected_products": selectedProducts

        });
        console.log("[homeRepAssessmentItemSelectTableHelper] Firing Create Assessment Items Event:");
        console.log(selectedProducts);
        createAssessmentItems.fire();
	},
	// convert selected products into a JSON payload
	convertSelectedProducts : function(selectedProductsMap, productCandidates){
        var assessmentItems = [];
        for(var key in productCandidates){
            var candidate = productCandidates[key];
            
            if(selectedProductsMap[candidate.pBEntry.Id]){
                var item = {
                    "quantity": 1,
                    "serviceDate": null,
                    "description": candidate.pBEntry.Product2.Work_Item_Summary__c,
                    "productName": candidate.pBEntry.Product2.Name,
                    "salesPrice": candidate.pBEntry.UnitPrice,
                    "priceBookEntryId": candidate.pBEntry.Id,
                    "productId": candidate.pBEntry.Product2.Id,
                    "longDescription": candidate.pBEntry.Product2.Work_Item_Description__c,
                    "errors":{
                        "quantity": "",
                        "salesPrice" : "",
                        "serviceDate" : "",
                        "description" : "",
                        "message" : ""
                    }
                }; 
                
                assessmentItems.push(item);
            }
        }
        return assessmentItems;
	},
	// control checkbox selection in product list
	checkAllCheckBoxes : function(selectedProductMap, currentRecords, checked){
        for(var key in currentRecords){
            currentRecords[key]["isSelected"] = checked;
            this.checkOneUnit(selectedProductMap, currentRecords[key].pBEntry.Id, checked);
        }
    },    
    checkOneUnit : function(selectedProductMap, recordId, checked){
        selectedProductMap[recordId] = checked;
    },
    checkIfNeedToCheckAllCheckBoxes : function(selectedProductMap, currentRecords){
        var checkAllBox = true;
        for(var key in currentRecords){
            if(!selectedProductMap[currentRecords[key].pBEntry.Id]){
                checkAllBox = false;
            }            
        }
        return checkAllBox;
    },
})