@isTest
public class BatchWorkCompleteNoInvoiceAlertTest {
   static testmethod void batchWorkCompleteNoInvoiceAlert(){
        Policy__c po=HomeRepairTestDataFactory.createPolicy();
        Contact con=HomeRepairTestDataFactory.createContact('Test');
        Case cs=HomeRepairTestDataFactory.createCaseWithOriginAndPolicy(po.id,con.Id);
        WorkType wt=HomeRepairTestDataFactory.createWorkType('Repair Items','Test');   
        Claim_Job__c cj=HomeRepairTestDataFactory.createClaimJob(cs.Id);
        WorkOrder wo=HomeRepairTestDataFactory.createWorkOrderWithCase('Home Repair Trades',cs.id,wt.id,cj.id); 
        system.debug(wo);
        con.Email = 'dsd@gmail.com';
        Account tradeAccount = HomeRepairTestDataFactory.createTradeAccount();
        wo.Service_Resource_Company__c =  tradeAccount.Id;
        wo.work_Completed_Date__c = date.today().adddays(-10);
        wo.status = 'Job Complete';
        update wo;
        system.debug(wo);       
        Task tsk = new task(whatId = wo.Id,subject = 'invoice work order 123456');
        insert tsk;
        system.debug('hello');
        Test.startTest();
        BatchWorkCompleteNoInvoceAlert obj = new BatchWorkCompleteNoInvoceAlert();
        DataBase.executeBatch(obj);
        Test.stopTest();
        
    }
     
}