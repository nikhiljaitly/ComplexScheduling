/* =====================================================================================
Type:       Test class
Purpose:    Test cases for homeRepairCMFeeInvoiceCreationService
========================================================================================*/
@isTest(SeeAllData=true)
private class homeRepairCMFeeInvCreationSrvcTest{
      @isTest public static void testSetup(){
        Policy__c po=HomeRepairTestDataFactory.createPolicy();
        system.debug(po.id);
        string accId;
        List<Account> acc=HomeRepairTestDataFactory.createRCTIAccounts('Testacc');
        Contact con=HomeRepairTestDataFactory.createContact('Testcon');
        Case cs=HomeRepairTestDataFactory.createCaseWithOriginAndPolicy(po.id,con.Id);
        WorkType wt=HomeRepairTestDataFactory.createWorkType('Repair Items','Painter');
        Claim_Job__c cj=HomeRepairTestDataFactory.createClaimJob(cs.Id);
        WorkOrder wo=HomeRepairTestDataFactory.createWorkOrderWithCaseAR('Home Repair Trades',cs.id,wt.id,cj.id,acc[0].Id);
          
         Map<Id,String> claimjobMap = new Map<Id,String>();
         claimjobMap.put(cj.Id, 'Submitted');
         
          List<WorkOrderLineItem> woliList=new List<WorkOrderLineItem>();
          WorkOrderLineItem woli = new WorkOrderLineItem();
          woli.workOrderId = wo.Id;
          woli.description = 'abcd';
          woli.workTypeId = wt.Id;
          woliList.add(woli);
          woli = new WorkOrderLineItem();
          woli.workOrderId = wo.Id;
          woli.description = 'cdba';         
          woliList.add(woli);
          insert woliList;

          test.startTest();
          hrCMFeeInvoiceCreationService.createInvoiceRecord(claimJobMap);    
          test.stopTest();

    }
    
   
}