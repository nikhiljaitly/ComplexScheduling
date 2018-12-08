/* =====================================================================================
Type:       Test class
Purpose:    Test cases for UpdateClaimWithFirstJobDetails (For Process Bulider)
========================================================================================*/
@isTest
private class UpdateClaimWithFirstJobDetailsTest{
    static testMethod void UpdateClaimWithFirstJobDetailsTest() {
        List<String> ids=new List<String>();
       //Create the Policy Record.
        Policy__c po=HomeRepairTestDataFactory.createPolicy();
        //Create the Contact Record.
        Contact con=HomeRepairTestDataFactory.createContact('ClaimTest');
        //Create the Case Record.
        Case cs=HomeRepairTestDataFactory.createCaseWithOriginAndPolicy(po.id,con.Id);
        WorkType wt=HomeRepairTestDataFactory.createWorkType('Repair Items','Carpenter');
        Claim_Job__c cj=HomeRepairTestDataFactory.createClaimJob(cs.Id);
        WorkOrder wo=HomeRepairTestDataFactory.createWorkOrderWithCase('Home Repair Trades',cs.id,wt.id,cj.id);        
        List<WorkOrderLineItem> woliList=HomeRepairTestDataFactory.createWorkOrderLineItem('Home Repair',cs.id,wt.Id,wo.Id,1);
        ids.add(cs.id);
        UpdateClaimWithFirstJobDetails.UpdateClaimWithFirstJobDetails(ids);
    }
}