({
	// fire an event to indicate assessment items are being created
	fireCreateRepairItemsEvent : function(component){
        var createRepairItems = component.getEvent("createRepairItems"); 
        var selectedProductMap = component.get("v.selectedProductMap");
        var selectedProductsRoomMap = component.get("v.selectedProductRoomMap");
        var productCandidates = component.get("v.productCandidates");
        var currentRoom = component.get("v.selectedRoom");
        var selectedProducts = component.get("v.selectedProductList");
        //selectedProducts = this.convertSelectedProducts(selectedProductMap, 
        //                            productCandidates, selectedProductsRoomMap);

        createRepairItems.setParams({
            "_selected_products": selectedProducts

        });
        console.log("[homeRepRepairItemSelectTableHelper] Firing Create Repair Items Event:");
        console.log(selectedProducts);
        createRepairItems.fire();
	},
	// convert selected products into a JSON payload
	convertSelectedProducts : function(selectedProductsMap, productCandidates, selectedProductsRoomMap){
        var repairItems = [];
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
                    "room": selectedProductsRoomMap[candidate.pBEntry.Id],
                    "errors":{
                        "quantity": "",
                        "salesPrice" : "",
                        "serviceDate" : "",
                        "description" : "",
                        "message" : ""
                    }
                }; 
                
                repairItems.push(item);
            }
        }
        
        console.log("[convertSelectedProducts] Converted Products:");
        console.log(repairItems);
        return repairItems;
	},
	// control checkbox selection in product list
	checkAllCheckBoxes : function(selectedProductMap, currentRecords, checked, selectedProductRoomMap,currentRoom,claim){
        for(var key in currentRecords){
            currentRecords[key]["isSelected"] = checked;
            this.checkOneUnit(selectedProductMap, currentRecords[key].pBEntry.Id, checked, selectedProductRoomMap,currentRoom);
        }
    },    
    checkOneUnit : function(selectedProductMap, recordId, checked, selectedProductRoomMap, 
        currentRoom, selectedProductList, currentRecords,claim) {
        console.log("[checkOneUnit] adding selected Product to data structures...")
        selectedProductMap[recordId] = checked;
        if (checked === true) {
            selectedProductRoomMap[recordId] = currentRoom;
            // find product and add it to selectedProductList
            var selectedProduct;
            currentRecords.forEach(function(p) {
                if (p.pBEntry.Id === recordId) {
                    // check it doesn't exist already
                    if (selectedProductList.length > 0) {
                        var exists = false;
                        selectedProductList.forEach(function(sp) {
                            if (sp.pBEntry.Id === recordId) {
                                exists = true;
                                sp.Quantity += 1.00;
                            }
                        });
                    }
                    if (!exists) {
                        selectedProduct = p;
                        selectedProduct.room = currentRoom;
                        selectedProduct.claim = claim;
                        selectedProduct.Quantity = 1.00;
                        selectedProduct.UnitPrice = p.pBEntry.UnitPrice;
                    }
                    return;
                }
            });
            selectedProductList.push(selectedProduct);
        } else {
            selectedProductRoomMap[recordId] = {};
            // remove from selectedProductList
            var index = 0;
            selectedProductList.forEach(function(p) {
                if (p.pBEntry.Id === recordId) {
                    selectedProductList.splice(index,1);
                    return;
                }
                index += 1;
            });
        }
        
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