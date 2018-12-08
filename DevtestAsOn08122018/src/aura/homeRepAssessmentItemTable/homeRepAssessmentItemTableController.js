({
	cancel: function(component, event, helper){
        component.set("v._error", '');
		helper.fireHandleAssessmentItemsEvent(component, "cancel");
    },
    save: function(component, event, helper){
        if(helper.validateRequiredField(component)){
            helper.fireHandleAssessmentItemsEvent(component, "save");        
        }
    },
    handleErrors: function(component, event, helper){

        var response =event.getParam('arguments')._server_response;
        helper.handleErrorOfAssessmentItemsCreation(response, component);
    }
})