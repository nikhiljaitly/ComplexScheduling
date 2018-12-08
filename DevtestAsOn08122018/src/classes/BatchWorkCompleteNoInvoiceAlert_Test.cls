@isTest
public class BatchWorkCompleteNoInvoiceAlert_Test {
    @testSetup
    public static void testSetup(){
        Policy__c po=HomeRepairTestDataFactory.createPolicy();
        Contact con=HomeRepairTestDataFactory.createContact('Test');
        Case cs=HomeRepairTestDataFactory.createCaseWithOriginAndPolicy(po.id,con.Id);
        WorkType wt=HomeRepairTestDataFactory.createWorkType('Repair Items','Test');   
        WorkOrder wo=HomeRepairTestDataFactory.createWorkOrderWithCase('Home Repair Trades',cs.id,wt.id);
        system.debug(wo);
        con.Email = 'dsd@gmail.com';
        wo.work_Completed_Date__c = date.today().adddays(10);
        wo.status = 'Job Complete';
        update wo;
        system.debug(wo);
        
        Task tsk = new task(subject = 'invoice work order 123456');
        insert tsk;
        system.debug('hello');
    
    }
    static testMethod void createServiceAppointmentTest() {
        Test.startTest();
            BatchWorkCompleteNoInvoceAlert obj = new BatchWorkCompleteNoInvoceAlert();
            DataBase.executeBatch(obj);
        Test.stopTest();
    }
    
}