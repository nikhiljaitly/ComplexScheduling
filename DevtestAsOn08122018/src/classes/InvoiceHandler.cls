/************************************************************************************************************
Name: InvoiceHandler
=============================================================================================================
Purpose: Class for Invoice Trigger as Handler.
===============================================================================================================
History
-----------
VERSION    AUTHOR           DATE             DETAIL       DESCRIPTION
1.0        Vasu         4/07/2018        Created       Home Repair Claim System  
*************************************************************************************************************/
public with sharing class InvoiceHandler implements ITrigger {
    private List<Invoice__c> invoiceList = new List<Invoice__c>();
    Private Invoice__c invRec;
    public InvoiceHandler() {}
    
    public void bulkBefore() {
    }
    public void bulkAfter() {
        system.debug('Entering Invoice bulkAfter With Trigger.New');
        if(Trigger.IsInsert||Trigger.IsUpdate){
            for(Sobject invTemp : trigger.new){ 
                invRec = (Invoice__c)invTemp; 
                invoiceList.add(invRec);
            }
        }
        system.debug('Exiting Invoice bulkAfter With Trigger.New');
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
        system.debug('Entering andFinally from InvoiceHandler');
        if(Trigger.IsAfter) {
            if (invoiceList.size() > 0){
                InvoiceService.createSharingforInvoice(invoiceList);
            }
        } 
        system.debug('Exiting andFinally from InvoiceHandler');
    }               
}