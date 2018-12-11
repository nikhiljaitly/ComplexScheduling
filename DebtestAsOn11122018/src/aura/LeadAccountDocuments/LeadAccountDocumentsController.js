({  // This function that reads the url parameter Lead Id
    // and retrieves Lead details
	init : function(component, event, helper) {
            console.log ('entered Init');
            var getUrlParameter = function getUrlParameter(sParam) {
                var sPageURL = decodeURIComponent(window.location.search.substring(1)),
                    sURLVariables = sPageURL.split('&'),
                    sParameterName,
                    i;

                for (i = 0; i < sURLVariables.length; i++) {
                    sParameterName = sURLVariables[i].split('=');

                    if (sParameterName[0] === sParam) {
                        return sParameterName[1] === undefined ? true : sParameterName[1];
                    }
                }
            };
	
        var accId  = getUrlParameter('accId');
     	//Get Lead details for Lead id
        var action = component.get("c.getAccount");
        action.setParams({"accId": accId});

        action.setCallback(this, function(response) {
            var state = response.getState();
            if(component.isValid() && state == "SUCCESS"){
                var l = response.getReturnValue();
                console.log('Lead',l); 
                component.set("v.acc", l);   
                window.setTimeout(
                    $A.getCallback(function () {
                        component.set("v.isAvailable", true);                        
                        component.set("v.workCoverDocAdded",false);
                        component.set("v.publicLiabilityDocAdded",false);
                        component.set("v.otherInsuranceDocAdded",false);
                        component.set("v.bankDepositDocAdded",false);
						var AllContentFiles=component.get("v.acc.ContentDocumentLinks");
                        console.log('AllContentFiles :'+AllContentFiles);
                        var newlst =[];
                        if(AllContentFiles.length > 0 && AllContentFiles != undefined){
                            for (var i = 0; i < AllContentFiles.length; i++) {                                
                                var space = AllContentFiles[i];
                                var detailtemp = {};
                                detailtemp.key = AllContentFiles[i].ContentDocument.LatestPublishedVersion.Description;
                                //detailtemp.value = space;
                                detailtemp.value = true;
                                newlst.push(detailtemp);
                                
                                if((AllContentFiles[i].ContentDocument.LatestPublishedVersion.Description == 'Work Cover Insurance Policy')){
                                    component.set("v.workCoverDocAdded",true);
                                }
                                console.log('AllContentFiles :'+(AllContentFiles[i].ContentDocument.LatestPublishedVersion.Description == 'Work Cover Insurance Policy'));
                                
                                if((AllContentFiles[i].ContentDocument.LatestPublishedVersion.Description == 'Public Liability Insurance Policy')){
                                    component.set("v.publicLiabilityDocAdded",true);
                                }
                                if((AllContentFiles[i].ContentDocument.LatestPublishedVersion.Description == 'Other Insurance Policy')){
                                	component.set("v.otherInsuranceDocAdded",true);
                                }
                                if((AllContentFiles[i].ContentDocument.LatestPublishedVersion.Description == 'Bank Deposit Slip')){
									component.set("v.bankDepositDocAdded",true);
                                }                                
                            }
                            
                        }
                        console.log('Entered Init Map '+JSON.stringify(newlst));
                        component.set("v.FilesNameMap",newlst);
                        // create a Default RowItem [Contact Instance] on first time Component Load
                        // by call this helper function 
                        console.log('Entered Init');
                        helper.firstPartLeadData(component, event);
                        helper.createObjectData(component, event);
                        helper.fetchPickListVal(component, 'Trade_Type__c', 'detail');
                        helper.fetchBusinessStructureVal(component, 'Business_Structure__c', 'businessStruc');
                        
                    })
                );
            } else {
                console.log('There was a problem : '+response.getError());
            }
        });
        $A.enqueueAction(action);
    },
    // function for updateDocumentList 
    updateDocumentList : function(component, event, helper) {
        //get the selected row Index for delete, from Lightning Event Attribute 
        console.log('Entered the delete row handler') 
        var isUploaded = event.getParam("isUploaded");        
        if(isUploaded){
            var a = component.get('c.init');
        	$A.enqueueAction(a);
            //component.set("v.publicLiabilityDocAdded", true);
        }
    },
    editRow: function(component, event, helper){
        	var recordId = event.target.id;
    		console.log(recordId);
    		var navEvt = $A.get("e.force:navigateToSObject"); 
            navEvt.setParams({ "recordId": recordId }); 
            navEvt.fire();
    },
    updateAccountJs: function(component, event, helper) {
        var tradeTypeListVal = component.get("v.tradeTypeList");
        tradeTypeListVal = JSON.stringify(tradeTypeListVal);            
        console.log('tradeTypeListVal :',tradeTypeListVal);
        var action = component.get("c.updateAccountWithTradeTypes");
        action.setParams({ 
            acc: component.get('v.acc'),
            tradeTypeList : tradeTypeListVal
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (component.isValid() && state === "SUCCESS") {
                var rec = response.getReturnValue();
                console.log(rec);
                var a = component.get('c.init');
        		$A.enqueueAction(a);
            }
        });
        $A.enqueueAction(action);
    },
    //Handling events
    AddTradeTypeInstance : function(component, event, helper){
    	console.log('Add trade captured');
    	var ttInstance = event.getParam("TradeType");
		//component.set("v.TradeTypeInstance", ttInstance);
		var RowItemList = component.get("v.tradeTypeList");
        console.log('Length'+RowItemList.length);
        console.log('tt instance index'+ttInstance.index);
        
        /*if(RowItemList.length == 0){
            ttInstance.index = 0;
            RowItemList.push(ttInstance);
        }
        else if(RowItemList.length > 0){
            if(ttInstance.index == ''){
                ttInstance.index = RowItemList.length;
                RowItemList.push(ttInstance);

            }
        }*/
        var currentIndex = ttInstance.index;
        console.log('currentIndex'+currentIndex);
        if(currentIndex === ''){
            console.log('Entered len');
            ttInstance.index = RowItemList.length;
        }

		var abc = RowItemList.includes(ttInstance);
		console.log('ABC'+abc);
        console.log('Join1'+RowItemList.join());
		/*if(!RowItemList.includes(ttInstance)){
        	RowItemList.push(ttInstance);
    	}*/
        //RowItemList[ttInstance.index] = ttInstance;
        console.log('tt instance index 2'+ttInstance.index);

        RowItemList.splice(ttInstance.index, 1, ttInstance);
        console.log('Join2'+RowItemList.join());
        // set the updated list to attribute (contactList) again    
        component.set("v.tradeTypeList", RowItemList);
		helper.createObjectData(component, event);

    },
    EditTradeTypeInstance : function(component, event, helper){
    	console.log('Edit trade event captured');
		var index = event.getParam("indexVar");
        var AllRowsList = component.get("v.tradeTypeList");
        console.log('Edit index'+index);
        var editedTT = AllRowsList[index];
        console.log('Edited TT index'+editedTT.index);
        AllRowsList[index].index = index;
        component.set("v.tradeType", AllRowsList[index]);
        
        //Hide and show detail section on edit.
        var typeDetailComp = component.find("detail");
		var ttDetailSection = typeDetailComp.find('ttDetail');
		var ttButton = typeDetailComp.find('ttButton');
		$A.util.toggleClass(ttDetailSection, 'slds-hide');
		$A.util.toggleClass(ttButton, 'slds-hide');		
    },
    // function for delete the row 
    removeDeletedRow: function(component, event, helper) {
        // get the selected row Index for delete, from Lightning Event Attribute  
        var index = event.getParam("indexVar");
        console.log('Entered Us');
        // get the all List (contactList attribute) and remove the Object Element Using splice method    
        var AllRowsList = component.get("v.tradeTypeList");
        var tt = component.get("v.tradeType");
        console.log('No1:'+AllRowsList[index]);
        console.log('No2:'+tt.licenceNo);
        console.log('Entered Us too');
        //Need to revisit        
        //if(AllRowsList[index].licenceNo === tt.licenceNo){
        if(JSON.stringify(AllRowsList[index]) === JSON.stringify(tt)){
        	console.log('Entered Me');
	        var typeDetailComp = component.find("detail");
			var ttDetailSection = typeDetailComp.find('ttDetail');
			var ttButton = typeDetailComp.find('ttButton');
			$A.util.addClass(ttDetailSection, 'slds-hide');
			$A.util.removeClass(ttButton, 'slds-hide');
			helper.createObjectData(component, event);	        	
        }
		AllRowsList.splice(index, 1); 
        // set the contactList after remove selected row element  
        component.set("v.tradeTypeList", AllRowsList);
    }
})