/* =====================================================================================
Type:       Test class
Purpose:    Test cases for ARCMFeesInvoiceStatement
========================================================================================*/
@isTest
private class TestARCMFeesInvoiceStatement{
    @testSetup
    public static void testSetup(){
        Policy__c po=HomeRepairTestDataFactory.createPolicy();
        system.debug(po.id);
        Contact con=HomeRepairTestDataFactory.createContact('Test');
        Case cs=HomeRepairTestDataFactory.createCaseWithOriginAndPolicy(po.id,con.Id);
        WorkType wt=HomeRepairTestDataFactory.createWorkType('Repair Items','Test');   
        WorkOrder wo=HomeRepairTestDataFactory.createWorkOrderWithCase('Home Repair Trades',cs.id,wt.id);
        Claim_Job__c cj=HomeRepairTestDataFactory.createClaimJob(cs.Id);
        AR_Invoice__c invoice = HomeRepairTestDataFactory.createARInvoice(cj.id);
    }
    static testMethod void ARCMFeesInvoiceStatementTest() {
        List<String> invoices = new List<String>();
        for(AR_Invoice__c invoice : [Select id,Name,Generate_Invoice_Statement__c from AR_Invoice__c]){
            invoices.add(invoice.id);
        }
        ARCMFeesInvoiceStatement.ARCMFeesInvoiceStatement(invoices);        
    }
}