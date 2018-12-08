({
	doInit : function(cmp, event, helper){
        console.log('doInit:');
        console.log('doInit Claim: '+cmp.get("v.recordId"));
         var cols = [
            {label: 'Name', fieldName: 'Name', type: 'text'},
            {label: 'Phone', fieldName: 'Phone', type: 'text'},
            {label: 'Contact Type', fieldName: 'Contact_Type__c', type: 'text'},
            {label: 'Email', fieldName: 'Email', type: 'text'}
        ];
        cmp.set("v.columns", cols);
        helper.getEmailTempaltes(cmp, event);
        helper.fetchData(cmp);
	},// This function call when the end User Select any record from the result list.   
    handleComponentEvent : function(component, event, helper) {
    	// get the selected Account record from the COMPONETN event 	 
       var selectedAccountGetFromEvent = event.getParam("recordByEvent");
       component.set("v.selectedRecord" , selectedAccountGetFromEvent); 
       var selectedvalue = component.get("v.selectedRecord");
       console.log('selectedvalue',JSON.stringify(selectedvalue));
	    //component.set("v.items",[]);
        var pillList=component.get("v.items");
        //component.set("v.conIds",[]);
        var conIdsList=component.get("v.conIds");
        // Display that fieldName of the selected rows
        var cols = {
            type: 'avatar',
            href: '',
            name:selectedvalue.Name,
            label: selectedvalue.Name,
            src: '/docs/component-library/app/images/examples/avatar2.jpg',
            fallbackIconName: 'standard:user',
            variant: 'circle',
            alternativeText: 'User avatar'
        };
        conIdsList.push(selectedvalue.Id);
        pillList.push(cols);  
        component.set("v.conIds",conIdsList);
        component.set("v.items",pillList);      
	},
    loadTemplate : function(component, event, helper) {
        console.log('responseVal..@getTemplate ');
        if(component.find('templateId').get('v.value') == ''){
            component.set("v.subjTxt",'');
            component.find("subjectText").set("v.disabled", false);            
        }else{
            component.find("subjectText").set("v.disabled", true); 
            helper.getTemplate(component, event);
        }                
    },
    sendEmailAction : function(component, event, helper) {
        helper.sendEmails(component, event);       
    },
    updateSelectedText: function (cmp, event) {
        var selectedRows = event.getParam('selectedRows');
        cmp.set('v.selectedRowsCount', selectedRows.length);
        cmp.set("v.items",[]);
        var pillList=cmp.get("v.items");
        cmp.set("v.conIds",[]);
        var conIdsList=cmp.get("v.conIds");
        // Display that fieldName of the selected rows
        for (var i = 0; i < selectedRows.length; i++){ 
            console.log(JSON.stringify(selectedRows));
            var cols = {
                        type: 'avatar',
                        href: '',
                		name:selectedRows[i].Name,
                        label: selectedRows[i].Name,
                        src: '/docs/component-library/app/images/examples/avatar2.jpg',
                        fallbackIconName: 'standard:user',
                        variant: 'circle',
                        alternativeText: 'User avatar'
            };
            conIdsList.push(selectedRows[i].Id);
            pillList.push(cols);
        }    
        cmp.set("v.conIds",conIdsList);
        cmp.set("v.items",pillList);
    }, 
    handleItemRemove: function (cmp, event) {
        var name = event.getParam("item").name;
        // Remove the pill from view
        var items = cmp.get('v.items');
        var item = event.getParam("index");
        items.splice(item, 1);
        cmp.set('v.items', items);
    },
    hideExampleModal : function(component, event, helper) {
    	helper.hideExampleModal(component);
    },
    sentEmail: function (cmp, event,helper) {
        cmp.set("v.shoMsg", false);
        helper.showExampleModal(cmp);
    }
})