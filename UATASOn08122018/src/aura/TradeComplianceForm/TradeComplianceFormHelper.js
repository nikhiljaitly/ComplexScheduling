({
	execute : function(action) {
        return new Promise(function(resolve, reject) {
            action.setCallback(this, function(response) {
                var state = response.getState();
                if (state === "SUCCESS") {
                    resolve(response);
                }else if (state === "ERROR") {
                    reject(response);
                }
            });
            $A.enqueueAction(action);
        });
    },
    getInitForm : function(component) {
        var _self = this;
        var action = component.get("c.getTradeComplianceForm");
        return this.execute(action);
    },
    refreshCard : function(component){
        var card = component.find("card");
        card.refresh();
    },
    updateWizardSetting: function(component, wizardSetting) {
        var _self = this;
        var card = component.find("card");
        card.getPicklistOptions(wizardSetting).then(function(updatedSetting) {
            component.set("v.wizardSetting", updatedSetting);
            component.set("v.sections", updatedSetting.setting.sections);
            _self.refreshCard(component);
        });
    },
    handleFormResults : function(component, formRes) {
        var _self = this;

        var wizardSetting =JSON.parse(formRes.getReturnValue()); 
        _self.updateWizardSetting(component, wizardSetting); 
	},
})