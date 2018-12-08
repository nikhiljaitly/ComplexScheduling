({
	init : function(component, event, helper) {
        console.log ('entered Init');
        var AttachmentsList = component.get("v.attachmentsList");
        var AttachmentDesc = component.get("v.fileDescription");
        if(AttachmentsList.length > 0){          
	        for (var i = 0; i < AttachmentsList.length; i++) {

	            if(AttachmentsList[i].Description == AttachmentDesc){
	                console.log('Matched for AttachmentDesc'+ AttachmentDesc);
                    if(!AttachmentsList[i].fileName){
                        AttachmentsList[i].fileName = AttachmentsList[i].Name;
                    }
	                component.set("v.attachmentInstance", AttachmentsList[i]);
	            }
	        }
            var comunitityName = window.location.pathname.substring(1,window.location.pathname.indexOf('/s'));
        	component.set("v.comunitityName",comunitityName);
	    }

    },

    removeRow : function(component, event, helper){
     // fire the DeleteRowEvt Lightning Event and pass the deleted Row Index to Event parameter/attribute
       console.log('Entered Remove Row Event')
       var attach = component.get("v.attachmentInstance");
       component.getEvent("DeleteRowEvt").setParams({"indexVar" : component.get("v.rowIndex"), "description" : attach.Description, "Id" : attach.Id}).fire();
    }, 

  

})