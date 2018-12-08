({
    doInit : function(component, event, helper) {
        //creating datatable columns
        component.set('v.columns', [
            {label: 'TRADE TYPE', fieldName: 'WorkTypeName__c', type: 'text'},
            {label: 'LICENSE NUMBER', fieldName: 'License_Number__c', type: 'text'},
            {label: 'LICENSE EXPIRY', fieldName: 'License_Expiry__c', type: 'date'},
            {label: 'STATUS', fieldName: 'Status__c', type: 'text'},           
            {label: 'Action', type: 'button', initialWidth: 135, typeAttributes:
               { label: 'View', name: 'view_details', title: 'Click to View or Edit Details'}}
        ]);
        //getting Trade_Type__c records from server by calling helper methods
        helper.getTrades(component, helper);

    },
    //this function will be called when view button is pressed in datatable
    handleRowAction: function (component, event, helper) {
        var action = event.getParam('action');
        var tradetype = event.getParam('row');
        switch (action.name) {
            case 'view_details':
                component.set("v.recordId", tradetype.Id);
                break;
            default:
                component.set("v.recordId", tradetype.Id);
                break;
        }
        if(component.get("v.recordId")){
            component.set("v.showDetails", true);
        }
    },
    
    
    reloadDataTable : function(component, event, helper){
        var refreshEvent = $A.get("e.force:refreshView");
        if(refreshEvent){
            refreshEvent.fire();
        }
    }
})