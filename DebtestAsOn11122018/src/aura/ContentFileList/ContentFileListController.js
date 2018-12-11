({
	doInit : function(component, event, helper){
        console.log('doInit: Invoice');
        var action = component.get("c.fetchContentDocument"); 
        action.setParams({
            objectId: component.get("v.recordId")
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            console.log('state',state);
            if (state === "SUCCESS" && response.getReturnValue() != '') {
                console.log('doInit Invoice :',response.getReturnValue());
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
        console.log('LatestPublishedVersionId',title)
        component.set("v.LatestPublishedVersionId",LatestPublishedVersionId);
        var comunitityName = window.location.pathname.substring(1,window.location.pathname.indexOf('/s'));
        console.log('LatestPublishedVersionId',LatestPublishedVersionId)
        component.set("v.comunitityName",comunitityName);
        if(title.indexOf("pdf") < 0){
            component.set("v.isPdf",false);
        }else{
            component.set("v.isPdf",true);
        }
    	helper.showExampleModal(component);
    },
})