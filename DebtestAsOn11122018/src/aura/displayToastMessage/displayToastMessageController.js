({
    
    invoke : function(component, event, helper) {
       // var args = event.getParam("arguments");
       // var callback = args.callback;       
        var message = component.get("v.message");
        var type = component.get("v.type");             
        helper.showToast(type, message);

       // callback("SUCCESS");
     /*  var workspaceAPI = component.find("workspace");
        workspaceAPI.getFocusedTabInfo().then(function(response) {
            var focusedTabId = response.tabId;
            workspaceAPI.closeTab({tabId: focusedTabId});
        })
        .catch(function(error) {
            console.log(error);
        })*/
    }
})