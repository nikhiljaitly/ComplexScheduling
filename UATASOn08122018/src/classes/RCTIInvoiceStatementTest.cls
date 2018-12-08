/* =====================================================================================
Type:       Test class
Purpose:    Test cases for RCTIInvoiceStatement
========================================================================================*/
@isTest
private class RCTIInvoiceStatementTest{
    @testSetup
    public static void testSetup(){
        Policy__c po=HomeRepairTestDataFactory.createPolicy();
        system.debug(po.id);
        Contact con=HomeRepairTestDataFactory.createContact('Test');
        Case cs=HomeRepairTestDataFactory.createCaseWithOriginAndPolicy(po.id,con.Id);
        WorkType wt=HomeRepairTestDataFactory.createWorkType('Repair Items','Test');   
        Claim_Job__c cj=HomeRepairTestDataFactory.createClaimJob(cs.Id);
        WorkOrder wo=HomeRepairTestDataFactory.createWorkOrderWithCase('Home Repair Trades',cs.id,wt.id,cj.id);
        AP_Invoice__c invoice = HomeRepairTestDataFactory.createAPInvoiceWithWorkOrder(wo.id);
    }
    static testMethod void insertInvoiceTest() {
        List<String> invoices = new List<String>();
        for(AP_Invoice__c invoice : [Select id,Name,Generate_Invoice_Statement__c from AP_Invoice__c]){
            invoices.add(invoice.id);
        }
        RCTIInvoiceStatement.RCTIInvoiceStatement(invoices);        
    }
}