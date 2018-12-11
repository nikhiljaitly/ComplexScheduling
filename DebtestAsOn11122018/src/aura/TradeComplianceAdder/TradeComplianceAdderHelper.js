({
    execute : function(action) {
        return new Promise(function(resolve, reject) {
            action.setCallback(this, function(response) {
                var state = response.getState();
                if (state === "SUCCESS") {
                    resolve(response);
                }else if (state === "ERROR") {
                    reject(response);
                }
            });
            $A.enqueueAction(action);
        });
    },
    updateDataRows: function(component, row) {
        var compliance = component.find("compliance");
        var index = compliance.get("v.rowIndex");
        var data = component.get("v.data");
        if(index || index === 0) {
            data[index] = row;
            compliance.set("v.rowIndex", null);
        } else {
            data.push(row);
        }
        component.set("v.data", data);  
    },
    validate: function(compliance) {
        var card = compliance.find("card");
        var isValid = card.validateFields();
        console.log("isValid", isValid);
        return isValid;
    },
    showModal : function(component, modalName) {
		var modal = component.find(modalName);
        $A.util.removeClass(modal, "slds-hide");        
    },
    hideModal : function(component, modalName) {
        var modal = component.find(modalName);
        $A.util.addClass(modal, "slds-hide");
    },
    convertToValueMap : function(formFeed) {
        var valueMap ={};
        for(var fieldName in formFeed) {
        	var value = formFeed[fieldName];
            var objName = "Trade_Type__c";
            valueMap[objName + "." + fieldName] = value;
        }
        return valueMap;
    },
    getDocuments: function(component) {
        var action = component.get("c.getDocuments") ;
        var rows = component.get("v.data");
        action.setParams({"tradeComplianceStr": JSON.stringify(rows)});
        this.execute(action).then(function(response) {
            var docStr = response.getReturnValue();
            var documents = JSON.parse(docStr);
            var attachments = []
            documents.forEach(function(doc) {
                attachments.push(doc);
            });
            component.set("v.attachments", attachments);
            // Initiate the subdocuments
            var tradeTypeTable = component.find("tradeTypeTable");
            tradeTypeTable.initiate();
        });
    },
    saveData : function(component, row) {
        var parentField = component.get("v.parentField");
        var parentId = component.get("v.parentId");
        row[parentField] = parentId;
        console.log('row'+[row]);
        var action = component.get("c.upsertTradeCompliance");
        action.setParams({"tradeComplianceStr": JSON.stringify([row])});
        return this.execute(action);
    },
    saveAll : function(component) {
        var parentField = component.get("v.parentField");
        var parentId = component.get("v.parentId");
        var action = component.get("c.upsertTradeCompliance");
        var rows = component.get('v.data');
        rows.forEach(function(row) {
            row[parentField] = parentId;
        });
        action.setParams({"tradeComplianceStr": JSON.stringify(rows)});
        this.execute(action).then(function(response) {
            var valueRes = response.getReturnValue();
            var rows = JSON.parse(valueRes);
            component.set("v.data", rows);
        });
    }
})