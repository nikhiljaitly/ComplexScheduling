public class ClaimPlannerController {
	@AuraEnabled
    public static List<ServiceAppointment> fetchClaimServiceWorkOrderLineItems(String claimId) {
        List<ServiceAppointment> serviceAppointmentList=new List<ServiceAppointment>();
        Set<string> srIds=new Set<string>(); 
        List<Case> claimList=[Select id,(Select id from Service_Appointments__r) from Case where id =:claimId];
        for(Case cs:claimList){
            if(cs.Service_Appointments__r.size() > 0){
                for(ServiceAppointment sr : cs.Service_Appointments__r){
                    srIds.add(sr.Id);
                }                
            }                                
        }
        for(ServiceAppointment sr : [Select id,(Select id,Description from Work_Order_Line_Items__r) from ServiceAppointment where id IN: srIds]){
                  serviceAppointmentList.add(sr);                     
        }
        /*List<ContentDocumentLink> ContentDocumentLinkList=new List<ContentDocumentLink>();
             
        List<AP_Invoice__c> apInvoiceList=[Select Id from AP_Invoice__c where Work_Order__c =: objectId];
        if(apInvoiceList.size() > 0){
            Set<String> invoiceIds=new Set<String>();
            for(AP_Invoice__c ap:apInvoiceList){
                invoiceIds.add(ap.Id);                
            }
            ContentDocumentLinkList=HomeRepairUtil.contentDocumentList(invoiceIds);
        }
        return ContentDocumentLinkList;*/
        return serviceAppointmentList;
    }
}