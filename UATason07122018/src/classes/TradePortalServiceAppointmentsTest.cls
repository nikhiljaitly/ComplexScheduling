/* =====================================================================================
Type:       Test class
Purpose:    Test cases for TradePortalServiceAppointments
========================================================================================*/
@isTest
private class TradePortalServiceAppointmentsTest{
    @isTest 
    static void testTradePortalServiceAppointments(){
        test.startTest();
        FSL_TestDataFactory.createFSLUser();
        
        test.stopTest();
        
        User u = [SELECT Id, FirstName, LastName
                  FROM User 
                  WHERE LastName = 'Cunningham'];
        
        ServiceResource testResource = FSL_TestDataFactory.createNewServiceResource(u.Id);
        
        //Operating Hours
        OperatingHours testOPHours = FSL_TestDataFactory.createOperatingHours('FSL_Base');
        //system.debug('FSL_Base: ' + testOPHours);
        
        //setup service territory
        ServiceTerritory testTerritory = FSL_TestDataFactory.createServiceTerritory('FSL_Base_Territory', testOPHours.Id, '303 Collins St', 'Melbourne',
                                                                                    'VIC', '3000','Australia');
        
        //setup service territory memeber
        ServiceTerritoryMember newSTM = FSL_TestDataFactory.createServiceTerritoryMember(testResource.Id, testTerritory.Id, testOPHours.Id);
        //System.debug('Service Territory Memeber: ' + newSTM);
        
        //create Work Type        
        WorkType WT = FSL_TestDataFactory.createWorkType('Repair Items', 'ELECTRICIAN');
        
        
        case ConfirmationTestCase = FSL_TestDataFactory.createClaim();
        
        
        workOrder wO = FSL_TestDataFactory.createWorkOrderWithCase('Home Repair Trades', ConfirmationTestCase.Id, WT.Id, testTerritory.Id,'300 Bourke Street', 'Melbourne', 'VIC', '3000', 'Australia');
        
        ServiceAppointment testServApp = FSL_TestDataFactory.createNewServiceAppointment(wO.Id, 'New');
        ServiceAppointment testServApp2 = FSL_TestDataFactory.createNewServiceAppointment(wO.Id, 'New');
        
        DateTime testTime = DateTime.now()+1;
        
        Long testLongTime = testTime.getTime();
        
        //call API
        system.debug('********status transistions: ' + FSL.GlobalAPIS.GetAllStatusTransitions());
        
        FSL.GlobalAPIS.addStatusTransition('New', 'Tentative');
        FSL.GlobalAPIS.addStatusTransition('New', 'Confirmed');
        FSL.GlobalAPIS.addStatusTransition('Tentative', 'Confirmed');
        FSL.GlobalAPIS.addStatusTransition('New', 'Awaiting Confirmation');
        //schedule appointments
        NJ_ServiceAppointmentManagerController.srvScheduleResponseWrapper testScheduleAppt = NJ_ServiceAppointmentManagerController.scheduleAppointmentForCandidate(testServApp.Id, testResource.Id, testLongTime);
        NJ_ServiceAppointmentManagerController.srvScheduleResponseWrapper testScheduleAppt2 = NJ_ServiceAppointmentManagerController.scheduleAppointmentForCandidate(testServApp2.Id, testResource.Id, testLongTime);
        
        system.debug('testScheduleAppt: ' + testScheduleAppt);
        system.debug('testScheduleAppt2: ' + testScheduleAppt2);
        
        TradePortalServiceAppointments.getServiceAppointments(wo.Id);
        TradePortalServiceAppointments.getAllServiceAppointments(wo.Id);        
        
    }   
}