/***************************************************************** 
Purpose: Retreives Invoice and Created ContentVersion Record                                                      
--------                                                            
VERSION        AUTHOR         DATE           DETAIL       Description 
1.0            Vasu          02/08/2018      Created      Home Repair Claim System  
*******************************************************************/   
Public Class RCTIInvoiceStatement{
    /***************************************************************** 
    Purpose: RCTIInvoiceStatement method to fetch Invoice from Process Builder
    Parameters: invoices(Invoice)
    Returns: none
    Throws [Exceptions]: none                                                        
    History                                                             
    --------                                                            
    VERSION        AUTHOR         DATE           DETAIL   Description 
    1.0            Vasu          02/08/2018     Created  Home Repair Claim system 
    *******************************************************************/
    @InvocableMethod 
    public static void RCTIInvoiceStatement(List<String> invoices) {
        InsertRCTIInvoice(Invoices);
    }
    /***************************************************************** 
    Purpose: InsertRCTIInvoicemethod to fetch Invoice for generate ContentVersion Record and Update Invoice Generate_Invoice_Statement__c field
    Parameters: invoices(Invoice)
    Returns: none
    Throws [Exceptions]: none                                                        
    History                                                             
    --------                                                            
    VERSION        AUTHOR         DATE           DETAIL   Description 
    1.0            Vasu          02/08/2018     Created  Home Repair Claim system 
    *******************************************************************/
    @future(callout=true)
    public static void InsertRCTIInvoice(List<String> invoices) {
        List<AP_Invoice__c> invoiceList=[Select id,Name,Generate_Invoice_Statement__c from AP_Invoice__c where id IN : invoices];
        List<Attachment> attList=new List<Attachment>();
        for(AP_Invoice__c inv: invoiceList){
            PageReference pdfPage = new PageReference('/apex/RCTIInvoiceStatement');
            pdfPage.getParameters().put('id',invoices[0]);
            Blob pdf;   
            if(!Test.isRunningTest()){
                pdf = pdfPage.getContentAsPdf();
            }else{
                pdf = Blob.valueOf('Test Data');
            }
            //Insert Content Version to the invoice       
            HomeRepairUtil.uploadContentFile('RCTI-Invoice-'+inv.Name+'-'+system.now()+'.pdf',EncodingUtil.base64Encode(pdf),'RCTI-Invoice-'+inv.Name+'-'+system.now()+'.pdf',String.valueOf(inv.Id),'',false,false,'');
            inv.Generate_Invoice_Statement__c=false;
                    
        }
        update invoiceList;
        return;
    }
    
}