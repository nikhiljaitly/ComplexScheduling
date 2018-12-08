({
    handleOnChange : function(component, event, helper) {
        component.set( "v.selectedRecordId", event.getParams( "fields" ).value );
        component.set( "v.recordId", event.getParams( "sWorkOrder" ).value );
        //console.log('selProdId ' + component.get( "v.selectedRecordId"));
        //console.log("***workOrderIdOnLookupSelection " + component.get( "v.woRecordID"));
        
        helper.searchHelper(component);
    },
    
    fetchWorkOrderID : function(component, event, helper) {
        console.log('fetchWorkOrderID11');
        component.set( "v.recordId", event.getParams( "sWorkOrder" ).value );
        console.log('workOrderIdOnLoad ' + component.get( "v.recordId"));
    },
    
    doInit : function(component, event, helper) {
        
    },
})