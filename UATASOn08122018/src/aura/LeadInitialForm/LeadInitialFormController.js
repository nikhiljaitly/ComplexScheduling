({
    customActions: function(component, event, helper) {
        helper.customActionsAfterDataChanged(component, event);
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
        Promise.all([helper.getLeadCacheTable(component), 
                     helper.getLeadInitForm(component)]).then(
            function(responses) {
                console.log("response1", responses[0]);
                helper.handleFormResults(component, responses[1]);
                
            });
    },
    onSubmit: function(component, event, helper) {
        
        // Validate Lead
        // Validate Trade Compliance
        var leadCard = component.find("card");
        console.log(leadCard);
        var compliance = component.find("compliance");
        console.log(compliance);
        console.log(leadCard.validateFields());
        if(!leadCard.validateFields()){
            return;
        }
        
        var complianceRows = compliance.get("v.data");
        console.log(complianceRows);
        if(!complianceRows || complianceRows.length === 0){
            alert('Please enter compliance license details');
            return;
        }
        
        // Convert Lead Value Map into Lead value map
        var lead = leadCard.convertToRecord();
        if(lead.Copy_address_from_business__c){
            lead["Postal_Street__c"] =  lead["Street"];
            lead["Postal_Suburb__c"] =  lead["City"];
            lead["Postal_Postcode__c"] =  lead["PostalCode"];
            lead["Postal_State__c"] =  lead["State"];
        }

        console.log("lead", lead);
        // Add Trade Types
        var action = component.get("c.createLeadAndTradeCompliances");
        action.setParams({"leadDetail": JSON.stringify(lead), "tradeCompliances": JSON.stringify(complianceRows)});
        helper.execute(action).then(function(response) {
            console.log("Response", response); 
            var res = JSON.parse(response.getReturnValue());
            if(res.status != 'Success'){
                console.log('Unsuccessfull')
                if(res.status != 'isExist'){                      
                    alert('Not Success');	
                }else {
                    alert('You are already registered. Please contact Home Repair procurement team');
                }                      
            }else{
                window.location.href = '/EOI/s/thankyou?FormName=initial' ;
            }
            
        });
    }                  
    
})