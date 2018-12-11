public with sharing class ContentFileListController {
    @AuraEnabled
    public static List<ContentDocumentLink> fetchContentDocument(String objectId) {
        List<ContentDocumentLink> ContentDocumentLinkList=new List<ContentDocumentLink>();
             
        List<AP_Invoice__c> apInvoiceList=[Select Id from AP_Invoice__c where Work_Order__c =: objectId];
        if(apInvoiceList.size() > 0){
            Set<String> invoiceIds=new Set<String>();
            for(AP_Invoice__c ap:apInvoiceList){
                invoiceIds.add(ap.Id);                
            }
            ContentDocumentLinkList=HomeRepairUtil.contentDocumentList(invoiceIds);
        }
        return ContentDocumentLinkList;
    }
    @AuraEnabled
    public static List<ContentDocumentLink> fetchWorkOrderContentDocument(String objectId) {
        List<ContentDocumentLink> ContentDocumentLinkList=new List<ContentDocumentLink>();
        Set<String> workOrderIds=new Set<String>();
        workOrderIds.add(objectId);
        ContentDocumentLinkList=HomeRepairUtil.contentDocumentList(workOrderIds);
        return ContentDocumentLinkList;
    }
    @AuraEnabled
    public static string fetchParentId(String objectId,string fieldOfParent) {
        system.debug('SELECT '+fieldOfParent+' FROM WorkOrder WHERE id = \''+ objectId + '\' limit 1');
        WorkOrder workOrderList = Database.query('SELECT '+fieldOfParent+' FROM WorkOrder WHERE id = \''+ objectId + '\' limit 1');
        return (string)workOrderList.get(fieldOfParent);
    }
    @AuraEnabled
    public static List<ContentDocumentLink> fetchClaimContentDocument(String objectId) {
        List<ContentDocumentLink> ContentDocumentLinkList=new List<ContentDocumentLink>();
        Set<String> caseIds=new Set<String>();
        List<WorkOrder> workOrderList=[Select id,CaseId from WorkOrder where id =: objectId];
        system.debug(workOrderList[0]);
        if(workOrderList.size() > 0){
            system.debug(workOrderList[0]);
            if(workOrderList[0].CaseId != null){
                caseIds.add(workOrderList[0].CaseId);
        		ContentDocumentLinkList=HomeRepairUtil.contentDocumentList(caseIds);
            }        	
        }
        return ContentDocumentLinkList;
    }
}