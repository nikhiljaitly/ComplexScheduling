/***************************************************************** 
Purpose: Test class for TradePortalServiceAppointments 
History                                                             
--------                                                            
VERSION        AUTHOR         DATE           DETAIL       Description 
1.0            Vasu          07/30/2018      Created      Home Repair Claim System  
*******************************************************************/
@istest 
public class TradePortalServiceAppointmentsTest {    
    static testmethod void test_ServiceAppointments() {
        Policy__c po=HomeRepairTestDataFactory.createPolicy();
        system.debug(po.id);
        Case cs=HomeRepairTestDataFactory.createCaseWithOriginAndPolicy(po.id);   
        WorkType wt=HomeRepairTestDataFactory.createWorkType('Repair Items','Test');   
        WorkOrder wo=HomeRepairTestDataFactory.createWorkOrderWithCase('Home Repair Trades',cs.id,wt.id);
        TradePortalServiceAppointments.getServiceAppointments(wo.id);
        HomeRepairTestDataFactory.createAllServiceAppointments(cs.id,wt.id);
        TradePortalServiceAppointments.getAllServiceAppointments(wo.id);               
    }
}