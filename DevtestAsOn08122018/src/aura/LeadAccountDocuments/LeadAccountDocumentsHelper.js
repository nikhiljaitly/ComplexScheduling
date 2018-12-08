({
	createObjectData: function(component, event) {
        // get the contactList from component and add(push) New Object to List
        console.log('Entered Helper');  
        var tradeTypeRow = {};
        tradeTypeRow.index = '';
        tradeTypeRow.licenceType = '';
        tradeTypeRow.licenceNo = '';
        //tradeTypeRow.licenceExpiry = '';
        tradeTypeRow.licenceExpiry = '';
        tradeTypeRow.tradeTypeVal = '';
        //Sevice Areas
        //tradeTypeRow.areaValue = '';
        tradeTypeRow.qldAreaValue = '';
        tradeTypeRow.nswAreaValue = '';
        tradeTypeRow.vicAreaValue = '';
        tradeTypeRow.otherAreaValue = '';

        //tradeTypeRow.national = '';
        //tradeTypeRow.QLD = '';
        tradeTypeRow.Brisbane = '';
        tradeTypeRow.GoldCoast = '';
        tradeTypeRow.Sunshine = '';
        //tradeTypeRow.NSW = '';
        tradeTypeRow.Central = '';
        tradeTypeRow.Newcastle = '';
        tradeTypeRow.Sydney = '';
        tradeTypeRow.Wollongong = '';
        //tradeTypeRow.VIC = '';
        tradeTypeRow.Geelong = '';
        tradeTypeRow.Melbourne = '';
        tradeTypeRow.RegionalVic = '';
        //New Areas
        tradeTypeRow.NT = '';
        tradeTypeRow.TAS = '';
        tradeTypeRow.WA = '';
        tradeTypeRow.SA = '';


        //Make Safes
        tradeTypeRow.makeSafe = '';
        tradeTypeRow.makeSafeType = '';
        tradeTypeRow.allDayRate = '';
        tradeTypeRow.businessHoursRate = '';
        tradeTypeRow.afterBusinessRate = '';
        //tradeTypeRow.licenseFile = '';

        //Rates
        tradeTypeRow.fullyQualifiedRate = 0;
        tradeTypeRow.labourerRate = 0;
        tradeTypeRow.afterHourRate = 0;
        tradeTypeRow.callOutRate = 0;
        tradeTypeRow.reportRate = 0;
        tradeTypeRow.otherRate = '';

        // set the updated list to attribute (contactList) again    
        component.set("v.tradeType", tradeTypeRow);
    },

    firstPartLeadData: function(component, event) {
        // get the contactList from component and add(push) New Object to List
        console.log('Entered Helper');  
        var firstPartLeadRow = {};
        firstPartLeadRow.FirstName = '';
        firstPartLeadRow.LastName = '';
        firstPartLeadRow.Position = '';
        firstPartLeadRow.Email = '';
        firstPartLeadRow.Phone = '';
        firstPartLeadRow.AlternatePhone = '';
        firstPartLeadRow.BusinessPhone = '';
        firstPartLeadRow.abn = '';
        firstPartLeadRow.AbnStatus = '';
        firstPartLeadRow.EntityName = '';
        firstPartLeadRow.RegisteredForGst = '';
        firstPartLeadRow.AddressPostcode = '';
        firstPartLeadRow.AddressState = '';
        firstPartLeadRow.addStreet = '';
        firstPartLeadRow.addCity = '';
        firstPartLeadRow.PrefTradeName = '';
        firstPartLeadRow.ACN = '';
        firstPartLeadRow.postalStreet = '';
        firstPartLeadRow.postalCity = '';
        firstPartLeadRow.postalZip = '';
        firstPartLeadRow.postalState = '';
        firstPartLeadRow.AddComments = '';
        //firstPartLeadRow.businessEmail = '';
        //firstPartLeadRow.accountsEmail = '';
        firstPartLeadRow.businessStructure = '';
        firstPartLeadRow.commenceDate = '';
        //firstPartLeadRow.CopyAddress = false;
        component.set("v.firstPartLead", firstPartLeadRow);
    },
	fetchPickListVal: function(component, fieldName, elementId) {
        console.log('Entered fetchPickListVal');
        var action = component.get("c.getselectOptions");
        action.setParams({
            "objObject": component.get("v.objInfo"),
            "fld": fieldName
        });
        console.log(component.get("v.objInfo")+'----'+fieldName+'=='+elementId);
        var opts = [];
        action.setCallback(this, function(response) {
            if (response.getState() == "SUCCESS") {
                var allValues = response.getReturnValue();
 				console.log('allValues----'+allValues);
                if (allValues != undefined && allValues.length > 0) {
                    opts.push({
                        class: "optionClass",
                        label: "--- None ---",
                        value: ""
                    });
                }
                for (var i = 0; i < allValues.length; i++) { 
                    opts.push({
                        class: "optionClass",
                        label: allValues[i],
                        value: allValues[i]
                    });
                }
                console.log('OPTS'+opts);
                console.log('OPTS'+opts[0]);
                var detailComp = component.find(elementId);
                detailComp.set("v.options", opts);
            }
        });
        $A.enqueueAction(action);
        console.log('Exit fetchPickListVal');
    },

    fetchBusinessStructureVal: function(component, fieldName, elementId) {
        console.log('Entered fetchPickListVal2');
        var action = component.get("c.getselectOptions");
        action.setParams({
            "objObject": component.get("v.objInfo1"),
            "fld": fieldName
        });
        var opts = [];
        action.setCallback(this, function(response) {
            if (response.getState() == "SUCCESS") {
                console.log('Bus Structure'+response.getReturnValue());
                var allValues = response.getReturnValue();
 
                if (allValues != undefined && allValues.length > 0) {
                    opts.push({
                        class: "optionClass",
                        label: "--- None ---",
                        value: ""
                    });
                }
                for (var i = 0; i < allValues.length; i++) {
                    opts.push({
                        class: "optionClass",
                        label: allValues[i],
                        value: allValues[i]
                    });
                }
                console.log('OPTS2'+opts);
                console.log('OPTS2'+opts[0]);
                //var detailComp = component.find(elementId);
                component.set("v.busStructureOptions", opts);
            }
        });
        $A.enqueueAction(action);
        console.log('Exit fetchPickListVal');
    }
})