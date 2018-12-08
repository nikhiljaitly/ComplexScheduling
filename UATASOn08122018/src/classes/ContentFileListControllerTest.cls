/* =====================================================================================
Type:       Test class
Purpose:    Test cases for ContentFileListController
========================================================================================*/
@isTest
private class ContentFileListControllerTest{
    @testSetup 
    static void setup(){
        //Create the Policy Record.
        Policy__c po=HomeRepairTestDataFactory.createPolicy();
        system.debug(po.id);
        //Create the Contact Record.
        Contact con=HomeRepairTestDataFactory.createContact('ClaimTest');
        //Create the Case Record.
        Case cs=HomeRepairTestDataFactory.createCaseWithOriginAndPolicy(po.id,con.Id);                
        HomeRepairTestDataFactory.addContentVersionToParent(cs.id);      
        WorkType wt=HomeRepairTestDataFactory.createWorkType('Repair Items','Assessment');
        Claim_Job__c cj=HomeRepairTestDataFactory.createClaimJob(cs.Id);
        WorkOrder wo=HomeRepairTestDataFactory.createWorkOrderWithCase('Home Repair Trades',cs.id,wt.id,cj.id);
        AR_Invoice__c ai=HomeRepairTestDataFactory.createARInvoice(cj.Id);
        //ai.Work_Order__c=wo.Id;
        update ai;
        
    }   
    static testMethod void ContentFileListControllerAllTest() {
        WorkOrder wo=[SELECT id FROM WorkOrder LIMIT 1];
        ContentFileListController.fetchContentDocument(wo.Id);
        ContentFileListController.fetchWorkOrderContentDocument(wo.Id);
        ContentFileListController.fetchClaimContentDocument(wo.Id);
        ContentFileListController.fetchParentId(wo.Id,'CaseId');
        
    }
    
}