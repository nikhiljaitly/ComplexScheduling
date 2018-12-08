@isTest
public class NJ_ClaimPlannerControllerTest {
    @isTest static void initClaimPlannerTest(){
        //test data setup
        Case testCase = FSL_TestDataFactory.createClaim();
        
        workOrder testWO = FSL_TestDataFactory.HRTradeWorkOrderWithCase(testCase.Id);
        
        ServiceAppointment testServ = FSL_TestDataFactory.createNewServiceAppointment(testWO.Id, 'Tentative', testCase.Id);
        ServiceAppointment testServ2 = FSL_TestDataFactory.createNewServiceAppointment(testWO.Id, 'Tentative', testCase.Id);
        //run test
        test.startTest();
        
        NJ_ClaimPlannerController.ClaimPlannerInitInfo testRun = NJ_ClaimPlannerController.initClaimPlanner(testCase.Id);
        
        test.stopTest();
        system.debug('testRun: '  + testRun);
        
        system.assertEquals(TRUE, testRun.hasWorkOrder);
    }
    @isTest static void initClaimPlannerNegativeTest(){
        //test data setup
        Case testCase = FSL_TestDataFactory.createClaim();
        
        //run test
        test.startTest();
        
        NJ_ClaimPlannerController.ClaimPlannerInitInfo testRun = NJ_ClaimPlannerController.initClaimPlanner(testCase.Id);
        
        test.stopTest();
        system.debug('testRun: '  + testRun);
        
        system.assertEquals(FALSE, testRun.hasWorkOrder);
    }
    
    @isTest static void NJ_SelectOptionLightningTest() {
        
        NJ_SelectOptionLightning x = new NJ_SelectOptionLightning('string1');
        system.assertEquals('string1', x.label);
        
        NJ_SelectOptionLightning zx = new NJ_SelectOptionLightning('ten', 'string1');
        system.assertEquals('ten', zx.value);
        
        NJ_SelectOptionLightning xx = new NJ_SelectOptionLightning('ten', 'string1', 'green');
        system.assertEquals('green', xx.colorCode);
        
        NJ_SelectOptionLightning xy = new NJ_SelectOptionLightning('ten', 'string1', 'green', 'newIcon');
        system.assertEquals('newIcon', xy.iconName);
        
        NJ_SelectOptionLightning yy = new NJ_SelectOptionLightning('ten', 'string1', TRUE);
        system.assertEquals(TRUE, yy.disabled);
        
        NJ_SelectOptionLightning z = new NJ_SelectOptionLightning('ten', 'string1', TRUE, FALSE);
        system.assertEquals(FALSE, z.selected);
    }
}