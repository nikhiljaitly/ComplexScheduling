({
   onfocus : function(component,event,helper){
        var divsToHide = document.getElementsByClassName("slds-lookup__menu"); //divsToHide is an array
        for(var i = 0; i < divsToHide.length; i++){
            //divsToHide[i].style.visibility = "hidden"; // or
            divsToHide[i].style.display = "none"; // depending on what you're doing
        }
        document.getElementById(component.get("v.objectAPIName")+component.get("v.label")).style.display='none';
      	//console.log(component.get("v.objectAPIName")+component.get("v.label"));        
        var forOpen = component.find("searchRes");
        $A.util.addClass(forOpen, 'slds-is-open');
        $A.util.removeClass(forOpen, 'slds-is-close');
        document.getElementById(component.get("v.objectAPIName")+component.get("v.label")).style.display='block';
        // Get Default 5 Records order by createdDate DESC  
         var getInputkeyWord = '';
         helper.searchHelper(component,event,getInputkeyWord);        
       
    },
    keyPressController : function(component, event, helper) {
       // get the search Input keyword   
		var getInputkeyWord = component.get("v.SearchKeyWord");
       // check if getInputKeyWord size id more then 0 then open the lookup result List and 
       // call the helper 
       // else close the lookup result List part.   
        if( getInputkeyWord.length > 0 ){
             var forOpen = component.find("searchRes");
               $A.util.addClass(forOpen, 'slds-is-open');
               $A.util.removeClass(forOpen, 'slds-is-close');
            helper.searchHelper(component,event,getInputkeyWord);
        }
        else{  
             component.set("v.listOfSearchRecords", null ); 
             var forclose = component.find("searchRes");
               $A.util.addClass(forclose, 'slds-is-close');
               $A.util.removeClass(forclose, 'slds-is-open');
          }
         
	},
    
  // function for clear the Record Selaction 
    clear :function(component,event,heplper){      
         var pillTarget = component.find("lookup-pill");
         var lookUpTarget = component.find("lookupField"); 
        
         $A.util.addClass(pillTarget, 'slds-hide');
         $A.util.removeClass(pillTarget, 'slds-show');
        
         $A.util.addClass(lookUpTarget, 'slds-show');
         $A.util.removeClass(lookUpTarget, 'slds-hide');
      
         component.set("v.SearchKeyWord",null);
         component.set("v.listOfSearchRecords", null );
         component.set("v.selectedRecord", {} );         
    },
    
  // This function call when the end User Select any record from the result list.   
    handleComponentEvent : function(component, event, helper) {
    // get the selected Account record from the COMPONETN event 	 
       var selectedAccountGetFromEvent = event.getParam("recordByEvent");
	   console.log('selectedAccountGetFromEvent',selectedAccountGetFromEvent);
       component.set("v.selectedRecordId" , selectedAccountGetFromEvent.Id);
	   component.set("v.selectedRecord" , selectedAccountGetFromEvent);
       
        var forclose = component.find("lookup-pill");
           $A.util.addClass(forclose, 'slds-show');
           $A.util.removeClass(forclose, 'slds-hide');
      
        
        var forclose = component.find("searchRes");
           $A.util.addClass(forclose, 'slds-is-close');
           $A.util.removeClass(forclose, 'slds-is-open');
        if(component.get("v.isShow")){
            var lookUpTarget = component.find("lookupField");
                $A.util.addClass(lookUpTarget, 'slds-hide');
                $A.util.removeClass(lookUpTarget, 'slds-show');
            
            document.getElementById(component.get("v.objectAPIName")+component.get("v.label")).style.display='none';
        }
	},
  // automatically call when the component is done waiting for a response to a server request.  
    hideSpinner : function (component, event, helper) {
        var spinner = component.find('spinner');
        var evt = spinner.get("e.toggle");
        evt.setParams({ isVisible : false });
        evt.fire();    
    },
 // automatically call when the component is waiting for a response to a server request.
    showSpinner : function (component, event, helper) {
        var spinner = component.find('spinner');
        var evt = spinner.get("e.toggle");
        evt.setParams({ isVisible : true });
        evt.fire();    
    },
    // function call on component Load
    doInit: function(component, event, helper) { 
        console.log(component.get("v.isShow"));
        window.addEventListener('click', function(e){ 
            console.log('Clicked in box',e.target);
          if (document.getElementById('lookupOrder').contains(e.target)){
            	console.log('Clicked in box',e.target);
            	//document.getElementById('lookupOrder').style.display='none';
          } else{              
              console.log('Clicked out box',e.target.id);
              /*document.getElementById('lookupOrder').style.display='none';
              if(e.target.id == undefined){
                  document.getElementById('lookupOrder').style.display='block';
              }  */          
          }
        });
    }
})