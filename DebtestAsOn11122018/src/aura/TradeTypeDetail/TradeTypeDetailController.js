({
	createTradeType : function(component, event, helper) {
		console.log('Entered collapse');
		var noOfJobsCmp = component.find('noOfJobs');
		var ttDetailSection = component.find('ttDetail');
		var ttButton = component.find('ttButton');
		var makeSafeYes = component.find('msYes');
		var makeSafeRates = component.find('rates');

		$A.util.toggleClass(ttDetailSection, 'slds-hide');
		$A.util.toggleClass(ttButton, 'slds-hide');
		$A.util.addClass(noOfJobsCmp, 'hideModal');
		$A.util.addClass(makeSafeYes, 'hideModal');
		$A.util.addClass(makeSafeRates, 'hideModal');
	},

	clickCancel : function(component, event, helper) {

		var ttButton = component.find('ttButton');
		var ttDetailSection = component.find('ttDetail');
		$A.util.toggleClass(ttButton, 'slds-hide');
		$A.util.toggleClass(ttDetailSection, 'slds-hide');
	},
	clickAdd : function(component, event, helper) {
		//Fire Add trade type Event
        //Add validation here for the trade type fields.
        console.log('Entered Add');
        var allIds = component.get("v.tradeTypeValErrorIds");
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
        if(validityChecker.length > 0){
            component.set("v.tradeTypeValError",true);
            
        }else{
            component.set("v.tradeTypeValError",false);
            var ttButton = component.find('ttButton');
    		var ttDetailSection = component.find('ttDetail');		
    		console.log('Entered add trade type')
    		var tt = component.get("v.tradeTypeDet");
            console.log('TType',tt);
    		console.log('TType'+tt.licenceType);
    		console.log('TTNo'+tt.licenceNo);
    		console.log('TTMakeSafe'+tt.makeSafe);
    		//console.log('TT'+tt.licenceNo);
    		component.getEvent("AddTradeTypeEvt").setParams({"TradeType" : tt }).fire();
    		$A.util.toggleClass(ttButton, 'slds-hide');
    		$A.util.toggleClass(ttDetailSection, 'slds-hide');
        }		
	},

    handleAreaChange: function (cmp, event) {
        var changeValue = event.getParam("value");
        var selectedVals = cmp.find("serviceAreas").get("v.value");
        var allOptions = cmp.get("v.areaOptions");
        //alert(changeValue);
        //alert(selectedVals);
        //alert(allOptions[0].value);
        //show all the selected areas and hide the rest
        for(var opt in allOptions){
        	console.log('Entered loop');
        	console.log('opt val'+ allOptions[opt].value);
        	var tempVal = allOptions[opt].value;
        	var tempFind = cmp.find(tempVal);
        	if(selectedVals.includes(tempVal)){
        		console.log('Entered includes');
        		$A.util.removeClass(tempFind, 'hideModal');

			}else{
				console.log('Entered Else');
				
				$A.util.addClass(tempFind, 'hideModal');
			}

        }
		var noOfJobsCmp = cmp.find('noOfJobs');
		$A.util.removeClass(noOfJobsCmp, 'hideModal');
    },

    handleMakeSafeChange: function (component, event, helper) {
        //Do something with the change handler
        //alert(event.getParam('value'));
        //var makeSafeState = event.getParam("value")
        console.log('Entered make safe');
        var tt = component.get("v.tradeTypeDet");
        var makeSafeState = tt.makeSafe;
        console.log('makeSafeState1'+makeSafeState);
		var makeSafeYes = component.find('msYes');
        console.log('makeSafeState2'+makeSafeState);
        if(makeSafeState === 'Yes'){
        	console.log('Entered Yes')
        	$A.util.removeClass(makeSafeYes, 'hideModal');
		}
        else{
        	$A.util.addClass(makeSafeYes, 'hideModal');
        }

    },

    handleMakeSafeTypeChange: function (cmp, event) {
        var changeValue = event.getParam("value");
        var selectedVals = cmp.find("makeSafeTypes").get("v.value");
        var allOptions = cmp.get("v.makeSafeOptions");
        //alert(changeValue);
        //alert(selectedVals);
        //alert(allOptions[0].value);
        //show all the selected areas and hide the rest
        for(var opt in allOptions){
        	console.log('Entered loop');
        	console.log('Opt'+opt);
        	console.log('opt val'+ allOptions[opt].value);
        	var tempVal = allOptions[opt].value;
        	console.log('tempVal'+tempVal);
        	console.log('selVals'+selectedVals);
        	var tempFind = cmp.find(tempVal);
        	console.log('tempFind'+tempFind);
        	if(selectedVals.includes(tempVal)){
        		console.log('Entered includes');
        		$A.util.removeClass(tempFind, 'hideModal');

			}else{
				console.log('Entered Else');
				
				$A.util.addClass(tempFind, 'hideModal');
			}

        }
		var ratedCmp = cmp.find('rates');
		$A.util.removeClass(ratedCmp, 'hideModal');
    },    		

})