({
	getAbnDetails : function(cmp,action) {

        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                // Alert the user with the value returned 
                // from the server
                //alert("From server: " + response.getReturnValue());

                var firstpart = cmp.get("v.firstPartLead");
                var abnDataFields = response.getReturnValue(); 
                abnDataFields = JSON.parse(abnDataFields);
                //cmp.set("v.abnData",abnDataFields);
                //console.log("From server: " + response.get("EntityName");
                console.log("Gst: " + abnDataFields.Gst);
                console.log("Name: " + abnDataFields.EntityName);
                console.log("AbnStatus: " + abnDataFields.AbnStatus);
                console.log("AddressDate: " + abnDataFields.AddressDate);
                console.log("AddressPostcode: " + abnDataFields.AddressPostcode);
                console.log("AddressState: " + abnDataFields.AddressState);
                console.log("BusinessName: " + abnDataFields.BusinessName);
                console.log("EntityTypeCode: " + abnDataFields.EntityTypeCode);
                console.log("EntityTypeName: " + abnDataFields.EntityTypeName);
                console.log("Abn: " + abnDataFields.Abn);
				console.log("Message: " + abnDataFields.Message);
				//Update the response
				if(abnDataFields.Message){
                	//alert("From server: " + abnData.Message);
                	console.log('Entereed Message');
                	cmp.set("v.valError",true);
                    var abnFormTarget = cmp.find('abnForm');
                    $A.util.addClass(abnFormTarget, 'slds-has-error');                        
 					var abnErrTarget = cmp.find('abnError');
					$A.util.removeClass(abnErrTarget, 'slds-hide');
					//Have to make the fields null here.
					abnDataFields.AbnStatus = '';
					abnDataFields.EntityName = ''; 
					abnDataFields.RegisteredForGst = '';  
					abnDataFields.AddressPostCode = '';
					abnDataFields.AddressState = '';   
                }
                else{
                	if(abnDataFields.AbnStatus != 'Active'){
                		console.log('Not Active');
                        cmp.set("v.valError",true);
                        var abnFormTarget = cmp.find('abnForm');
                        $A.util.addClass(abnFormTarget, 'slds-has-error');                       
                        var abnInactiveErrTarget = cmp.find('abnInactiveError');
                        $A.util.removeClass(abnInactiveErrTarget, 'slds-hide'); 
                        //Update the JS Object
						//Need to check the one below 
						abnDataFields.RegisteredForGst = 'Yes';  
                        
                    }
                	if(abnDataFields.AbnStatus == 'Active'){
                		console.log('Active');
						//Need to check the one below 
						abnDataFields.RegisteredForGst = 'Yes';             		

                	}
            	}
                console.log("AddressPostcode: " + abnDataFields.AddressPostcode);
                firstpart.AbnStatus = abnDataFields.AbnStatus;
                firstpart.EntityName = abnDataFields.EntityName; 
                firstpart.RegisteredForGst = abnDataFields.RegisteredForGst;  
                firstpart.AddressPostcode = abnDataFields.AddressPostcode;
                firstpart.AddressState = abnDataFields.AddressState;
                firstpart.abn = abnDataFields.Abn;                 
            	cmp.set("v.firstPartLead",firstpart);
                //cmp.set("v.abnData",abnDataFields);
            	
            	

                //console.log("From server: " + response.get('EntityName'));

                // You would typically fire a event here to trigger 
                // client-side notification that the server-side 
                // action is complete
            }
            else if (state === "INCOMPLETE") {
                // do something
            }
            else if (state === "ERROR") {
                var errors = response.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        console.log("Error message: " + 
                                 errors[0].message);
                    }
                } else {
                    console.log("Unknown error");
                }
            }
        });
        $A.enqueueAction(action);
	},

    createObjectData: function(component, event) {
        // get the contactList from component and add(push) New Object to List
        console.log('Entered Helper');  
        var tradeTypeRow = {};
        tradeTypeRow.index = '';
        tradeTypeRow.licenceType = '';
        tradeTypeRow.licenceNo = '';
        tradeTypeRow.licenceExpiry = '';
        tradeTypeRow.tradeTypeVal = '';
        //Sevice Areas
        tradeTypeRow.areaValue = '';
        tradeTypeRow.national = '';
        tradeTypeRow.QLD = '';
        tradeTypeRow.Brisbane = '';
        tradeTypeRow.GoldCoast = '';
        tradeTypeRow.Sunshine = '';
        tradeTypeRow.NSW = '';
        tradeTypeRow.Central = '';
        tradeTypeRow.Newcastle = '';
        tradeTypeRow.Sydney = '';
        tradeTypeRow.Wollongong = '';
        tradeTypeRow.VIC = '';
        tradeTypeRow.Geelong = '';
        tradeTypeRow.Melbourne = '';
        tradeTypeRow.RegionalVic = '';
        //Make Safes
        tradeTypeRow.makeSafe = '';
        tradeTypeRow.makeSafeType = '';
        tradeTypeRow.allDayRate = '';
        tradeTypeRow.businessHoursRate = '';
        tradeTypeRow.afterBusinessRate = '';

        //Rates
        tradeTypeRow.fullyQualifiedRate = new Number();
        tradeTypeRow.labourerRate = new Number();
        tradeTypeRow.afterHourRate = new Number();
        tradeTypeRow.callOutRate = new Number();
        tradeTypeRow.reportRate = new Number();
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
        firstPartLeadRow.businessEmail = '';
        firstPartLeadRow.accountsEmail = '';
        firstPartLeadRow.commenceDate = '';
        component.set("v.firstPartLead", firstPartLeadRow);
    },


    fetchPickListVal: function(component, fieldName, elementId) {
        console.log('Entered fetchPickListVal');
        var action = component.get("c.getselectOptions");
        action.setParams({
            "objObject": component.get("v.objInfo"),
            "fld": fieldName
        });
        var opts = [];
        action.setCallback(this, function(response) {
            if (response.getState() == "SUCCESS") {
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
    },   

    createSFRecords : function(cmp,action) {

        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                // Alert the user with the value returned 
                // from the server
                //alert("From server: " + response.getReturnValue());
                var responseValue = response.getReturnValue(); 
                //responseValue = JSON.parse(responseValue);
                console.log('responseValue'+responseValue);
                if(responseValue == 'Success'){
                    window.location.href = '/trade/s/thankyou' ;
                }
                else if(responseValue == 'FAILED'){
                    console.log('Operation Failed');
                }
                //console.log("From server: " + response.get('EntityName'));

                // You would typically fire a event here to trigger 
                // client-side notification that the server-side 
                // action is complete
            }
            else if (state === "INCOMPLETE") {
                // do something
            }
            else if (state === "ERROR") {
                var errors = response.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        console.log("Error message: " + 
                                 errors[0].message);
                    }
                } else {
                    console.log("Unknown error");
                }
            }
        });
        $A.enqueueAction(action);
    },

})