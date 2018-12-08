({
    closeToastHelper : function(component) {
        component.set("v.displayToast",false);
        var timer = component.get("v.timer");
        clearTimeout(timer);
        component.set("v.timer", timer);
    }
})