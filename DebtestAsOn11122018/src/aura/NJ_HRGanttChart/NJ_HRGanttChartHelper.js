({
    drawChart: function (component, helper) { //load chart 
        console.log("[HRGanttChartHelper.drawChart] Drawing Gantt Chart...");
        var chartType = component.get('v.type');
        var chartToDraw = chartType + 'Chart';
        helper[chartToDraw](component, helper);
        component.set('v.chartRendered', true);
    },

   

    ganttChart: function (component, helper) { // Define Gantt chart
        
        console.log("[HRGanttChartHelper.ganttChart] Defining Gantt Chart...");
        console.log("[HRGanttChartHelper.ganttChart] Gantt Chart Data:");
        console.log(component.get("v.data"));
        
        AmCharts.makeChart( component.find('chartContainer').getElement(), {
            "type": "gantt",
            "theme": "light",
            "marginRight": component.get('v.ganttMarginRight'),
            "period": "hh",
         	"dataDateFormat":"YYYY-MM-DD HH:NN",
            "balloonDateFormat": "JJ:NN",
            "columnWidth": component.get('v.ganttColumnWidth'),
            "valueAxis": {
                "type": "date",
                "parseDates": true,
                "minPeriod": "hh"
            },
            "brightnessStep": component.get('v.ganttBrightnessStep'),
            "graph": {
                "fillAlphas": component.get('v.ganttFillAlphas'),
                "lineAlpha": component.get('v.ganttLineAlpha'),
                "lineColor": component.get('v.ganttLineColor'),
                "balloonText": "<b>[[apptNumber]] [[task]]</b><br /> <b>Start:</b> [[start]] <br /><b>Finish:</b> [[end]]<br /> <b>Status:</b> [[status]]<br /> <b>Assigned To:</b> [[assignedToName]]"
            },
            "rotate": component.get('v.ganttRotate'),
            "categoryField": "category",
            "segmentsField": "segments",
            "colorField": "color",
            "startDate": component.get('v.ganttStartDate'),
            "startDateField": "start",
            "endDateField": "end",
            "durationField": "duration",
            "dataProvider": component.get('v.data'),
            "valueScrollbar": {
                "autoGridCount":component.get('v.ganttAutoGridCount')
            },
            "chartCursor": {
                "cursorColor":component.get('v.ganttCursorColor'),
                "valueBalloonsEnabled": component.get('v.ganttValueBalloonsEnabled'),
                "cursorAlpha": component.get('v.ganttCursorAlpha'),
                "valueLineAlpha":component.get('v.ganttValueLineAlpha'),
                "valueLineBalloonEnabled": component.get('v.ganttValueLineBalloonEnabled'),
                "valueLineEnabled": component.get('v.ganttValueLineEnabled'),
                "zoomable":component.get('v.ganttZoomable'),
                "valueZoomable":component.get('v.ganttValueZoomable')
            },
            "export": {
                "enabled": true,
                "menu": []
            }
        } );
        
    },
    
    
})