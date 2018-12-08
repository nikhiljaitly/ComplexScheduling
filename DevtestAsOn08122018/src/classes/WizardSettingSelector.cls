public class WizardSettingSelector {
    public static List<Wizard_Setting__mdt> getWizardSettings() {
           return [select Id, MasterLabel, DeveloperName, Sections__c from Wizard_Setting__mdt ];
    }

}