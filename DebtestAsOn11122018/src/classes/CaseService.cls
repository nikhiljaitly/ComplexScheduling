/***************************************************************** 
Purpose: Case Service for CaseTrigger                                                      
--------                                                            
VERSION        AUTHOR         DATE           DETAIL       Description 
1.0            Vasu          22/08/2018      Created      Home Repair Claim System  
*******************************************************************/
//Get the field set values
//For each of the field values, check if the value changed
//Get the type of each value from the custom metadata type.
//If that type already exists within the list of assessment items
public with sharing class CaseService {
    //private List<String> mobileFieldNames;
    private Map<String, Schema.DescribeFieldResult> mobileFieldNamesToDescribeMap;
    private Map<String, AssessmentReportItemsForMobile__mdt> reportItemsFromMobile;
    private Map<String, String> workCodeToProdIdMap;
    private AssessmentReportItemsForMobile__mdt reportItemFromMobile;
    private string reportType;
    private String oldfieldValue;
    private String newfieldValue;
    //Constructor
    public CaseService() {
        //get the custom metadata type and the field names from field set.
        AssessmentItemConfig assConfig = AssessmentItemConfig.getInstance();
        //field names from the field set
        mobileFieldNamesToDescribeMap = assConfig.fieldNameToDescribeMap;
        //Report items specific to reporting flow stored in custom metadata types.
        reportItemsFromMobile = assConfig.mobileReportItemsMap;
        //Report Item work code to product Id Map.
        workCodeToProdIdMap = assConfig.itemCodeToProdIdMap; 
        system.debug('workCodeToProdIdMap :'+workCodeToProdIdMap);       
    }
    /***************************************************************** 
Purpose: Assign Case AssignmentRule
Parameters:List<Case>
Returns: none
Throws [Exceptions]: DML                                                          
*******************************************************************/   
    public static void triggerClaimAssignmentRule(List<Case> claimList){
        system.debug('Entering triggerClaimAssignmentRule List of Case : '+claimList);

        List<Case> cList = new List<Case>();
        system.debug('claimList '+claimList);
        for(Case c : [select Id from case where Id in : claimList]) {
            Database.DMLOptions dmo = new Database.DMLOptions();
            dmo.assignmentRuleHeader.useDefaultRule = true;
            c.setOptions(dmo);
            Database.update(c);
            cList.add(c);
        }
        Database.update(cList);  
        system.debug('Exiting triggerClaimAssignmentRule');      
    }
    /***************************************************************** 
Purpose: Update Decline_Clause__c from ClaimDeclineClause__mdt (Custom Metadata Type)
Parameters:List<Case> and Map<Id,SObject> caseMap
Returns: none
Throws [Exceptions]: DML                                                          
*******************************************************************/   
    public static void updateClaimDeclineClause(List<Case> csList,Map<Id,SObject> caseMap){
        system.debug('Entering updateClaimDeclineClause List of Case : '+csList+ ' Map of Case :'+caseMap);
        Map<String, ClaimDeclineClause__mdt> declineClauseMap;
        //get the custom metadata type and the field names from field set.
        ClaimDeclineClauses declineClauseConfig = ClaimDeclineClauses.getInstance();
        //Report items specific to reporting flow stored in custom metadata types.
        declineClauseMap = declineClauseConfig.declineClauseMap;
        List<Case> caseUpdateList=new List<Case>();
        for (Case cs : [Select id,Insurance_Provider__r.Name,Decline_Reason_Details__c,Decline_Clause__c from Case where id IN : csList]) {
            Case newCase = cs;
            Case oldCase = (Case) caseMap.get(cs.Id); 
            system.debug('Case Clause '+newCase +'----'+oldCase);               
            if (cs.Insurance_Provider__c != oldCase.Insurance_Provider__c || cs.Decline_Reason_Details__c != oldCase.Decline_Reason_Details__c){
                system.debug('Case Clause '+newCase.Insurance_Provider__r.Name+'----'+newCase.Decline_Reason_Details__c);
                if(declineClauseMap.containskey(newCase.Insurance_Provider__r.Name+' '+newCase.Decline_Reason_Details__c)){
                    cs.Decline_Clause__c= declineClauseMap.get(newCase.Insurance_Provider__r.Name+' '+newCase.Decline_Reason_Details__c).Decline_Clause__c;
                    caseUpdateList.add(cs);                   
                }else{
                    cs.Decline_Clause__c=null;
                } 
            }                    
        }
        if(caseUpdateList.size() > 0){
            update caseUpdateList;
        }
        system.debug('Exiting updateClaimDeclineClause caseUpdateList: '+caseUpdateList);  
    }
     /***************************************************************** 
Purpose: generateClaimAssessmentReportItems
Parameters:List<Case> and Map<Id,SObject> caseMap
Returns: none
Throws [Exceptions]: DML                                                          
*******************************************************************/   
    public void generateClaimAssessmentReportItems(List<Case> csList,Map<Id,SObject> caseMap){
        system.debug('Entering generateClaimAssessmentReportItems List of Case : '+csList+ ' Map of Case :'+caseMap);
        List<Assessment_Report_Item__c> assessmentReportItems =  new List<Assessment_Report_Item__c>(); 
        List<Assessment_Report_Item__c> delassessmentReportItems =  new List<Assessment_Report_Item__c>();
        Map<String,List<Assessment_Report_Item__c>>caseIdToReportItemsMap=new Map<String,List<Assessment_Report_Item__c>>();
        List<String> caseIds=new List<String>();
        for (Case cs : csList) {
            caseIds.add(cs.id);
        }        
        if (caseIds.size() > 0){
                caseIdToReportItemsMap = getAssessmentReportItems(caseIds);
        }
        
        system.debug('caseIdToReportItemsMap'+caseIdToReportItemsMap);
        for (Case cs : csList) {
            Case newCase = cs;
            Case oldCase = (Case) caseMap.get(cs.Id);
                
            if (oldCase != null & caseIdToReportItemsMap !=null){
                delassessmentReportItems.addAll(deleteAssessmentReportItems(newCase, oldCase, caseIdToReportItemsMap));
            }
            assessmentReportItems.addAll(upsertAssessmentReportItems(newCase, oldCase, caseIdToReportItemsMap));
            
        }
        
        system.debug('assessmentReportItems'+assessmentReportItems);
        system.debug('delassessmentReportItems'+delassessmentReportItems);
        
        if(!assessmentReportItems.IsEmpty()){
            upsert assessmentReportItems;
        }
        if(!delassessmentReportItems.IsEmpty()){
            delete delassessmentReportItems;
        }
        system.debug('Exiting generateClaimAssessmentReportItems assessmentReportItems : '+assessmentReportItems); 
    }
     /***************************************************************** 
Purpose: upsertAssessmentReportItems
Parameters:Case newCase, Case oldCase and  Map<String,List<Assessment_Report_Item__c>> caseIdToReportItems
Returns: none
Throws [Exceptions]: List<Assessment_Report_Item__c>                                                          
*******************************************************************/ 
    public List<Assessment_Report_Item__c> upsertAssessmentReportItems(Case newCase, Case oldCase , Map<String,List<Assessment_Report_Item__c>> caseIdToReportItems) {
        system.debug('Entering upsertAssessmentReportItems Case : '+newCase+ ' Old Case :'+oldCase+' Map of Map<String,List<Assessment_Report_Item__c> :'+caseIdToReportItems);
        List<Assessment_Report_Item__c>assessmentReportItemsToUpsert = new List<Assessment_Report_Item__c>();
        List<Assessment_Report_Item__c>assessmentReportItemsToDelete = new List<Assessment_Report_Item__c>();
        List<Assessment_Report_Item__c> reportItems = new List<Assessment_Report_Item__c>();        
        Map<String,Assessment_Report_Item__c>reportItemsMap = new Map<String,Assessment_Report_Item__c>();
        Map<String, String> reportTypeToNewWorkCode = new Map<String, String>();
        Map<String, String> reportTypeToOldWorkCode = new Map<String, String>();
        if(caseIdToReportItems.containskey(newCase.Id)){
            reportItems = caseIdToReportItems.get(newCase.Id);
            for(Assessment_Report_Item__c ari : reportItems){
                reportItemsMap.put(ari.AssessmentMobileType__c, ari);
            }
        }        
        for(String field : mobileFieldNamesToDescribeMap.keySet()){            
            Schema.sObjectField fieldMetadata = mobileFieldNamesToDescribeMap.get(field).getSObjectField();            
            if(newCase.get(field) != oldCase.get(field)){                
                if (newCase.get(field) == null & oldCase.get(field) != null){                    
                }else{                    
                    newfieldValue = (String)newCase.get(fieldMetadata);                    
                    if (field == 'Potential_Risks_To_Trades__c' & newfieldValue != null ){
                        String[] potentialRiskOptions = newfieldValue.split(';');
                        for ( String pr:potentialRiskOptions){
                            newfieldValue = pr;
                            if (reportItemsFromMobile.get(newfieldValue) != NULL){
                                reportType = ' ';
                                reportItemFromMobile = reportItemsFromMobile.get(newfieldValue);
                                reportType = reportItemFromMobile.Type__c;
                                if(!String.isBlank(reportType)){
                                    reportTypeToNewWorkCode.put(reportType, reportItemFromMobile.Item_Code__c);                                    
                                }
                            }
                        }
                    }else{
                        if (reportItemsFromMobile.get(newfieldValue) != NULL){
                            if (field == 'Appoint_Repair_Link_Assessor__c' && newfieldValue == 'Yes'){
                                newfieldValue = 'Appoint Repair Link Assessor';
                            }                            
                            if (field == 'Cause_Detail__c' && newfieldValue == 'Accidental Loss or Damage'){
                                newfieldValue = 'Accidental Loss or Damage Cause';
                            }
                            reportType = ' ';
                            reportItemFromMobile = reportItemsFromMobile.get(newfieldValue);
                            reportType = reportItemFromMobile.Type__c;
                            if(!String.isBlank(reportType)){
                                reportTypeToNewWorkCode.put(reportType, reportItemFromMobile.Item_Code__c);
                                
                            }
                        }
                    }                    
                }                
            }
        }
        system.debug('reportTypeToNewWorkCode'+reportTypeToNewWorkCode);
        if(!reportTypeToNewWorkCode.IsEmpty()){
            if(!reportItemsMap.IsEmpty()){
                //call a method to check whether the types exists in the Report Items List.
                assessmentReportItemsToUpsert.addAll(checkAndAddAssessmentReportItems(reportItemsMap, reportTypeToNewWorkCode, newCase));
            }else{
                //If there are no existing report Items under the claim, just insert the new assessment items.
                for(String rType : reportTypeToNewWorkCode.keySet()){
                    assessmentReportItemsToUpsert.add(createNewAssessmentReportItem(reportTypeToNewWorkCode.get(rType), newCase.Id));   
                }
            }            
        }
        system.debug('Exiting upsertAssessmentReportItems assessmentReportItemsToUpsert: '+assessmentReportItemsToUpsert);
        return assessmentReportItemsToUpsert;        
    }
    /***************************************************************** 
Purpose: deleteAssessmentReportItems
Parameters:Case newCase, Case oldCase and  Map<String,List<Assessment_Report_Item__c>> caseIdToReportItems
Returns: List<Assessment_Report_Item__c>
Throws [Exceptions]: none
*******************************************************************/
    public List<Assessment_Report_Item__c> deleteAssessmentReportItems(Case newCase, Case oldCase , Map<String,List<Assessment_Report_Item__c>> caseIdToReportItems) {
        system.debug('Entering deleteAssessmentReportItems Case : '+newCase+ ' Old Case :'+oldCase+' Map of Map<String,List<Assessment_Report_Item__c> :'+caseIdToReportItems);
        List<Assessment_Report_Item__c>assessmentReportItemsToDelete = new List<Assessment_Report_Item__c>();
        List<Assessment_Report_Item__c> reportItems = new List<Assessment_Report_Item__c>();        
        Map<String,Assessment_Report_Item__c>reportItemsMap = new Map<String,Assessment_Report_Item__c>();
        Map<String, String> reportTypeToOldWorkCode = new Map<String, String>();
        if (caseIdToReportItems.containsKey(newCase.Id)){
            if(caseIdToReportItems.get(newCase.Id) != null & !caseIdToReportItems.get(newCase.Id).IsEmpty()){
                reportItems = caseIdToReportItems.get(newCase.Id);
                for(Assessment_Report_Item__c ari : reportItems){
                    reportItemsMap.put(ari.AssessmentMobileType__c, ari);
                }
            }   
        }
        system.debug('Mobile Map '+caseIdToReportItems);
        system.debug('Mobile'+mobileFieldNamesToDescribeMap.keySet());
        
        for(String field : mobileFieldNamesToDescribeMap.keySet()){
            //Check if the ReportItemsList for the case is null.
            
            Schema.sObjectField fieldMetadata = mobileFieldNamesToDescribeMap.get(field).getSObjectField();
            
            //perform null check for the field
            if(newCase.get(field) != oldCase.get(field)){
                
                if (field == 'Potential_Risks_To_Trades__c' & oldCase.get(field) != null){
                    oldfieldValue = (String)oldCase.get(field);
                    newfieldValue = (String)NewCase.get(field);
                    List <String> potentialRiskOptions = new List<String>();
                    if (newCase.get(field) == null){
                        potentialRiskOptions = oldfieldValue.split(';');
                    }else{
                        
                        Set<String> potentialRiskOldSet = new Set<String>(oldfieldValue.split(';'));
                        Set<String> potentialRiskNewSet = new Set<String>(newfieldValue.split(';'));
                        for(String pr: potentialRiskOldSet){
                            if(!potentialRiskNewSet.contains(pr) ){
                                potentialRiskOptions.add(pr);
                            }
                        }
                    }
                    for ( String pr: potentialRiskOptions){
                        oldfieldValue = pr;
                        reportType = ' ';
                        if (reportItemsFromMobile.get(oldfieldValue) != NULL){
                            reportItemFromMobile = reportItemsFromMobile.get(oldfieldValue);
                            system.debug('reportItemFromMobile: '+reportItemFromMobile);
                            
                            reportType = reportItemFromMobile.Type__c;  
                            if(!String.isBlank(reportType)){
                                reportTypeToOldWorkCode.put(reportType, reportItemFromMobile.Item_Code__c);                        
                            }
                        }
                    }
                }
                if ((newCase.get(field) == null||newCase.get(field) == 'No') & oldCase.get(field) != null){
                    oldfieldValue = (String)oldCase.get(field);
                    if (field == 'Appoint_Repair_Link_Assessor__c' && newCase.get(field) == 'No'){
                        oldfieldValue = 'Appoint Repair Link Assessor';
                    }
                    
                    reportType = ' ';
                    
                    if (reportItemsFromMobile.get(oldfieldValue) != NULL){
                        reportItemFromMobile = reportItemsFromMobile.get(oldfieldValue);
                        reportType = reportItemFromMobile.Type__c;  
                        if(!String.isBlank(reportType)){
                            reportTypeToOldWorkCode.put(reportType, reportItemFromMobile.Item_Code__c);                        
                        }
                    }
                }
                
            }
        }
        system.debug('reportTypeToOldWorkCode: '+reportTypeToOldWorkCode);                    
        if(!reportTypeToOldWorkCode.IsEmpty()){
            assessmentReportItemsToDelete.addAll(adddeleteAssessmentReportItems(reportItemsMap, reportTypeToOldWorkCode, newCase));
        }
        system.debug('Exiting upsertAssessmentReportItems assessmentReportItemsToDelete: '+assessmentReportItemsToDelete);
        return assessmentReportItemsToDelete;
    }  
    /***************************************************************** 
Purpose: checkAndAddAssessmentReportItems
Parameters:Map<String, Assessment_Report_Item__c>reportItems, Map<String, String>reportTypeToWorkCode, Case newCase
Returns: List<Assessment_Report_Item__c>
Throws [Exceptions]: none
*******************************************************************/
    public List<Assessment_Report_Item__c> checkAndAddAssessmentReportItems(Map<String, Assessment_Report_Item__c>reportItems, Map<String, String>reportTypeToWorkCode, Case newCase){
        system.debug('Entering checkAndAddAssessmentReportItems reportItems : '+reportItems+ ' reportTypeToWorkCode :'+reportTypeToWorkCode+ ' newCase : '+newCase);
        List<Assessment_Report_Item__c>reportItemsToUpsert = new List<Assessment_Report_Item__c>();
        for(String rt : reportTypeToWorkCode.KeySet()){
            system.debug('Mobile Type'+rt);
            //Check if the type already exists within the existing report items
            if(reportItems.KeySet().contains(rt)){
                Assessment_Report_Item__c aRIToUpdate = reportItems.get(rt);
                String newWorkCode = reportTypeToWorkCode.get(rt);
                aRIToUpdate.Assessment_Item__c = workCodeToProdIdMap.get(newWorkCode);
                reportItemsToUpsert.add(aRIToUpdate);
            }
            else{
                //create new Assessment items if the type does not exist among existing list of report items.
                reportItemsToUpsert.add(createNewAssessmentReportItem(reportTypeToWorkCode.get(rt), newCase.Id));                
            }
            
        }
        system.debug('Exiting checkAndAddAssessmentReportItems reportItemsToUpsert: '+reportItemsToUpsert);
        return reportItemsToUpsert;
    }
     /***************************************************************** 
Purpose: adddeleteAssessmentReportItems
Parameters:Map<String, Assessment_Report_Item__c>reportItems, Map<String, String>reportTypeToWorkCode, Case oldCase
Returns: List<Assessment_Report_Item__c>
Throws [Exceptions]: none
*******************************************************************/
    public List<Assessment_Report_Item__c> adddeleteAssessmentReportItems(Map<String, Assessment_Report_Item__c>reportItems, Map<String, String>reportTypeToWorkCode, Case oldCase){
        system.debug('Entering adddeleteAssessmentReportItems reportItems : '+reportItems+ ' reportTypeToWorkCode :'+reportTypeToWorkCode+ ' newCase : '+oldCase);
        List<Assessment_Report_Item__c>reportItemsToDelete = new List<Assessment_Report_Item__c>();
        for(String rt : reportTypeToWorkCode.KeySet()){
            //Check if the type already exists within the existing report items
            if(reportItems.KeySet().contains(rt)){
                Assessment_Report_Item__c aritDelete = reportItems.get(rt);
                reportItemsToDelete.add(aritDelete);
            }
        }
        system.debug('Exiting adddeleteAssessmentReportItems reportItemsToDelete : '+reportItemsToDelete);
        return reportItemsToDelete;
    }
     /***************************************************************** 
Purpose: createNewAssessmentReportItem 
Parameters:String workCode , String caseId
Returns: Assessment_Report_Item__c
Throws [Exceptions]: none
*******************************************************************/
    public Assessment_Report_Item__c createNewAssessmentReportItem (String workCode , String caseId){
        system.debug('Entering createNewAssessmentReportItem workCode : '+workCode+ ' caseId :'+caseId);
        Assessment_Report_Item__c ari = new Assessment_Report_Item__c();
        ari.Assessment_Item__c = workCodeToProdIdMap.get(workCode);
        ari.Claim__c = caseId;
        system.debug('Exiting createNewAssessmentReportItem ari: '+ari);
        return ari;
    }
     /***************************************************************** 
Purpose: getAssessmentReportItems
Parameters:List<string> caseIds
Returns: Map<String,List<Assessment_Report_Item__c>>
Throws [Exceptions]: none
*******************************************************************/
    public Map<String,List<Assessment_Report_Item__c>> getAssessmentReportItems(List<string> caseIds){  
        system.debug('Entering getAssessmentReportItems caseIds : '+caseIds);      
        Map<String,List<Assessment_Report_Item__c>>caseIdToItemsMap = new Map<String,List<Assessment_Report_Item__c>>();
        for(Case c : [Select Id ,(Select Assessment_Item__c, 
                                  Assessment_Item_Description__c, AssessmentMobileType__c, Claim__c
                                  FROM Assessment_Report_Items__r where AssessmentMobileType__c != '')
                      FROM Case where Id IN : caseIds]){
                          caseIdToItemsMap.put(c.Id,c.Assessment_Report_Items__r);
                          
                      }
        system.debug('Exiting getAssessmentReportItems caseIdToItemsMap : '+caseIdToItemsMap);
        return caseIdToItemsMap;
    }
}