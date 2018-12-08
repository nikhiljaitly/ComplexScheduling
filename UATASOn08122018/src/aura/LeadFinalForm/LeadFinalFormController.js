({  // This function that reads the url parameter Lead Id
    // and retrieves Lead details
	init : function(component, event, helper) {
            console.log ('entered Init');
        	var comunitityName = window.location.pathname.substring(1,window.location.pathname.indexOf('/s'));
        	component.set("v.comunitityName",comunitityName);
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
	
        var leadId  = getUrlParameter('LeadId');
     	//Get Lead details for Lead id
        var action = component.get("c.getLead");
        action.setParams({"leadId": leadId});

        action.setCallback(this, function(response) {
            var state = response.getState();
            if(component.isValid() && state == "SUCCESS"){
                var l = response.getReturnValue();
                console.log('Lead',l);                
                component.set("v.lead", l);
                component.set("v.isAvailable", true);
                
               
            } else {
                console.log('There was a problem : '+response.getError());
            }
        });
        $A.enqueueAction(action);
        
        var attachmentAction = component.get("c.getFiles");
        attachmentAction.setParams({"leadId": leadId});
        attachmentAction.setCallback(this, function(response) {
            var state = response.getState();
            if(component.isValid() && state == "SUCCESS"){
                helper.initiateAttachments(component,response);
                
            } else {
                console.log('There was a problem : '+response.getError());
            }
        });
        $A.enqueueAction(attachmentAction);
        
    },
    
     // This function updates Lead on Final Registration Submit 
    updateLeadJs: function(component, event, helper) {
        console.log('entered Submit '+ component.get("v.areasYouWorkareasYouWorkValue"));
        var publicLiabDateValError = component.get("v.plDateValidationError");
        var workCoverDateValError = component.get("v.wcDateValidationError");
        var WorkareasYouWorkValue = component.get("v.areasYouWorkareasYouWorkValue"); 
        //Check Input File Validation
        var bankDepositDocAdded=component.get("v.bankDepositDocAdded");
        var previousIssuesAdded=component.get("v.previousIssuesAdded");
        var previousComplaintsAdded=component.get("v.previousComplaintsAdded");
        var workCoverDocAdded=component.get("v.workCoverDocAdded");
        var publicLiabilityDocAdded=component.get("v.publicLiabilityDocAdded");
        var otherInsuranceDocAdded=component.get("v.otherInsuranceDocAdded");
        var policeCheckDocAdded=component.get("v.policeCheckDocAdded");
        
        if(WorkareasYouWorkValue.length > 0){
            var WorkareasYouWorkValueString='';
            for (var i=0; i < WorkareasYouWorkValue.length; i++) {
                WorkareasYouWorkValueString += WorkareasYouWorkValue[i] +';';           
            }
            component.set("v.lead.Specify_the_areas_you_currently_work_in__c", WorkareasYouWorkValueString);
        }
        var WorkareasYouWorkpreviouslyValue = component.get("v.areasYouWorkareasYouWorkpreviouslyValue");
         if(WorkareasYouWorkpreviouslyValue.length > 0){
            var WorkareasYouWorkpreviouslyValueString='';
            for (var i=0; i < WorkareasYouWorkpreviouslyValue.length; i++) {
                WorkareasYouWorkpreviouslyValueString += WorkareasYouWorkpreviouslyValue[i] +';';           
            }
            component.set("v.lead.Specify_the_areas_previously_worked_in__c", WorkareasYouWorkpreviouslyValueString);
        }
        console.log(component.get("v.lead"));
        var validityChecker = [];
        var allIds = component.get("v.validationErrorIds");
        console.log('All Ids Val ',allIds[0].value);        
         for(var id in allIds){
            //console.log('opt val'+ allIds[id].value);
            var comToCheck = component.find(allIds[id].value); 
            var validity = comToCheck.get('v.validity').valid;
            //console.log('Validity'+validity);
            comToCheck.showHelpMessageIfInvalid();
             if(!validity){
                    validityChecker.push({
                        class: "valError",
                        value: allIds[id].value
                    });
            }
        } 
        if(policeCheckDocAdded == false || publicLiabilityDocAdded == false || workCoverDocAdded == false || bankDepositDocAdded == false){
            alert('Please enter required fields.');
        }
        if(validityChecker.length > 0 || publicLiabDateValError || workCoverDateValError 
           || publicLiabilityDocAdded == false || workCoverDocAdded == false || bankDepositDocAdded == false ){
            console.log('Validation failed');
        }
        else{
        var action = component.get("c.updateFinalRegLead");
        var finalRegLead = component.get("v.lead");
        console.log('finalRegLead ',finalRegLead);
        action.setParams({"finalRegLead": finalRegLead});
        action.setCallback(this, function(response) {
            var state = response.getState();
            //Redirect to Thank you submit form if Lead update is success
            if(component.isValid() && state == "SUCCESS"){
                console.log('Saved : '+response.getReturnValue());
                window.location.href = '/'+component.get("v.comunitityName")+'/s/thankyou?FormName=final' ;
            } else {
                console.log('There was a problem : '+response.getError());
            }
        });
        	$A.enqueueAction(action);
        }
    },

    //If yes to any previous issues, show the file upload component.(Mathew)
    showAnyPreviousIssuesFiles: function(component, event, helper) {
    	console.log('Enetered Issues');
    	var leadRec = component.get("v.lead");
    	console.log('lead Id'+leadRec.Id);
        var anyPreviousIssues = component.find("AnyPreviousIssues").get("v.value");
        console.log('anyPreviousIssues'+anyPreviousIssues);
        if (anyPreviousIssues == 'Yes'){
        	console.log('Enetered Yes');
            document.getElementById("issuesUpload").style.display = 'Block';
            //show the file upload component

        }else{
            document.getElementById("issuesUpload").style.display = 'none';
            //Hide the file upload component
        }
    },
     //If yes to any previous issues, show the file upload component.(Mathew)
    showAnyPreviousComplaintsFiles: function(component, event, helper) {
        console.log('Enetered Complaints');
        var leadRec = component.get("v.lead");
        console.log('lead Id'+leadRec.Id);
        var anyPreviousComplaints = component.find("AnyPreviousComplaints").get("v.value");
        console.log('anyPreviousComplaints'+anyPreviousComplaints);
        if (anyPreviousComplaints == 'Yes'){
            console.log('Enetered Yes');
            document.getElementById("complaintsUpload").style.display = 'Block';
            //show the file upload component

        }else{
            document.getElementById("complaintsUpload").style.display = 'none';
            //Hide the file upload component
        }
    },   

    //If ‘Yes’, specify the areas you work in currently
    showAnyCurrentWorkOrders: function(component, event, helper) {
        var anyCurrentWorkOrders = component.find("AnyCurrentWorkOrders").get("v.value");
        if (anyCurrentWorkOrders == 'Yes'){
            document.getElementById("AnyCurrentWorkOrders").style.display = 'Block';
        }else{
            document.getElementById("AnyCurrentWorkOrders").style.display = 'none';
        }
    },
    //If ‘Yes’, specify the areas you work in previously
    showAnyPreviousWork: function(component, event, helper) {
        var anyPreviousWork = component.find("AnyPreviousWork").get("v.value");
        if (anyPreviousWork == 'Yes'){
            document.getElementById("AnyPreviousWork").style.display = 'Block';
        }else{
            document.getElementById("AnyPreviousWork").style.display = 'none';
        }
    },
    
    //Show Whoreferedyou field if Referred is selcted as "Yes"
    showRefer: function(component, event, helper) {
       var selectedRefered = component.find("Referred").get("v.value");
        if (selectedRefered == 'Yes'){
            document.getElementById("Whoreferredyou").style.display = 'Block';
        }
    },
    handleChange: function (cmp, event) {
        var changeValue = event.getParam("value");     
    },
    handleUploadFinished: function (cmp, event) {
    	// Get the list of uploaded files
    	console.log('Entered here after upload');
        var uploadedFiles = event.getParam("files");
        alert("Files uploaded : " + uploadedFiles.length);
    },
 	navigateToMyComponent : function(component, event, helper) {
		console.log('Entered Redirect');
        var evt = $A.get("e.force:navigateToComponent");
        evt.setParams({
            componentDef : "c:FileUpload",
            componentAttributes: {
                parentId : component.get("v.recordId"),
                recordId : component.get("v.recordId"),
                fileDescription : component.get("v.description"),
                quickActionCreated : true
            }
        });
        evt.fire();
    },
     // function for delete the row 
    removeDeletedRow: function(component, event, helper) {
        //get the selected row Index for delete, from Lightning Event Attribute 
        console.log('Entered the delete row handler') 
        var index = event.getParam("indexVar");
        var description = event.getParam("description");
        var attachId = event.getParam("Id");
        console.log('index'+index);
        console.log('description'+description);
        console.log('Id'+attachId);
        var descArray = [];
        var AllRowsList = component.get("v.attachments");        
        for (var i = 0; i < AllRowsList.length; i++) {

            if(AllRowsList[i].Id == attachId){
                console.log('Matched for i'+i);
                AllRowsList.splice(i, 1);
                i=i-1;
                console.log('New I'+i);

            }else{
                descArray.push(AllRowsList[i].Description);
            }

        }       
        if(attachId){
            // Call controller method to delete the attachment
            var action = component.get("c.deleteFiles");
            action.setParams({"fileId": attachId});
            action.setCallback(this, function(response) {
                var state = response.getState();
                //Redirect to Thank you submit form if Lead update is success
                if(component.isValid() && state == "SUCCESS"){
                    console.log('Saved : '+response.getReturnValue());
                    
                } else {
                    console.log('There was a problem : '+response.getError());
                }
            });
            $A.enqueueAction(action);           
        }   
        //AllRowsList.splice(index, 1); 
        console.log('AllRowsList'+AllRowsList);
        console.log('AllRowsList size'+AllRowsList.length);
        console.log('Desc Array size'+descArray.length);
        //var descArray = [];
        //component.set("v.workCoverDocAdded", false);
        //test attachlist to show/hide the file upload component.
            if(descArray.length > 0){
                console.log('Enetered descArray');
                if(descArray.indexOf("Work Cover Insurance Policy") > -1){
                    component.set("v.workCoverDocAdded", true);
                    //document.getElementById("workCoverUpload").style.display = 'none';  
                }else{
                    component.set("v.workCoverDocAdded", false);
                    //document.getElementById("workCoverUpload").style.display = 'Block';    
                }
                if(descArray.indexOf("Public Liability Insurance Policy") > -1){
                    component.set("v.publicLiabilityDocAdded", true);
                    //document.getElementById("publicLiabUpload").style.display = 'none';  
                }else{
                    component.set("v.publicLiabilityDocAdded", false);
                    //document.getElementById("publicLiabUpload").style.display = 'Block';    
                } 
                if(descArray.indexOf("Other Insurance Policy") > -1){
                    component.set("v.otherInsuranceDocAdded", true);
                    //document.getElementById("otherInsureUpload").style.display = 'none';  
                }else{
                    component.set("v.otherInsuranceDocAdded", false);
                    //document.getElementById("otherInsureUpload").style.display = 'Block';    
                }
                if(descArray.indexOf("Bank Deposit Slip") > -1){
                    component.set("v.bankDepositDocAdded", true);
                    //document.getElementById("otherInsureUpload").style.display = 'none';  
                }else{
                    component.set("v.bankDepositDocAdded", false);
                    //document.getElementById("otherInsureUpload").style.display = 'Block';    
                }
                if(descArray.indexOf("Police Check Document") > -1){
                    component.set("v.policeCheckDocAdded", true);
                    //document.getElementById("otherInsureUpload").style.display = 'none';  
                }else{
                    component.set("v.policeCheckDocAdded", false);
                    //document.getElementById("otherInsureUpload").style.display = 'Block';    
                }               

            }

        else {
            console.log('Entered No Docs')
            var testVal = component.get("v.bankDepositDocAdded");
            console.log('testVal'+testVal);
            component.set("v.workCoverDocAdded", false);
            component.set("v.publicLiabilityDocAdded", false);
            component.set("v.otherInsuranceDocAdded", false);
            component.set("v.bankDepositDocAdded", false);
            component.set("v.policeCheckDocAdded", false);
        }       
        component.set("v.attachments", AllRowsList);
    },
   /*call dateUpdate function on onchange event on date field*/ 
    expiryDateUpdate : function(component, event, helper) {
        
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
     var leadRec = component.get("v.lead"); 
        if(leadRec.Work_Cover_Expiry__c != '' && leadRec.Work_Cover_Expiry__c < todayFormattedDate){
            component.set("v.wcDateValidationError" , true);
        }else if(leadRec.Public_Liability_Expiry__c != '' && leadRec.Public_Liability_Expiry__c < todayFormattedDate){
            component.set("v.plDateValidationError" , true);  
        }
        else{
            component.set("v.wcDateValidationError" , false);
            component.set("v.plDateValidationError" , false);
        }
    },
   /*phone number validation on onchange event on phone field*/ 
    phoneChangeValidation : function(component, event, helper) {
        //var phoneno = /^\(?([0-9]{3})\)?[-. ]?([0-9]{3})[-. ]?([0-9]{4})$/; 
        var phoneno = /^\({0,1}((0|\+61)(2|4|3|7|8)){0,1}\){0,1}(\ |-){0,1}[0-9]{2}(\ |-){0,1}[0-9]{2}(\ |-){0,1}[0-9]{1}(\ |-){0,1}[0-9]{3}$/;
        var leadRec = component.get("v.lead");
        var mainPhoneVal = leadRec.Main_Business_Phone__c;
        var mainAltPhoneVal = leadRec.Alternate_Phone__c;
        var jrPhoneVal = leadRec.Job_Related_Phone__c;
        var jrAltPhoneVal = leadRec.JR_Alernate_Phone__c;
        var accountsPhoneVal = leadRec.Accounts_Phone__c;
        var accountsAltPhoneVal = leadRec.Accounts_Alt_Phone__c;

        var mainPhoneComp = component.find('mainAccountPhone');
        var mainAltPhoneComp = component.find('mainAccountAlternatePhone');
        var jrPhoneComp = component.find('JobPhone');
        var jrAltPhoneComp = component.find('JobAlternatePhone');
        var accountsPhoneComp = component.find('AccountPhone');
        var accountsAltPhoneComp = component.find('AccountAlternatePhone');


        console.log('mainPhoneVal'+mainPhoneVal);

        if(mainPhoneVal && mainPhoneVal.match(phoneno)) {
            console.log('Contact Phone Matched');
        }
        else {
            //alert("Not Matched");
            console.log('Entered here mainPhoneComp')
            if(mainPhoneComp){
                mainPhoneComp.set('v.validity', {valid:false, badInput :true});
            }
        }

        if(mainAltPhoneVal && mainAltPhoneVal.match(phoneno)){
            console.log('mainAltPhoneVal Phone Matched');
        }else if(!mainAltPhoneVal && mainAltPhoneComp){
           mainAltPhoneComp.set('v.validity', {valid:true, badInput :false}); 
        }
        else{
            if(mainAltPhoneComp){
                console.log('Entered here mainAltPhoneComp')
                mainAltPhoneComp.set('v.validity', {valid:false, badInput :true});
            }
            
        }

        if(jrPhoneVal && jrPhoneVal.match(phoneno)){
            console.log('jrPhoneVal Matched');
        }else{
           if(jrPhoneVal){ 
                jrPhoneComp.set('v.validity', {valid:false, badInput :true});
            }

        }

        if(jrAltPhoneVal && jrAltPhoneVal.match(phoneno)){
            console.log('jrAltPhoneVal Matched');
        }else if(!jrAltPhoneVal && jrAltPhoneComp){
            jrAltPhoneComp.set('v.validity', {valid:true, badInput :false}); 
        }else{
            if(jrAltPhoneComp){ 
                jrAltPhoneComp.set('v.validity', {valid:false, badInput :true});
            }           
        }
 

        if(accountsPhoneVal && accountsPhoneVal.match(phoneno)){
            console.log('accountsPhoneVal Matched');
        }else{
           if(accountsPhoneComp){ 
                accountsPhoneComp.set('v.validity', {valid:false, badInput :true});
            } 
        } 

        if(accountsAltPhoneVal && accountsAltPhoneVal.match(phoneno)){
            console.log('accountsAltPhoneVal Matched');
        }else if(!accountsAltPhoneVal && accountsAltPhoneComp){
            accountsAltPhoneComp.set('v.validity', {valid:true, badInput :false});             
        }else{
           if(accountsAltPhoneComp){ 
                accountsAltPhoneComp.set('v.validity', {valid:false, badInput :true});
            }
        }
    },               
})