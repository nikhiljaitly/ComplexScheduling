({
	show: function (cmp, event) {
        var spinner = cmp.find("mySpinner");
        $A.util.removeClass(spinner, "slds-hide");
        $A.util.addClass(spinner, "slds-show");
    },
    hide:function (cmp, event) {
        var spinner = cmp.find("mySpinner");
        $A.util.removeClass(spinner, "slds-show");
        $A.util.addClass(spinner, "slds-hide");
    },
    showExampleModal : function(component) {      
        var modal = component.find("FileModal");
        $A.util.removeClass(modal, 'slds-hide'); 
        $A.util.addClass(spinner, "slds-show");
    },
    
    hideExampleModal : function(component) {
        var modal = component.find("FileModal");
        $A.util.addClass(modal, 'slds-hide');
    },
})