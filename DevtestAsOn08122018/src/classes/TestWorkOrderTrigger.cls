/* =====================================================================================
Type:       Test class
Purpose:    Test cases for WorkOrderTigger
========================================================================================*/
@isTest
private class TestWorkOrderTrigger{
    @testSetup
    public static void testSetup(){
        Home_Repairs_Trigger_Switch__c hr=new Home_Repairs_Trigger_Switch__c();
        hr.Name='WorkOrder Trigger';
        hr.Trigger_On_WorkOrder__c=true;
        insert hr;
        Policy__c po=HomeRepairTestDataFactory.createPolicy();
        system.debug(po.id);
        Contact con=HomeRepairTestDataFactory.createContact('Test');
        Case cs=HomeRepairTestDataFactory.createCaseWithOriginAndPolicy(po.id,con.Id);
        WorkType wt=HomeRepairTestDataFactory.createWorkType('Repair Items','Test');   
        WorkOrder wo=HomeRepairTestDataFactory.createWorkOrderWithCase('Home Repair Trades',cs.id,wt.id);
        List<WorkOrderLineItem> woliList=HomeRepairTestDataFactory.createWorkOrderLineItem('Home Repair Trades',cs.id,wt.Id,wo.Id,1);
        woliList=HomeRepairTestDataFactory.createWorkOrderLineItem('Home Repair Trades',cs.id,wt.Id,wo.Id,2);
    }
    static testMethod void createServiceAppointmentTest() {
        List<WorkOrder> woList= new List<WorkOrder>();
        for(WorkOrder wo : [Select id from WorkOrder]){
            woList.add(wo);
        }
        update woList; 
        system.debug([Select id from ServiceAppointment]);
        system.debug('uuuu'+[Select id ,Site_Visit_Number__c from WorkOrderLineItem]);
        List<WorkOrderLineItem> woliList=[Select id ,Site_Visit_Number__c from WorkOrderLineItem where Site_Visit_Number__c=2 limit 1];
        woliList[0].Site_Visit_Number__c=3;
        update woliList;
        woList.clear();
        for(WorkOrder wo : [Select id,Variation_Type__c from WorkOrder]){
            wo.Variation_Type__c='Labour';
            woList.add(wo);
        }
        update woList; 
        system.debug('wwww'+[Select id,(Select id from ServiceAppointments),(Select Id,Site_Visit_Number__c,Service_Appointment__c
                                      from WorkOrderLineItems) from WorkOrder]); 
    }
}