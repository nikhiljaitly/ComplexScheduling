/************************************************************************************************************
Name: InvoiceHandler
=============================================================================================================
Purpose: Class for AP Invoice Trigger as Handler.
===============================================================================================================
History
-----------
VERSION    AUTHOR           DATE             DETAIL    DESCRIPTION
1.0        Vasu         20/09/2018        Created       Home Repair Claim System  
*************************************************************************************************************/
public with sharing class APInvoiceHandler implements ITrigger {
  
    private List<AP_Invoice__c> invoiceList = new List<AP_Invoice__c>();
    Private AP_Invoice__c invRec;
    public APInvoiceHandler() {}
    public class myException extends Exception {}
    
    public void bulkBefore() {
    }
    public void bulkAfter() {
        system.debug('Entering AP Invoice bulkAfter With Trigger.New');
        if(Trigger.IsInsert||Trigger.IsUpdate){
            for(Sobject invTemp : trigger.new){ 
                invRec = (AP_Invoice__c)invTemp; 
                invoiceList.add(invRec);
            }
        }
        system.debug('Exiting AP Invoice bulkAfter With Trigger.New');
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
       try{  
        system.debug('Entering andFinally from InvoiceHandler');
        if(Trigger.IsAfter) {
            if (invoiceList.size() > 0){
                //Map<ID,String> invoiceRecord = new Map<ID,String>();
                APInvoiceService.generateLabourDistributionSet(invoiceList);
            }
        } 
        
        system.debug('Exiting andFinally from InvoiceHandler');
        throw new myException('Distribution Sets cannot be generated - Trigger');
    }
        catch(exception e){
            //return;
           throw new myException('Distribution Sets cannot be generated - Trigger', e);
        }       
  }
}