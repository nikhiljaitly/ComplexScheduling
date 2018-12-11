/************************************************************************************************************
Name: WorkOrderHandler
=============================================================================================================
Purpose: Class for WorkOrder Trigger as Handler.
===============================================================================================================
History
-----------
VERSION    AUTHOR           DATE             DETAIL       DESCRIPTION
1.0        Vasu         4/07/2018        Created       Home Repair Claim System  
*************************************************************************************************************/
public with sharing class WorkOrderHandler implements ITrigger {
    private List<WorkOrder> woList = new List<WorkOrder>();
    public WorkOrderHandler() {}
    
    public void bulkBefore() {}
    public void bulkAfter() {
        system.debug('Entering bulkAfter With Trigger.New');
        if(Trigger.Isupdate || Trigger.IsInsert){  
            WorkOrder woNewRec;
            WorkOrder woOldRec;
            for(Sobject woTemp : trigger.new){
                if (Trigger.Isupdate){
                    Sobject woOldTemp = Trigger.oldMap.get(woTemp.ID);
                    woNewRec = (WorkOrder)woTemp;
                    woOldRec = (WorkOrder)woTemp;
                    if (woNewRec.Site_Visit_Count__c != woOldRec.Site_Visit_Count__c){
                        woList.add(woNewRec);
                    }
                }else{
                    woNewRec = (WorkOrder)woTemp;
                    if (woNewRec.Site_Visit_Count__c != null){
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
        system.debug('Entering andFinally from  WorkOrderHandler '+' woList: '+woList);
        if (!woList.isEmpty()){
             WorkOrderService.createServiceAppointment(woList);
        }
        system.debug('Exiting andFinally from WorkOrderHandler');
    }               
}