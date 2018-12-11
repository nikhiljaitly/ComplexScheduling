({
    doInit : function(cmp, event, helper){
        console.log('doInit:');
        console.log('doInit Claim: '+cmp.get("v.recordId")); 
        helper.getEmailTempaltes(cmp, event);
        helper.fetchData(cmp);
    },
    updateSelectedText: function (cmp, event) {
        var selectedRows = event.getParam('selectedRows');        
        var pillList=[];
        // Display that fieldName of the selected rows
        for (var i = 0; i < selectedRows.length; i++){ 
            var cols = {
                type: 'avatar',
                href: '',
                name:selectedRows[i].name,
                label: selectedRows[i].name,
                variant: 'circle',
                Id: selectedRows[i].ID,
                alternativeText: 'User avatar'
            };
            pillList.push(cols);
        }    
        var caseEmail = cmp.find("emailComposer");
        caseEmail.set("v.contacts", pillList);
        cmp.set('v.selectedRowsCount', selectedRows.length);
    }, 
    handleItemRemove: function (cmp, event) {
        var name = event.getParam("item").name;
        // Remove the pill from view
        var items = cmp.get('v.items');
        var item = event.getParam("index");
        items.splice(item, 1);
        cmp.set('v.items', items);
    },
    
    showEmailComposer: function (component, event,helper) {
        component.set('v.selectedRowsCount', 0);
        component.find("contacts").set("v.selectedRows", []);
        var emailComposer = component.find("emailComposer");
        emailComposer.showComposer();
    }
})