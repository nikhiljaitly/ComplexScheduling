({
	doInit : function(component, event, helper){
        helper.getEmailTempaltes(component, event);
        
	},
    clickPills : function(component, event, helper){
        console.log('immm...');
	},
    handleItemRemove: function(component, event, helper) {
		var name = event.getParam("item").name;
        // Remove the pill from view
        var contacts = component.get('v.contacts');
        var item = event.getParam("index");
        contacts.splice(item, 1);
        component.set('v.contacts', contacts);
	},
    showEmailComposer: function(component, event, helper) {
        var modal = component.find("FileModal");
        $A.util.removeClass(modal, 'slds-hide');
        helper.clearEmailComposer(component, event);
    },    
    hideEmailComposer: function(component, event, helper) {
        helper.clearEmailComposer(component, event);
        var modal = component.find("FileModal");
        $A.util.addClass(modal, 'slds-hide');
    },
    selectRecipients : function(component, event, helper) {
    	// get the selected Account record from the COMPONETN event 	 
       	var record = event.getParam("recordByEvent");
        var conts = component.get("v.contacts");
        var newRecord = true;
        conts.forEach(function(con) {
            if(con.Id === record.Id) {
                newRecord = false;
            }
        });
        if(newRecord){
            conts.push({
                type: 'avatar',
                href: '',
                name:record.Name,
                label: record.Name,
                variant: 'circle',
                Id: record.Id,
                alternativeText: 'User avatar'
            });
            component.set("v.contacts", conts); 
        }
        
    },
    loadTemplate : function(component, event, helper) {
        helper.getTemplate(component, event);
        
    },
    openAttachments: function(component, event, helper) {
        component.find("attachmentModal").toggleAttachmentModal();
    },
    sendEmail: function(component, event, helper) {
        helper.sendEmails(component, event);
    }
})