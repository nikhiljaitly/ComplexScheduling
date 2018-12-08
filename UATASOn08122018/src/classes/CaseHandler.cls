/*
Apex Trigger to ensure that Appropriate Assessment Report Items
Are created when user interacts with the mobile App.
*/
/*To Do
1. Identify the fields on case which relates to Assessment Items in the background.
At the moment we have the following fields :
Appoint_Repair_Link_Assessor__c(If yes)
Cash_Settlement_Reason__c
Temporary_Accommodation_Reason__c
Asbestos__c
Safety_Repair_Working_Heights__c
Potential_Risks_To_Trades__c
Report_Type__c
Claim_Proceeding__c [Maintenance to be completed]
Claim_Proceeding__c (Decline)

*/

public class CaseHandler implements ITrigger {
    public List<Assessment_Report_Item__c> assessmentReportItems =  new List<Assessment_Report_Item__c>(); 
    public List<Assessment_Report_Item__c> delassessmentReportItems =  new List<Assessment_Report_Item__c>(); 
    public List<String>caseIds;
    public List<Case> claimList =  new List<Case>();
    public List<Case> claimAssessmentList =  new List<Case>();
    public Map<String,List<Assessment_Report_Item__c>>caseIdToReportItemsMap;
    
    public CaseHandler() {
        
    }
    
    public void bulkBefore() {
    }
    public void bulkAfter() {  
        if(checkRecursive.runOnce()||test.isRunningTest()){
            //write your code here   
            if(Trigger.IsInsert){
                claimList  = new List<Case>();
                for(Sobject claimTemp : trigger.new){ 
                    Case claimRec = (Case)claimTemp;
                    claimList.add(claimRec);
                }
            }
            if(Trigger.IsUpdate){  
                claimList  = new List<Case>();
                for(Sobject claimTemp : trigger.new){ 
                    Case claimRec = (Case)claimTemp;
                    Case oldCase = (Case) Trigger.OldMap.get(claimTemp.Id);
                    if(claimRec.Status != oldCase.Status){
                        claimList.add(claimRec);
                    }
                }
            } 
            if(Trigger.IsUpdate){
                for (SObject so: Trigger.new) {
                    Case newCase = (Case) so;
                    Case oldCase = (Case) Trigger.OldMap.get(so.Id);
                    claimAssessmentList.add(newCase);
               
                }
            }
        }             
                
            
        
        
    }
    public void beforeInsert(SObject so) {
    } 
    public void afterInsert(SObject so) {
        
    } 
    public void beforeUpdate(SObject oldSo, SObject so) {
    }
    public void beforeUnDelete(SObject so) {} 
    
    public void afterUpdate(SObject oldSo, SObject so) {
        
    }  
    public void beforeDelete(SObject so){} 
    public void afterDelete(SObject so) {} 
    public void afterUnDelete(SObject so) {} 
    public void andFinally() {
       system.debug('claimList :'+claimList);
       system.debug('claimAssessmentList :'+claimAssessmentList);
       if(Trigger.IsAfter){
            if (!claimList.isEmpty()){
                CaseService.triggerClaimAssignmentRule(claimList);
            } 
            if(!claimAssessmentList.isEmpty()){
                CaseService caseServ = new CaseService();
                caseServ.generateClaimAssessmentReportItems(claimAssessmentList,Trigger.OldMap);
                CaseService.updateClaimDeclineClause(claimAssessmentList,Trigger.OldMap);
            }
        } 
    }               
}