/************************************************************************************************************
Name: WorkOrderLineItemHandler
=============================================================================================================
Purpose: Class for WorkOrderLineItem Trigger as Handler.
===============================================================================================================
History
-----------
VERSION    AUTHOR           DATE             DETAIL       DESCRIPTION
1.0        Vasu         10/10/2018        Created       Home Repair Claim System  
*************************************************************************************************************/
public with sharing class WorkOrderLineItemHandler implements ITrigger {
    private List<WorkOrderLineItem> woList = new List<WorkOrderLineItem>();
    public WorkOrderLineItemHandler() {}
    
    public void bulkBefore() {}
    public void bulkAfter() {
        system.debug('Entering bulkAfter With Trigger.New');
        if(Trigger.IsInsert||Trigger.IsUpdate){  
            WorkOrderLineItem woNewRec;
            WorkOrderLineItem woOldRec;
            for(Sobject woTemp : trigger.new){
                if (Trigger.Isupdate){
                    woNewRec = (WorkOrderLineItem)woTemp;
                    if (woNewRec.Site_Visit_Number__c != null){
                         system.debug('Vasu update');
                         woList.add(woNewRec);
                    }
                }else{
                     woNewRec = (WorkOrderLineItem)woTemp;
                    if (woNewRec.Site_Visit_Number__c != null){
                        system.debug('Vasu Insert');
                        woList.add(woNewRec);
                    }
                }
            }
        }
        system.debug('Exiting bulkAfter With Trigger.New');
    }
    public void beforeInsert(SObject so) {
    } 
    public void afterInsert(SObject so) {
    } 
    public void beforeUpdate(SObject oldSo, SObject so) {
        
    }
    public void beforeUnDelete(SObject so) {} 
    
    public void afterUpdate(SObject oldSo, SObject so) {} 
    public void beforeDelete(SObject so){} 
    public void afterDelete(SObject so) {} 
    public void afterUnDelete(SObject so) {} 
    public void andFinally() {
        system.debug('Entering and Finally from  WorkOrderLineItemHandler '+' woList: '+woList);
        if (!woList.isEmpty()){
             WorkOrderLineItemService.createServiceAppointment(woList);
        }
        system.debug('Exiting andFinally from WorkOrderLineItemHandler');
    }               
}