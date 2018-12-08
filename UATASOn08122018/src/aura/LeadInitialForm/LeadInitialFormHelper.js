({
    execute : function(action) {
        return new Promise(function(resolve, reject) {
            action.setCallback(this, function(response) {
                var state = response.getState();
                if (state === "SUCCESS") {
                    console.log('getdata: '+response.getReturnValue());
                    resolve(response);
                }else if (state === "ERROR") {
                    reject(response);
                }
            });
            $A.enqueueAction(action);
        });
    },
    abnAutoUpdate: function(component, event){        
        console.log(JSON.stringify(event.getParams().payload));
        var abnObj = JSON.parse(event.getParams().payload);
        console.log("abnObj", JSON.stringify(abnObj));
        var card = component.find("card");
        var valueMap =card.get("v.valueMap");
        valueMap["Lead.ABN__c"] = abnObj.Abn;
        valueMap["Lead.Company"] = abnObj.EntityName;
        valueMap["Lead.State"] = abnObj.AddressState;
        valueMap["Lead.PostalCode"] = abnObj.AddressPostcode;
        valueMap["Lead.ABN_Status__c"] = abnObj.AbnStatus;
        if(abnObj.Gst) {
            valueMap["Lead.Registered_for_GST__c"] = "Yes";
        } else {
            valueMap["Lead.Registered_for_GST__c"] = "No";
        }
        card.set("v.valueMap", valueMap);
        card.refresh(); 
    },
    copyAddress: function(component, event) {
        var fieldComp = event.getParams().payload;
        var apiName = fieldComp.apiName;
        var value = fieldComp.value;
        if(apiName === "Lead.Copy_address_from_business__c") {
            // Lock Postal address
            console.log("go");
            component.find("card").find(
                "sections").find(
                "fieldInput").forEach(function(field) {
                var apiName = field.get("v.apiName");
                if(apiName === "Lead.Postal_Street__c" || apiName === "Lead.Postal_Suburb__c" 
                   || apiName === "Lead.Postal_Postcode__c" || apiName === "Lead.Postal_State__c") {
                    field.set("v.readOnly", value);
                    field.set("v.errors", null);
                    field.set("v.value", "");
                }
                console.log(field.get("v.apiName"));
            });
        } 
    },
    updateComplianceWorkType : function(component, event) {
        var fieldComp = event.getParams().payload;
        var apiName = fieldComp.apiName;
        var value = fieldComp.value;
        if(apiName === "Lead.Work_Type__c") {
            var compliance = component.find("compliance");
            compliance.find("compliance").updateOptions(value);
        }
    },
    customActionsAfterDataChanged: function(component, event) {
        var type = event.getParams().type;        
        if(type === "ABN") {
            this.abnAutoUpdate(component, event);
        }
        if(type === "dataChanged" ) {
            this.copyAddress(component, event);
            this.updateComplianceWorkType(component, event);                           
        }  
    },
    getLeadCacheTable : function(component) {
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
    handleFormResults : function(component, leadFormRes) {
        var _self = this;
        console.log("leadFormRes", leadFormRes); 
        var wizardSetting =JSON.parse(leadFormRes.getReturnValue()); 
        _self.updateWizardSetting(component, wizardSetting); 
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
    getLeadInitForm : function(component) {
        var _self = this;
        var action = component.get("c.getLeadInitialForm");
        return this.execute(action);
    },

    refreshCard : function(component){
        var card = component.find("card");
        var sections = card.find("sections");
        card.refresh();
        
    },
    getAbnDetails : function(cmp,action) {
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                // Alert the user with the value returned 
                // from the server
                //alert("From server: " + response.getReturnValue());
                
                var firstpart = cmp.get("v.firstPartLead");
                var abnDataFields = response.getReturnValue(); 
                console.log("From server: " , abnDataFields);
                abnDataFields = JSON.parse(abnDataFields);
                //cmp.set("v.abnData",abnDataFields);
                
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
        //tradeTypeRow.licenceExpiry = '';
        tradeTypeRow.licenceExpiry = '';
        tradeTypeRow.tradeTypeVal = '';
        //Sevice Areas
        //tradeTypeRow.areaValue = '';
        tradeTypeRow.qldAreaValue = '';
        tradeTypeRow.nswAreaValue = '';
        tradeTypeRow.vicAreaValue = ''; 
        tradeTypeRow.otherAreaValue = '';
        
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
        console.log('here createSFRecords');
        return new Promise(function(resolve, reject){
            var attachList = cmp.get("v.licenseAttachments");
            console.log('Attachments Length'+attachList.length);
            //console.log('Attachments'+attachList[0].Description);
            var self = this;
            action.setCallback(this, function(response) {
                var state = response.getState();
                if (state === "SUCCESS") {
                    // Alert the user with the value returned 
                    // from the server
                    //alert("From server: " + response.getReturnValue());
                    var responseValue = response.getReturnValue(); 
                    console.log(responseValue);
                    responseValue = JSON.parse(responseValue);
                    //responseValue = JSON.parse(responseValue);
                    console.log('responseValue Status'+responseValue.status);
                    console.log('responseValue Lead Id'+responseValue.LeadId);
                    /* Amendment to add file upload for licenses*/
                    if(responseValue.status == 'isExist'){
                        var showToast = $A.get("e.force:showToast"); 
                        showToast.setParams({ 
                            'type' : 'error',
                            'title' : 'Error', 
                            'message' : 'You are already registered. Please contact HomeRepair customer suppoer team.' 
                        }); 
                        showToast.fire(); 
                    }
                    if(responseValue.status == 'Success' && responseValue.LeadId){
                        //get the lead record Id and attach the trade type license attachments.
                        console.log('Entered Attachments');
                        if(attachList.length > 0){
                            //get those attachments
                            alert('Attachment detected')
                            var parentRecId = responseValue.LeadId;
                            for (var i = 0; i < attachList.length; i++) {
                                // create a FileReader object
                                console.log('Attachment loop var '+i)
                                var file = attachList[i].fileDetail;
                                console.log('file'+file);
                                var fileDesc =  attachList[i].Description;
                                console.log('file description inside loop'+fileDesc);
                                
                                var objFileReader = new FileReader();
                                // set onload function of FileReader object   
                                objFileReader.onload = $A.getCallback(function() {
                                    alert('Entered objFileReader onload');
                                    resolve;
                                    var fileContents = objFileReader.result;
                                    var base64 = 'base64,';
                                    var dataStart = fileContents.indexOf(base64) + base64.length;
                                    fileContents = fileContents.substring(dataStart);
                                    alert('Entered farther into objFileReader');
                                    var uploadPromise = this.uploadProcess(component, file, fileContents, fileDesc, parentRecId);                                     alert('Entered File Reader getCallBack')
                                    
                                    /*uploadPromise.then(
                                        $A.getCallback(function(res){
                                            if(res.status != 'Success'){
                                                console.log('Unsuccessfull')
                                                alert('Not Success');
                                            }
                                            else{
                                                window.location.href = '/trade/s/thankyou?FormName=initial' ;
                                            }
                                        }),
                                        $A.getCallback(function(error){
                                            // Something went wrong
                                                console.log('Error')
                                                alert('Error '+error.message);

                                        })

                                    ); */
                                    // call the uploadProcess method
                                    //self.uploadProcess(component, file, fileContents, fileDesc, parentRecId);
                                });
                                
                                objFileReader.readAsDataURL(file);
                            } 
                            
                        }
                        //alert('exited the attachment loop');
                        resolve(responseValue);
                        
                        
                        //window.location.href = '/trade/s/thankyou?FormName=initial' ;
                    }
                    
                    /* Amendment to add file upload for licenses*/
                    else if(responseValue == 'FAILED'){
                        console.log('Operation Failed');
                        reject(Error("Error message: " + 'Operation Failed'));
                    }
                    //console.log("From server: " + response.get('EntityName'));
                    
                    // You would typically fire a event here to trigger 
                    // client-side notification that the server-side 
                    // action is complete
                    
                }
                else if (state === "INCOMPLETE") {
                    // do something
                    reject(Error("Unknown error"));
                }
                    else if (state === "ERROR") {
                        var errors = response.getError();
                        if (errors) {
                            if (errors[0] && errors[0].message) {
                                console.log("Error message: " + 
                                            errors[0].message);
                                reject(Error("Error message: " + errors[0].message));
                            }
                        } else {
                            console.log("Unknown error");
                            reject(Error("Unknown error"));
                        }
                    }
                
            });
            $A.enqueueAction(action);
        })
    },
    
    uploadProcess: function(component, file, fileContents, fileDesc, parentId) {
        return new Promise(function(resolve, reject){
            alert('Entered uploadProcess 2');
            // set a default size or startpostiton as 0 
            var startPosition = 0;
            // calculate the end size or endPostion using Math.min() function which is return the min. value   
            var endPosition = Math.min(fileContents.length, startPosition + this.CHUNK_SIZE);
            
            // start with the initial chunk, and set the attachId(last parameter)is null in begin
            this.uploadInChunk(component, file, fileContents, startPosition, endPosition, '', fileDesc);
        });
    },
    
    uploadInChunk: function(component, file, fileContents, startPosition, endPosition, attachId, fileDesc, parentLeadId) {
        // call the apex method 'saveChunk'
        var attachList = component.get("v.licenseAttachments");
        var getchunk = fileContents.substring(startPosition, endPosition);
        var action = component.get("c.saveChunk");
        action.setParams({
            parentId: parentLeadId,
            fileName: file.name,
            base64Data: encodeURIComponent(getchunk),
            contentType: file.type,
            fileId: attachId,
            fileDescription: fileDesc
            
        });
        
        // set call back 
        action.setCallback(this, function(response) {
            
            attachId = response.getReturnValue();
            var state = response.getState();
            if (state === "SUCCESS") {
                // update the start position with end postion
                startPosition = endPosition;
                endPosition = Math.min(fileContents.length, startPosition + this.CHUNK_SIZE);
                // check if the start postion is still less then end postion 
                // then call again 'uploadInChunk' method , 
                // else, diaply alert msg and hide the loading spinner
                if (startPosition < endPosition) {
                    this.uploadInChunk(component, file, fileContents, startPosition, endPosition, attachId, fileDesc, parentLeadId);
                } else {
                    //alert('your File is uploaded successfully');
                    console.log('your File is uploaded successfully');
                    component.set("v.showLoadingSpinner", false);
                }
                // handel the response errors        
            } else if (state === "INCOMPLETE") {
                alert("From server: " + response.getReturnValue());
            } else if (state === "ERROR") {
                var errors = response.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        console.log("Error message: " + errors[0].message);
                    }
                } else {
                    console.log("Unknown error");
                }
            }
        });
        // enqueue the action
        $A.enqueueAction(action);
    }        
    
})