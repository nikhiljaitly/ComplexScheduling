public class WorkOrderLineItemListController {
	@AuraEnabled
    public static List<WorkOrderLineItem> fetchWorkOrderLineItems(String objectId) {
        List<WorkOrderLineItem> WorkOrderLineItemList=new List<WorkOrderLineItem>();             
        WorkOrderLineItemList=[Select Id,PricebookEntry.Name,LineItemNumber,Product_Description__c,WorkType.Name from WorkOrderLineItem 
                               where WorkOrderId =: objectId and Cash_Settled__c = false order by CreatedDate desc];
        return WorkOrderLineItemList;
    }
}