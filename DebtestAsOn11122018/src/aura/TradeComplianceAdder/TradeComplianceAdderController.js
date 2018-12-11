({
    hideWindow : function(component, event, helper) {
        helper.hideModal(component, "modal");
    },
    initiateDocuments: function(component, event, helper){
        helper.getDocuments(component);
    },
    clickAdd : function(component, event, helper) {
        var valueMap = {};
        component.find("compliance").set("v.valueMap",valueMap);
        component.find("compliance").find("card").refresh();
        helper.showModal(component, "modal");        
    },
    handleRowAction: function (component, event, helper) {
        var rows = component.get('v.data');
        var actionName = event.getSource().get("v.name");
        var rowIndex = event.getSource().get("v.tabindex");
        var row = rows[rowIndex];
        var compliance = component.find("compliance");

        switch (actionName) {
            case 'show_details':
                compliance.set("v.valueMap", helper.convertToValueMap(row));
                compliance.set("v.rowIndex", rowIndex);
                compliance.find("card").refresh();
                helper.showModal(component, "modal"); 
                break;
            case 'delete':
                rows.splice(rowIndex, 1);
                component.set('v.data', rows);
                break;
            case 'show_file_composer':
                
                break;
        }
    },
    
    saveData : function(component, event, helper) {
      	  helper.saveAll(component);
    },
    addCompliance: function(component, event, helper) {
        var compliance = component.find("compliance");
        var valueMap = compliance.get("v.valueMap");
        var index = compliance.get("v.rowIndex");
        if(!helper.validate(compliance)){
            return;
        }
        var parentId = component.get("v.parentId");
        var formFeed = component.find("compliance").find("card").convertToRecord(valueMap);
        var data = component.get("v.data") || [];
        console.log('3',data);
        console.log('4',formFeed.Trade_Type__c);
        var isValid=true;
        for(var i = 0; i < data.length; i++) {
            if(data[i].Trade_Type__c == formFeed.Trade_Type__c){   
                isValid=false;
                alert('This Trade Type already selected for trade compliance');
                break;
        	}
        }
        if(isValid){
            if(parentId){
                helper.saveData(component, formFeed).then(function(response) {
                    var returnValue = response.getReturnValue();
                    var row = JSON.parse(returnValue)[0];
                    helper.updateDataRows(component, row);
                });
            } else {
                helper.updateDataRows(component, formFeed);
            }
            helper.hideModal(component, "modal");
        }
        
    }
})