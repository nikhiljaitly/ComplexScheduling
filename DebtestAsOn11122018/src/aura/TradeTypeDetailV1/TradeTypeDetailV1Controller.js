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
        var licenseExpiryValError = component.get("v.lExpiryDateValidationError");
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
        if(validityChecker.length > 0 || licenseExpiryValError){
            component.set("v.tradeTypeValError",true);
            
        }else{
            component.set("v.tradeTypeValError",false);
            var ttButton = component.find('ttButton');
    		var ttDetailSection = component.find('ttDetail');		
    		console.log('Entered add trade type')
    		var tt = component.get("v.tradeTypeDet");

    		console.log('TType'+tt.licenceType);
    		console.log('TTNo'+tt.licenceNo);
    		console.log('TTMakeSafe'+tt.makeSafe);
    		//console.log('TT'+tt.licenceNo);
            component.find("national").set("v.checked",false);
            component.find("qld").set("v.checked",false);
            component.find("nsw").set("v.checked",false);
            component.find("vic").set("v.checked",false);
            component.find("qld").set("v.disabled",false); 
            component.find("nsw").set("v.disabled",false); 
            component.find("vic").set("v.disabled",false);
            component.find("national").set("v.disabled",false);

            //Transform the area values here so that the controller recognises the null input.
            if(tt.qldAreaValue === '' || !tt.qldAreaValue){
                console.log('Entered null qld');
                tt.qldAreaValue = ["Blank"];
            } 
            if(tt.nswAreaValue === '' || !tt.nswAreaValue){
                console.log('Entered null nsw');
                tt.nswAreaValue = ["Blank"];                
            }
            if(tt.vicAreaValue === '' || !tt.vicAreaValue){
                console.log('Entered null Vic');
                tt.vicAreaValue = ["Blank"];                
            }
            if(tt.otherAreaValue === '' || !tt.otherAreaValue){
                console.log('Entered null Others');
                tt.otherAreaValue = ["Blank"];                
            }  
            
            component.getEvent("AddTradeTypeEvt").setParams({"TradeType" : tt }).fire();
    		$A.util.toggleClass(ttButton, 'slds-hide');
    		$A.util.toggleClass(ttDetailSection, 'slds-hide');
        }
        console.log('tt',tt);
        component.getEvent("InsertTradeEvt").setParams({"trade" : tt}).fire();
	},

    handleRegionChange: function (cmp, event, helper) {
        //var changeValue = event.getParam("value");
        var changeValue = cmp.get("v.national");
        console.log('changeValue'+changeValue);
        var nationalVal = cmp.find("national").get("v.checked");
        var qldVal = cmp.find("qld").get("v.checked");
        var nswVal = cmp.find("nsw").get("v.checked");
        var vicVal = cmp.find("vic").get("v.checked");
        console.log('nationalVal'+nationalVal);
        console.log('qldVal'+qldVal);
        console.log('nswVal'+nswVal);
        console.log('vicVal'+vicVal);

        var optionsNational = ['Brisbane','Gold Coast','Sunshine Coast','Central Coast','Newcastle','Sydney','Wollongong','Geelong','Melbourne','Regional Victoria','NT','TAS','WA','SA'];
        var optionsQld = ['Brisbane','Gold Coast','Sunshine Coast'];
        var optionsNSW = ['Central Coast','Newcastle','Sydney','Wollongong'];
        var optionsVic = ['Geelong','Melbourne','Regional Victoria'];
        var optionsOthers = ['NT','TAS','WA','SA'];

        if(nationalVal){
           console.log('All Set to enter helper in..');
           cmp.find("qld").set("v.disabled",true); 
           cmp.find("nsw").set("v.disabled",true); 
           cmp.find("vic").set("v.disabled",true);
           console.log('All Set to enter helper mid..');
           //check all the boxes.
           cmp.find("qldAreas").set("v.value", optionsQld);
            console.log('All Set to enter helper1');
           cmp.find("nswAreas").set("v.value", optionsNSW);
            console.log('All Set to enter helper2');
           cmp.find("vicAreas").set("v.value", optionsVic);
            console.log('All Set to enter helper3');
           cmp.find("otherAreas").set("v.value", optionsOthers);
           console.log('All Set to enter helper');
           helper.renderRatesByArea(cmp, event, optionsNational);
        }else{
           cmp.find("qld").set("v.disabled",false); 
           cmp.find("nsw").set("v.disabled",false); 
           cmp.find("vic").set("v.disabled",false);
           cmp.find("qldAreas").set("v.value",'');
           cmp.find("nswAreas").set("v.value",'');
           cmp.find("vicAreas").set("v.value",'');
           cmp.find("otherAreas").set("v.value",'');
           helper.unRenderRatesByArea(cmp, event, optionsNational);
        }
        if(qldVal || nswVal || vicVal){
            cmp.find("national").set("v.disabled",true);
            if(qldVal){
                cmp.find("qldAreas").set("v.value", optionsQld);
                helper.renderRatesByArea(cmp, event, optionsQld);    
            }else{
                //To do.  
            }
            if(nswVal){
                cmp.find("nswAreas").set("v.value", optionsNSW);
                helper.renderRatesByArea(cmp, event, optionsNSW);                   
            }else{
                //To do
            }
            if(vicVal){
                cmp.find("vicAreas").set("v.value", optionsVic);
                helper.renderRatesByArea(cmp, event, optionsVic);                  
            }else{
                //To do
            }

        }else{
            cmp.find("national").set("v.disabled",false); 
        }
                   //Unhide the section
        var noOfJobsCmp = cmp.find('noOfJobs');
        $A.util.removeClass(noOfJobsCmp, 'hideModal');          
    },
    handleAreaChange: function (cmp, event, helper) {
        var optionsNational = ['Brisbane','Gold Coast','Sunshine Coast','Central Coast','Newcastle','Sydney','Wollongong','Geelong','Melbourne','Regional Victoria','NT','TAS','WA','SA'];
        var optionsQld = ['Brisbane','Gold Coast','Sunshine Coast'];
        var optionsNSW = ['Central Coast','Newcastle','Sydney','Wollongong'];
        var optionsVic = ['Geelong','Melbourne','Regional Victoria'];
        var optionsOthers = ['NT','TAS','WA','SA'];

        var changeValue = event.getParam("value");
        var src = event.getSource();
        var sourceId = src.getLocalId();
        console.log('AuraId'+sourceId);

        var selectedQldVals = cmp.find("qldAreas").get("v.value");
        var selectedVicVals = cmp.find("vicAreas").get("v.value"); 
        var selectedNSWVals = cmp.find("nswAreas").get("v.value");  
        var selectedOtherVals = cmp.find("otherAreas").get("v.value"); 

        var noOfJobsCmp = cmp.find('noOfJobs');
        $A.util.removeClass(noOfJobsCmp, 'hideModal');  

        /*alert('changeValue'+changeValue);  
        alert('selectedQldVals'+selectedQldVals);
        alert('selectedVicVals'+selectedVicVals);
        alert('selectedNSWVals'+selectedNSWVals);
        alert('selectedOtherVals'+selectedOtherVals);*/
        if(changeValue.length == 0){
            console.log('changeval length > 0');
            
            if(sourceId == 'qldAreas'){
                helper.unRenderRatesByArea(cmp, event, optionsQld);
            }else if(sourceId == 'vicAreas'){
                helper.unRenderRatesByArea(cmp, event, optionsVic);
            }else if(sourceId == 'nswAreas'){
                helper.unRenderRatesByArea(cmp, event, optionsNSW);
            }else if(sourceId == 'otherAreas'){
                helper.unRenderRatesByArea(cmp, event, optionsOthers);
            }


        }else{

            for(var opt in changeValue){
                var tempVal = changeValue[opt];
                //alert('tempVal::'+tempVal);
                if(optionsQld.includes(tempVal)){
                    //alert('Entered Qld');
                    helper.unRenderRatesByChangedValue(cmp, event, optionsQld, changeValue);
                    break;
                }
                else if(optionsNSW.includes(tempVal)){
                    //alert('Entered NSW'); 
                    helper.unRenderRatesByChangedValue(cmp, event, optionsNSW, changeValue);
                    break;
                }
                else if(optionsVic.includes(tempVal)){
                    //alert('Entered Vic');
                    helper.unRenderRatesByChangedValue(cmp, event, optionsVic, changeValue);
                    break;

                }
                else if(optionsOthers.includes(tempVal)){
                    //alert('Entered Others');
                    helper.unRenderRatesByChangedValue(cmp, event, optionsOthers, changeValue);
                    break;

                }            
            }
        }


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
        var hourlyRates = component.find('hourlyRates');
        console.log('makeSafeState2'+makeSafeState);
        if(makeSafeState === 'MakeSafe'){
        	console.log('Entered Yes')
        	$A.util.removeClass(makeSafeYes, 'hideModal');
            $A.util.addClass(hourlyRates, 'hideModal');
		}
        else{
        	$A.util.addClass(makeSafeYes, 'hideModal');
            $A.util.removeClass(hourlyRates, 'hideModal');
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
   /*call dateUpdate function on onchange event on date field*/ 
    expiryDateUpdate : function(component, event, helper) {
        var tt = component.get("v.tradeTypeDet");
        var today = new Date();        
        var dd = today.getDate();
        var mm = today.getMonth() + 1; //January is 0!
        var yyyy = today.getFullYear();
     // if date is less then 10, then append 0 before date   
        if(dd < 10){
            dd = '0' + dd;
        } 
    // if month is less then 10, then append 0 before date    
        if(mm < 10){
            mm = '0' + mm;
        }
        
        var todayFormattedDate = yyyy+'-'+mm+'-'+dd;
        if(tt.licenceExpiry != '' && tt.licenceExpiry < todayFormattedDate){
            component.set("v.lExpiryDateValidationError" , true);
        }else{
            component.set("v.lExpiryDateValidationError" , false);
        }
    },         		

})