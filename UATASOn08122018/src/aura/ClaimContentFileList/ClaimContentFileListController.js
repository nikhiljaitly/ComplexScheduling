({
	doInit : function(component, event, helper){
        console.log('doInit:');
        console.log('doInit Claim: '+component.get("v.recordId"));
        var action = component.get("c.fetchClaimContentDocument"); 
        action.setParams({
            objectId: component.get("v.recordId")
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS" && response.getReturnValue() != '') {
                component.set("v.listOfNotes", response.getReturnValue());
            }
            else if(state === "ERROR"){
                console.log('A problem occurred: ' + JSON.stringify(response.error));
            }
        });
        
        $A.enqueueAction(action);
	},
    hideExampleModal : function(component, event, helper) {
    	helper.hideExampleModal(component);
    },
	
	showPreviewModal : function(component, event, helper) {
        var LatestPublishedVersionId=event.target.id;
        var title=event.target.title;
        var comunitityName = window.location.pathname.substring(1,window.location.pathname.indexOf('/s'));
        console.log('LatestPublishedVersionId',LatestPublishedVersionId)
        component.set("v.comunitityName",comunitityName);
        component.set("v.LatestPublishedVersionId",LatestPublishedVersionId);
        if(title.indexOf("pdf") < 0){
            component.set("v.isPdf",false);
        }else{
            component.set("v.isPdf",true);
        }
    	helper.showExampleModal(component);
    },
})