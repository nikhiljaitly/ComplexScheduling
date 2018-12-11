({
	doInit : function(component, event, helper){
        console.log('doInit:');
        var parentAction = component.get("c.fetchParentId"); 
        parentAction.setParams({
            objectId: component.get("v.recordId"),
            fieldOfParent : component.get("v.recordParentName")
        });
        parentAction.setCallback(this,function(response){
            var loadResponse = response.getReturnValue();
            component.set("v.recordParentId",loadResponse);
            console.log('recordParentId WorkOrder : ',loadResponse);            
            if(!$A.util.isEmpty(loadResponse)){                
                component.set('v.data',loadResponse); 
                var action = component.get("c.fetchWorkOrderContentDocument"); 
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
            }
        });
        $A.enqueueAction(parentAction); 
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