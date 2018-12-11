//class to Reset CostCentre & Trade Not exists flags.
public class HRResetCostCentreTrade {
    
    //Reset CostCentre & Trade Not exists flags
      @AuraEnabled
      public static void ResetCostCentreTrade(string workorderId) {  
          List<WorkOrder> workOrder = [SELECT id, CostCentre_Not_Exists__c, Trade_Not_Exists__c,WorkOrderNumber
                                       FROM WorkOrder
                                       WHERE Id =:workorderId
                                       LIMIT 1];
          system.debug('***workOrderToUpdate: ' + workOrder[0].WorkOrderNumber);
          if(workOrder.size() > 0){
              for (WorkOrder wo : workOrder){ 
                  wo.CostCentre_Not_Exists__c = false;
                  wo.Trade_Not_Exists__c = false;
              }
              update workOrder;
          }
          //return workOrder[0].WorkOrderNumber;
      }
}