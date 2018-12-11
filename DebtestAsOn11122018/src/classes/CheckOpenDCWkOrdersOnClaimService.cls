public with sharing class CheckOpenDCWkOrdersOnClaimService {

     @InvocableMethod(label='Check for Open WorkOrder' 
                      description='Returns WkOrderId if any with Status Not equals to Job Complete & Closed across claim.')

     public static List<String> checkWkOrderRecord(List<ID> ids) {		
         List<Claim_Job__c> claimId = [Select ID,Claim__c,Job_Type__c
                                       FROM Claim_Job__c 
                                       WHERE Id =: ids
                                      ];
         
         List<case> caseno = [Select ID,CaseNumber
                              FROM case 
                              WHERE Id =: claimId[0].Claim__c
                             ];
         
         
         List<WorkOrder> workOrderList = [Select ID,WorkOrderNumber,Status
                                          FROM WorkOrder 
                                          WHERE Claim__c =: caseno[0].CaseNumber AND
                                          Claim_Job_Type__c = 'doAndCharge' AND
                                          Status NOT IN('Job Complete','Closed')
                                         ]; 
       
        List<String> wkOrderId = new List<String>();
        for (WorkOrder workorder : workOrderList) {
            wkOrderId.add(workorder.Id);
            system.debug('WorkOrderID = '+ workorder.id);            
    }
    return wkOrderId;   
  }      
}