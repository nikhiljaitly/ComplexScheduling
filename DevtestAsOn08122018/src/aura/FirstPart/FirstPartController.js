({
	lookUpABN : function(component, event, helper) {

		console.log('Enter Here')
		//var abn = component.find('abn');
		var abn = document.getElementById("00N5D000000iNGK").value;
		console.log('ABN'+abn);
		var action = component.get("c.getAbnCalloutResponseContents");
		action.setParams({ abnVal : abn });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                // Alert the user with the value returned 
                // from the server
                alert("From server: " + response.getReturnValue());
                var abnData = response.getReturnValue();
                abnData = JSON.parse(abnData);
                //console.log("From server: " + response.get("EntityName");
                console.log("Gst: " + abnData.Gst);
                console.log("Name: " + abnData.EntityName);
                document.getElementById("company").value = abnData.EntityName;
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

	searchABNChange : function(component, event, helper) {

	    var firstpart = component.get("v.firstPartLead");
	    console.log("FirstPart"+firstpart);
		console.log('Entered on change'); 
		var abnErrTarget = component.find('abnError');
		$A.util.addClass(abnErrTarget, 'slds-hide');
        var abnInactiveErrTarget = component.find('abnInactiveError');
        $A.util.addClass(abnInactiveErrTarget, 'slds-hide'); 				
		var abn = document.getElementById("00N5D000000iNGK").value;
		component.set("v.abn",abn);
		console.log('ABN'+abn);
		var abnLength = abn.length;
		console.log('LENGTH'+abnLength);
		if(abnLength < 11){
			console.log('Length too low');
			component.set("v.valError",true);
			//slds-has-error
            firstpart.AbnStatus = '';
            firstpart.EntityName = '';
            firstpart.RegisteredForGst = '';
            firstpart.AddressPostcode = '';
            firstpart.AddressState = '';
            component.set("v.firstPartLead",firstpart);
			var abnFormTarget = component.find('abnForm');
			$A.util.addClass(abnFormTarget, 'slds-has-error');
			var cmpTarget = component.find('abnHelp');
			$A.util.removeClass(cmpTarget, 'slds-hide');
        }
		else if(abnLength == 11){
			console.log('Length is correct');
			component.set("v.valError",false);

			//slds-has-error
			var abnFormTarget = component.find('abnForm');
			$A.util.removeClass(abnFormTarget, 'slds-has-error');

			var cmpTarget = component.find('abnHelp');
			$A.util.addClass(cmpTarget, 'slds-hide');
			//callout
			var abnAction = component.get("c.getAbnCalloutResponseContents");
			abnAction.setParams({ abnVal : abn });			
			helper.getAbnDetails(component,abnAction);
		}		



	},

	validateForm : function(component, event, helper) {
		console.log('Entered submit');
		alert('Please correct all the errors')
		return true;
	},

	handleBlur : function (component, event) {
    var validity = component.find("abn").get("v.validity");
    console.log('blurrr'+validity.valid); //returns true
    },

    // function call on component Load
    doInit: function(component, event, helper) {
        // create a Default RowItem [Contact Instance] on first time Component Load
        // by call this helper function 
        console.log('Entered Init');
        helper.firstPartLeadData(component, event);
        helper.createObjectData(component, event);
        helper.fetchPickListVal(component, 'Trade_Type__c', 'detail');
        helper.fetchBusinessStructureVal(component, 'Business_Structure__c', 'businessStruc');
    },
    onPicklistChange: function(component, event, helper) {
        // get the value of select option
        alert(event.getSource().get("v.value"));
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
    },

    onSubmit: function(component, event, helper) {

        //Have to include validation code.
        //Check ABN validation and also whether ABN is present.
        var abn = document.getElementById("00N5D000000iNGK").value;
        var abnValError = component.get("v.valError");
        var typeDetailComp = component.find("detail");
        var tradeTypeValError = typeDetailComp.get("v.tradeTypeValError");
        console.log('abnValError'+abnValError);
        if(!abn){
           abnValError = true; 
            var abnFormTarget = component.find('abnForm');
            $A.util.addClass(abnFormTarget, 'slds-has-error');
            var cmpTarget = component.find('abnHelp');
            $A.util.removeClass(cmpTarget, 'slds-hide');          
        }
        console.log('Entered Submit');
        var allIds = component.get("v.validationErrorIds");
        console.log('All Ids Val'+allIds[0].value);
        var validityChecker = [];
        console.log('validity'+validity);
         for(var id in allIds){
            console.log('Entered loop');
            console.log('opt val'+ allIds[id].value);
            var comToCheck = component.find(allIds[id].value); 
            var validity = comToCheck.get('v.validity').valid;
            comToCheck.showHelpMessageIfInvalid();
            console.log('Validity'+validity);
            if(!validity){
                    validityChecker.push({
                        class: "valError",
                        value: allIds[id].value
                    });  

            }
        }
        if(validityChecker.length > 0 || abnValError || tradeTypeValError){
            //throw new Error("I can’t go on. This is the end.");
            //component.set("v.valError",true);
        }
        else{
            var firstPart = component.get("v.firstPartLead");
            console.log('FPart1'+firstPart);
            firstPart = JSON.stringify(firstPart);
            console.log('FPart2'+firstPart);
            var tradeTypeListVal = component.get("v.tradeTypeList");
            tradeTypeListVal = JSON.stringify(tradeTypeListVal);
            var leadCreateAction = component.get("c.createLeadAndTradeTypes");
            leadCreateAction.setParams({ leadFirstPartDetail : firstPart , tradeTypeList : tradeTypeListVal});          
            helper.createSFRecords(component,leadCreateAction);  
        }



    },          

})