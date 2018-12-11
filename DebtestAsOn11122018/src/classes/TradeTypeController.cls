public  class TradeTypeController {
    
    public class PicklistOption {
        public PicklistOption( String label) {
            this.label = label;
        }
        public PicklistOption(String value, String label){
            this.value = value;
            this.label = label;
        }
        public Boolean hideChildren = true;
        public String value;
        public String label;
        public List<PicklistOption> children;
    }
    
    public class FieldEntry {
        public String objName {set;get;}
        public String apiName {set;get;}
        public String dependentFieldName {set;get;}
        public List<PicklistOption> options {set;get;}
        public Map<String, List<PicklistOption>> dependentOptions {set;get;}
    }
    
    @AuraEnabled
    public static String getOptions() {
        String WORKTYPE = 'Lead.Work_Type__c';
        String SERVICEAREAS = 'Lead.Service_Areas__c';
        return getOptions(WORKTYPE, SERVICEAREAS);
    }
    
    public static String getOptions(String WORKTYPE, String SERVICEAREAS) {
        List<FieldEntry> entries = new List<FieldEntry>();
        List<WorkType> workTypes = WorkTypeSelector.getWorkTypes();
        List<TradeTypeController.PicklistOption> workTypeOptions
            = (new WorkTypeDomain(workTypes)).getWorkTypeOptions();
        FieldEntry workTypeEntry  = new FieldEntry();
        workTypeEntry.apiName = WORKTYPE;
        workTypeEntry.options = workTypeOptions;
        entries.add(workTypeEntry); 
        
        
        FieldEntry serviceAreaEntry  = new FieldEntry();
        serviceAreaEntry.apiName = SERVICEAREAS;
        serviceAreaEntry.options = new List<TradeTypeController.PicklistOption> {ServiceTerritoryService.getServiceTerritories()};
        entries.add(serviceAreaEntry);
        return JSON.serialize(entries);    
    }
    
    @AuraEnabled
    public static String getTradeComplianceForm() {
        String TRADE_COMPLIANCE_FORM = 'Trade Compliance Form';
        Wizard_Setting__mdt setting 
            = WizardSettingService.getWizardSettingByName(TRADE_COMPLIANCE_FORM);
        return JSON.serialize(setting);
    }
    @AuraEnabled
    public static String getOptions(String entryStr) {
        return JSON.serialize(FieldUtils.fillOptions(entryStr));
    }
    @AuraEnabled
    public static String upsertTradeCompliance(String tradeComplianceStr) {
        List<Trade_Type__c> tradeCompliances 
            = (List<Trade_Type__c>)JSON.deserialize(tradeComplianceStr, List<Trade_Type__c>.class);
        //upsert tradeCompliances;
        return JSON.serialize(tradeCompliances);
    }
    @AuraEnabled
    public static String getDocuments(String tradeComplianceStr) {
        List<Trade_Type__c> tradeCompliances 
            = (List<Trade_Type__c>)JSON.deserialize(tradeComplianceStr, List<Trade_Type__c>.class);
        List<String> parentIds = new List<String>();
        for(Trade_Type__c tradeCompliance: tradeCompliances) {
            if(tradeCompliance.Id != null )
                parentIds.add(tradeCompliance.Id);
        }
        List<ContentDocumentLink> links = [Select id, ContentDocumentId, 
            ContentDocument.LatestPublishedVersion.Title, ContentDocument.LatestPublishedVersion.Description, 
            LinkedEntityId FROM ContentDocumentLink where LinkedEntityId in: parentIds];
        return JSON.serialize(links);
    }
    
    @AuraEnabled 
    public static List <WorkType> getWorkType(){
        List <WorkType> returnList = new List <WorkType> ();
        try {   
            returnList = [Select ID, WorkType.Name FROM WorkType                        
                         ];
            
        }// try ends
        
        catch (System.QueryException se) {
        }
        finally {}
        //return returnList[0].WorkType.Name;
        return returnList;
    }    
}