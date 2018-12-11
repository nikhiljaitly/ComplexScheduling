/************************************************************************************************************
Name:  AccountCommunitTradeTypes_CC
=============================================================================================================
Purpose: Retrieves and updates Account details for Trade
Called by: AccountCommunitTradeTypes.cmp (Trade Portal component)
===============================================================================================================
History
-----------
VERSION    AUTHOR       DATE             DETAIL        DESCRIPTION
1.0        Vasu         09/02/2018      Created      Home Repairs Claims system
*************************************************************************************************************/
public without sharing class AccountCommunitTradeTypes_CC {
/***************************************************************** 
Purpose: Retrieves Account details                                                    
Parameters: account Id
Returns: Returns Account
Throws [Exceptions]: None                                                          
History                                                             
--------                                                            
VERSION        AUTHOR         DATE           DETAIL   Description 
1.0            Vasu           09/02/2018      Created      Home Repairs Claims system 
*******************************************************************/
    @AuraEnabled
    public static Account getAccount(string accId){
        system.debug('Entering  getAccount: ' + 'Account Id: ' + accId );
        User loggedUser=new User();
        if(accId == null || accId == 'null'){
            String userId = userinfo.getUserId();
            loggedUser = [SELECT ContactId, Contact.AccountId FROM User WHERE Id =:userId LIMIT 1];
            accId=loggedUser.Contact.AccountId;
        }
        Account selectAccount = [SELECT Id,Work_Cover_Insurance_Provider__c, 
                           Work_Cover_Insurance_State__c, Work_Cover_Amount__c, Work_Cover_Expiry__c, 
                           Public_Liability_Insurance_Provider__c, Public_Liability_Cover_Amount__c,
                           Bank_Account_Name__c, BSB__c, Account_Number__c,Branch__c,Job_Related_First_Name__c,
                           Job_Related_Phone__c, Job_Related_Alternate_Phone__c,Job_Related_Last_Name__c,
                           Accounts_First_Name__c,Accounts_Last_Name__c,AC_Position_in_Company__c, Accounts_Phone__c, Accounts_Alt_Phone__c,
                           Work_Type__c, Other_Work_Type__c, Service_Areas__c, Other_Service_Areas__c, Jobs_Per_Week__c, 
               Fully_qualified_tradesperson_Rate__c, Labourer_Rate__c, After_Hours_Rate__c, Call_Out_Rate__c, 
              Report_Rate__c, Other_Rate_s__c, Public_Liability_Expiry__c, Other_Insurance_Policies__c,
                           (Select id,ContentDocumentId,ContentDocument.LatestPublishedVersion.Title,ContentDocument.LatestPublishedVersion.Description FROM ContentDocumentLinks),
                           (Select Id,Trade_Type__c, License_Expiry__c,License_Number__c,Status__c from  Trade_Types__r)    
                           FROM Account WHERE id =: accId];
        system.debug('Exiting  getAccount: ' + 'selectAccount: ' + selectAccount);
        return selectAccount;
    }
    
    @AuraEnabled
    public static String getAccountForm() {
        String ACCOUNT_FORM = 'Account Form';
        Wizard_Setting__mdt setting 
            = WizardSettingService.getWizardSettingByName(ACCOUNT_FORM);
        return JSON.serialize(setting);
    }
    
    @AuraEnabled
    public static List < String > getselectOptions(sObject objObject, string fld) {
      system.debug('objObject --->' + objObject);
      system.debug('fld --->' + fld);
      List < String > allOpts = new list < String > ();
      // Get the object type of the SObject.
      Schema.sObjectType objType = objObject.getSObjectType();
     
      // Describe the SObject using its object type.
      Schema.DescribeSObjectResult objDescribe = objType.getDescribe();
     
      // Get a map of fields for the SObject
      map < String, Schema.SObjectField > fieldMap = objDescribe.fields.getMap();
     
      // Get the list of picklist values for this field.
      list < Schema.PicklistEntry > values =
       fieldMap.get(fld).getDescribe().getPickListValues();
     
      // Add these values to the selectoption list.
      for (Schema.PicklistEntry a: values) {
       allOpts.add(a.getValue());
      }
      system.debug('allOpts ---->' + allOpts);
      allOpts.sort();
      return allOpts;
     }
 /***************************************************************** 
Purpose: Update Lead details on final submit                                                   
Parameters: Lead details from final registration form
Returns: Returns message
Throws [Exceptions]: DML exception                                                        
History                                                             
--------                                                            
VERSION        AUTHOR         DATE           DETAIL   Description 
1.0            Vasu           09/02/2018     Created  Home Repairs Claims system
*******************************************************************/
    @AuraEnabled
    public static string updateFinalRegLead(Lead finalRegLead){
         system.debug('Entering  updateFinalRegLead: ' + 'finalRegLead: ' + finalRegLead );
        finalRegLead.Status='2nd Form Submitted';
        try{
             upsert finalRegLead;
        } catch(DMLException e) {
                system.debug('Error upserting lead- ' + e.getMessage());
            }
        system.debug('Exiting  updateFinalRegLead: ' + 'finalRegLead: ' + finalRegLead );
        return 'Update Successfully';        
    }
     /***************************************************************** 
Purpose: Delete Files                                                  
Parameters: Delete files uploaded by the trade portal visitor
Returns: Returns message
Throws [Exceptions]: DML exception                                                        
History                                                             
--------                                                            
VERSION        AUTHOR         DATE           DETAIL   Description 
1.0            Mathew        12/03/2018     Created  Home Repairs Trade Portal
*******************************************************************/
    @AuraEnabled
    public static string deleteFiles(Id fileId){
         system.debug('Entering  deleteFiles: ' + 'fileId: ' + fileId );
         attachment attachmentRecord = [Select Id,Name,Description from attachment where Id = :fileId Limit 1];

        try{
             if(attachmentRecord != NULL){
               delete attachmentRecord;
             }
        } catch(DMLException e) {
                system.debug('Error upserting lead- ' + e.getMessage());
            }
        system.debug('Exiting  deleteFiles: ' + 'attachmentRecord: ' + attachmentRecord.Id );
        return 'deleted success';        
    }
    
    @AuraEnabled
    public static String getCacheTable() {
        String WORKTYPE = 'Account.Work_Type__c';
        String SERVICEAREAS = 'Account.Service_Areas__c';
        return TradeTypeController.getOptions(WORKTYPE, SERVICEAREAS);
    }
    
    @AuraEnabled
    public static String insertTradeTypeForAccount(Account acc,Trade_Type__c ttype){
        try{
            Set<String> workTypeSet=new Set<String>();
            workTypeSet.add(ttype.Trade_Type__c);
            system.debug('workTypeSet:'+workTypeSet);
            Map<String,String> workTypeMap=new Map<String,String>();
            for(WorkType wt : [Select Id,Name from Worktype where Name IN: workTypeSet]){
                workTypeMap.put(wt.Name,wt.Id);
            }
            if(workTypeMap.containsKey(ttype.Trade_Type__c)){
                ttype.Work_Type__c = workTypeMap.get(ttype.Trade_Type__c);
            }
             ttype.Account__c = acc.Id;
             ttype.Status__c='Pending';
             insert ttype;
        } catch(DMLException e) {
            system.debug('Error upserting lead- ' + e.getMessage());
        }
        return ttype.Id; 
    }
    @AuraEnabled
    public static String updateAccount(Account acc, String tradeCompliances){
        List<Trade_Type__c> compliancesList = (List<Trade_Type__c>) JSON.deserialize(tradeCompliances, List<Trade_Type__c>.class);
        system.debug('compliances'+compliancesList);
        try{
            Set<String> workTypeSet=new Set<String>();
            for(Trade_Type__c compliance: compliancesList) {
                workTypeSet.add(compliance.Trade_Type__c);
            }
            system.debug('workTypeSet:'+workTypeSet);
            Map<String,String> workTypeMap=new Map<String,String>();
            for(WorkType wt : [Select Id,Name from Worktype where Name IN: workTypeSet]){
                workTypeMap.put(wt.Name,wt.Id);
            }
            for(Trade_Type__c tt : compliancesList){
                system.debug('tt.id '+tt.id);
                if(tt.id != null){                    
                }else{    
                    if(workTypeMap.containsKey(tt.Trade_Type__c)){
                         tt.Work_Type__c = workTypeMap.get(tt.Trade_Type__c);
                    }
                    tt.Status__c ='PENDING';
                }                
            }
            system.debug('compliances after'+compliancesList);
            upsert compliancesList;
                
            system.debug('account after '+acc);
            update acc;
        } catch(DMLException e) {
            system.debug('Error upserting lead- ' + e.getMessage());
        }
        return acc.Id; 
    }
    
    @AuraEnabled
    public static String upsertTradeCompliance(String tradeComplianceStr) {
        List<Trade_Type__c> tradeCompliances 
            = (List<Trade_Type__c>)JSON.deserialize(tradeComplianceStr, List<Trade_Type__c>.class);
        upsert tradeCompliances;
        return JSON.serialize(tradeCompliances);
    }            
    public class TradeTypeClass{
        //More to add as we go.
        public String index;
        public string tradeTypeVal;
     
        public List<String> qldAreaValue;
        public List<String> nswAreaValue;
        public List<String> vicAreaValue;
        public List<String> otherAreaValue;        

        public String Brisbane;
        public String GoldCoast;
        public String Sunshine;

        public String Central;
        public String Newcastle;
        public String Sydney;
        public String Wollongong;

        public String Geelong;
        public String Melbourne;
        public String RegionalVic;

        public String NT;
        public String TAS;
        public String WA;
        public String SA;

        public string makeSafe;
        public string makeSafeType;
        public String allDayRate;
        public String businessHoursRate;
        public String afterBusinessRate;
        public string licenceType;
        public string licenceNo;
        public string licenceExpiry;
        public String fullyQualifiedRate;
        public String labourerRate;
        public String afterHourRate;
        public String callOutRate;
        public String reportRate;
        public String otherRate;

    }
   
    public class responseHandler{
        public String status;
        public String AccountId;
    }
}