public with sharing class AssessmentLineItemService {
	public List<Assessment_Report_Item__c> prepareAssessmentLineItemsFromJSON(String assessmentItemJSON, Id recordId){
         List<homeRepAssessToolController.AssessmentItem> items 
            = (List<homeRepAssessToolController.AssessmentItem>)JSON.deserialize(assessmentItemJSON, 
                List<homeRepAssessToolController.AssessmentItem>.class);
         //List<Assessment_Report_Item__c> assessmentLineItems = (new tqaopa_OpportunityLineItems()).convertOpportunityLineItems(items, recordId);

		 System.Debug(LoggingLevel.DEBUG, '***Deserialised JSON = ' + items);

		 List<Assessment_Report_Item__c> assessmentLineItems = new List<Assessment_Report_Item__c>();

		 for (homeRepAssessToolController.AssessmentItem a : items) {
			 Assessment_Report_Item__c ar = new Assessment_Report_Item__c();
			 ar.Claim__c = recordId;
			 ar.Assessment_Item__c = a.productId;
			 ar.Assessment_Item_Text__c = a.longDescription;
			 assessmentLineItems.add(ar);
		 }

		 System.Debug(LoggingLevel.DEBUG, '***Assessment Items to be Saved = ' + assessmentLineItems);
         
         return assessmentLineItems;
    }
    
    public void createAssessmentLineItems(String assessmentItemJSON, Id recordId){
        List<Assessment_Report_Item__c> assessmentLineItems 
            = prepareAssessmentLineItemsFromJSON(assessmentItemJSON, recordId);
        Savepoint sp = Database.setSavepoint();
        try{
            Database.SaveResult[] results = Database.insert(assessmentLineItems, true);
        }catch(DMLException ex){
             System.debug('The rows have issue is ' + ex.getNumDml());
             System.debug('The index is ' + ex.getDmlIndex(0));
             system.debug('The field is ' + ex.getDmlFields(0));
             system.debug('The error is ' + ex.getDmlMessage(0));
             throw ex;
        }
		System.Debug(LoggingLevel.DEBUG, '***Successfully Saved Assessment Report Items...');
         
    }
    
    public class OpportunityLineItemServiceException extends Exception{
        public List<Map<String, String>> errorResults {set;get;}
        
    }
}