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
	fetchData: function (component) {
        var contactAction = component.get("c.getClaimContactsEmailList"); 
        contactAction.setParams({
            claimId: component.get("v.recordId")
        });
        contactAction.setCallback(this,function(response){
            var loadResponse = response.getReturnValue();
            console.log('templates..!',loadResponse);            
            if(!$A.util.isEmpty(loadResponse)){                
                component.set('v.data',loadResponse); 
                var contactEdit = component.get("c.getClaimContacts"); 
                contactEdit.setParams({
                    claimId: component.get("v.recordId")
                });
                contactEdit.setCallback(this,function(response){
                    var loadResponse = response.getReturnValue();
                    if(!$A.util.isEmpty(loadResponse)){ 
                        var values = response.getReturnValue();                        
                        component.set('v.RecordConId',values[0].Id);
                        console.log(component.get('v.RecordConId'));
                    }
                });
                $A.enqueueAction(contactEdit);
            }
        });
        $A.enqueueAction(contactAction);       
        /*var contactAction = component.get("c.getClaimContacts"); 
        contactAction.setParams({
            claimId: component.get("v.recordId")
        });        
        
        var userAction = component.get("c.getClaimUsers"); 
        userAction.setParams({
            claimId: component.get("v.recordId")
        });
                
        Promise.all([this.execute(contactAction), this.execute(userAction)]).then(function(results){
            var data = [];
            results.forEach(function(result) {
                var values = result.getReturnValue();
                values.forEach(function(value) {
                    data.push(value);
                });
            });
            component.set("v.data", data);
        });*/
    },
    getEmailTempaltes : function(component, event) {
        var action = component.get("c.getTemplates");
        //action.setParams({"divisionId":selectedDivision});        
        action.setCallback(this,function(response){
            var loadResponse = response.getReturnValue();
            console.log('templates..!',loadResponse);            
            if(!$A.util.isEmpty(loadResponse)){                
                component.set('v.templates',loadResponse);                
            }
        });
        $A.enqueueAction(action);
    }
})