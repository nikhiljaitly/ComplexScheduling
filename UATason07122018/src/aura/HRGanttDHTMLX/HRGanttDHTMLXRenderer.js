({
		rerender: function (component, helper) {
        this.superRerender();
        
        if (!component.get('v.scriptsLoaded') || component.get('v.chartRendered')) {
            return;
        }
        
       helper.drawChart(component, helper);
    }
})