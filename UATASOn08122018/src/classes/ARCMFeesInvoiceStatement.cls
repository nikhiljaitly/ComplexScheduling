/***************************************************************** 
Purpose: Retreives Invoice and Created ContentVersion Record                                                      
--------                                                            
VERSION        AUTHOR         DATE           DETAIL       Description 
1.0            Vasu          02/08/2018      Created      Home Repair Claim System  
*******************************************************************/   
Global class ARCMFeesInvoiceStatement{
    /***************************************************************** 
    Purpose: ARCMFeesInvoiceStatement method to fetch Invoice from Process Builder
    Parameters: invoices(Invoice)
    Returns: none
    Throws [Exceptions]: none                                                        
    History                                                             
    --------                                                            
    VERSION        AUTHOR         DATE           DETAIL   Description 
    1.0            Vasu          02/08/2018     Created  Home Repair Claim system 
    *******************************************************************/
    @InvocableMethod
    public static void ARCMFeesInvoiceStatement(List<String> invoices) {
        generateARCMFeesInvoice(Invoices);
    }
    /***************************************************************** 
    Purpose: generateARCMFeesInvoice method to fetch Invoice for generate ContentVersion Record and Update Invoice Generate_Invoice_Statement__c field
    Parameters: invoices(Invoice)
    Returns: none
    Throws [Exceptions]: none                                                        
    History                                                             
    --------                                                            
    VERSION        AUTHOR         DATE           DETAIL   Description 
    1.0            Vasu          02/08/2018     Created  Home Repair Claim system 
    *******************************************************************/
    
    @future(callout=true)
    public static void generateARCMFeesInvoice(List<String> invoices){
        List<AR_Invoice__c> invoiceList=[Select id,Name,Invoice_Type__c,Generate_Invoice_Statement__c 
                                      from AR_Invoice__c where id IN : invoices];
        List<Attachment> attList=new List<Attachment>();
        for(AR_Invoice__c inv: invoiceList){
            PageReference pdfPage = new PageReference('/apex/ARCMFeesInvoiceStatement');
            pdfPage.getParameters().put('id',invoices[0]);
            
            Blob pdf;   
            if(!Test.isRunningTest()){
                pdf = pdfPage.getContentAsPdf();
            }else{
                pdf = Blob.valueOf('Test Data');
            }
            //Insert Content Version to the invoice  
            if (inv.Invoice_Type__c == 'CM Fees') {
                HomeRepairUtil.uploadContentFile('CM-Fees-'+inv.Name+'-'+system.now()+'.pdf',
                                                 EncodingUtil.base64Encode(pdf),'CM-Fees-'+inv.Name+'-'+system.now()+'.pdf',String.valueOf(inv.Id),
                                                 '',
                                                 false,
                                                 false,'');
            }else{
                HomeRepairUtil.uploadContentFile('AR-Invoice-'+inv.Name+'-'+system.now()+'.pdf',
                                                 EncodingUtil.base64Encode(pdf),'AR-Invoice-'+inv.Name+'-'+system.now()+'.pdf',String.valueOf(inv.Id),
                                                 '',
                                                 false,
                                                 false,'');
            }
            
            inv.Generate_Invoice_Statement__c=false;        
        }
        update invoiceList;
        return;
    }
}