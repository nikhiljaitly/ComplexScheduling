({
    createObjectData: function(component, event) {
        // get the tradetypeList from component and add(push) New Object to List  
        var RowItemList = component.get("v.tradetypeList");
        RowItemList.push({
            'sobjectType': 'Trade_Type__c',
            'Work_Type__c': '',
            'License_Number__c': '',
            'License_Type__c': '',
            'License_Expiry__c': ''
        });
        // set the updated list to attribute (tradetypeList) again    
        component.set("v.tradetypeList", RowItemList);
    },
    // helper function for check if WorkType Name is not null/blank on save  
    validateRequired: function(component, event) {
        var isValid = true;
        var allTradeTypeRows = component.get("v.tradetypeList");
        console.log('allTradeTypeRows ' + JSON.stringify(allTradeTypeRows));
        for (var indexVar = 0; indexVar < allTradeTypeRows.length; indexVar++) {
            if (allTradeTypeRows[indexVar].Work_Type__c == '') {
                isValid = false;
                alert('WorkType Name Can\'t be Blank on Row Number ' + (indexVar + 1));
            }
        }
        return isValid;
    },
})