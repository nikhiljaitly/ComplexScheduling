public with sharing class WizardSettingService {
    private static List<Wizard_Setting__mdt> wizardSettings ;
    public static Wizard_Setting__mdt getWizardSettingByName(String name) {
        List<Wizard_Setting__mdt> settings = getWizardSettings();
        
        for(Wizard_Setting__mdt setting: settings) {
            if(setting.MasterLabel == name){
                return setting;
            }
        }
        return new Wizard_Setting__mdt(); 
    }
    
    public static List<Wizard_Setting__mdt> getWizardSettings () {
       if(wizardSettings == null )
            wizardSettings = WizardSettingSelector.getWizardSettings();
            
        return wizardSettings;
    }

}