@isTest
public class NJ_ClaimAppointmentsControllerTest {
    
    @isTest public static void getClaimServiceDataTest(){
        
        case getClaimDataTestCase = FSL_TestDataFactory.createClaim();
        
        WorkOrder wo = FSL_TestDataFactory.HRTradeWorkOrderWithCase(getClaimDataTestCase.Id);
        
        ServiceAppointment testServApp = FSL_TestDataFactory.createNewServiceAppointment(wo.Id, 'New');
      //  testServApp.ParentRecordId = wo.Id;
            
        test.starttest();
        NJ_ClaimAppointmentsController.getClaimServiceData(getClaimDataTestCase.id);
        test.stopTest();
        
    }
}