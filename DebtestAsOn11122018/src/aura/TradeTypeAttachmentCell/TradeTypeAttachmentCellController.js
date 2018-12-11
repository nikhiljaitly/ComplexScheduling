({
    attachmentsChange : function (component, event, helper) {
        // handle value change
        console.log("old value: " + event.getParam("oldValue"));
        console.log("current value: " + event.getParam("value"));
        var trade = component.get("v.tradeTypeRec");
        var ttDescription = trade.Trade_Type__c;
        console.log('trade description ='+ttDescription);
        var AllRowsList = component.get("v.attachments"); 
        
        for (var i = 0; i < AllRowsList.length; i++) {

            if(AllRowsList[i].Description == ttDescription){
                console.log('Matched for '+ttDescription);
                component.set("v.DocAdded",true);

            }

        } 

    },

    // function for delete the row 
    removeDeletedRow: function(component, event, helper) {

    	console.log('Entered Trade Type Attachment Cell')
    	component.set("v.DocAdded",false);

    }

})