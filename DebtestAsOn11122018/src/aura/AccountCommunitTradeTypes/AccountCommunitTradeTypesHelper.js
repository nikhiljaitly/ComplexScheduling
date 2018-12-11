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
    updateComplianceWorkType : function(component, event) {
        var fieldComp = event.getParams().payload;
        var apiName = fieldComp.apiName;
        var value = fieldComp.value;
        if(apiName === "Account.Work_Type__c") {
            var compliance = component.find("compliance");
            compliance.find("compliance").updateOptions(value);
        }
    },
    customActionsAfterDataChanged: function(component, event) {
        var type = event.getParams().type;        
        if(type === "dataChanged" ) {
            this.updateComplianceWorkType(component, event);                           
        }  
    },
    getInitForm : function(component) {
        var _self = this;
        var action = component.get("c.getAccountForm");
        return this.execute(action);
    },
    refreshCard : function(component){
        var card = component.find("card");
        var sections = card.find("sections");
        card.refresh();
        var value = component.get("v.valueMap")["Account.Work_Type__c"];
        var compliance = component.find("compliance");
        compliance.find("compliance").updateOptions(value);
    },
    
    updateWizardSetting: function(component, wizardSetting) {
        var _self = this;
        var card = component.find("card");
        card.getPicklistOptions(wizardSetting).then(function(updatedSetting) {
            component.set("v.wizardSetting", updatedSetting);
            component.set("v.sections", updatedSetting.setting.sections);
            _self.refreshCard(component);
        });
    },
    handleFormResults : function(component, formRes) {
        var _self = this;
        
        var wizardSetting =JSON.parse(formRes.getReturnValue()); 
        _self.updateWizardSetting(component, wizardSetting); 
    },
    getCacheTable : function(component) {
      var action = component.get("c.getCacheTable");
      return this.execute(action).then(function(response) {
          var fieldEntries = JSON.parse(response.getReturnValue());
          var cacheData = {};
          fieldEntries.forEach(function(fieldEntry) {
              cacheData[fieldEntry.apiName] = fieldEntry.options;
          });
          component.set("v.cacheData", cacheData);
		  return cacheData;
      });
    },
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
    fetchPickListVal: function(component, fieldName, elementId,AllTradeType) {
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
                    if((!$A.util.isUndefined(AllTradeType))){
                        var getElementIndex = AllTradeType.indexOf(allValues[i]);
                        if(getElementIndex < 0){                        
                            opts.push({
                                class: "optionClass",
                                label: allValues[i],
                                value: allValues[i]
                            });
                        }
                    }else{
                        opts.push({
                            class: "optionClass",
                            label: allValues[i],
                            value: allValues[i]
                        });
                    }
                    
                    
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