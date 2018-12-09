({
	rerender: function (component, helper) {
        this.superRerender();
        
        console.log("[HRGanttChartRenderer.rerender] Rerendering Gantt Chart...");
        
        if (!component.get('v.scriptsLoaded') || component.get('v.chartRendered')) {
            return;
        }
       helper.drawChart(component, helper);
    }
})