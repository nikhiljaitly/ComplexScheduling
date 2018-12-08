@isTest
public with sharing class HRGanttChildController_Test {
    
    /*@isTest public static void testCycleStatuses() {
        List<ServiceAppointmentStatus> v = [SELECT Id, ApiName, isDefault, MasterLabel, SortOrder, StatusCode
                                            FROM ServiceAppointmentStatus];
        
        system.debug('***statuses: ' + v);
        
        case x = FSL_TestDataFactory.createClaim();
        workOrder y = FSL_TestDataFactory.HRTradeWorkOrderWithCase(x.Id);
        
        ServiceAppointment z = FSL_TestDataFactory.createNewServiceAppointment(y.Id, 'New');
        
        system.debug('z: ' + z);
        
        z.Status = 'Tentative';
        try{
        	update z;
        }catch(exception e){
            system.debug('ERROR: ' + e.getMessage());
        }
    }*/
    
	@isTest public static void getTentativeAppointmentsTest() {
        case TentativeTestCase = FSL_TestDataFactory.createClaim();
        system.debug('***TNTtest:' + TentativeTestCase);
        
        workOrder TentativeTestWO = FSL_TestDataFactory.HRTradeWorkOrderWithCase(TentativeTestCase.Id);
        system.debug('BMwo: ' + TentativeTestWO.Id);
        //extra service appointment was being created in process hence deletion
        ServiceAppointment ex = [SELECT Id, Status
                                 FROM ServiceAppointment
                                 WHERE ParentRecordId = :TentativeTestWO.Id];
        
        system.debug('ex: '  + ex);
        delete ex;
        
        
        ServiceAppointment testServApp = FSL_TestDataFactory.createNewServiceAppointment(TentativeTestWO.Id, 'Tentative', TentativeTestCase.Id);
        ServiceAppointment testServApp2 = FSL_TestDataFactory.createNewServiceAppointment(TentativeTestWO.Id, 'Tentative', TentativeTestCase.Id);
        system.debug('***TNTserv: ' + testServApp.ParentRecordId);
        system.debug('***TNTserv2: ' + testServApp2.Claim__c);
        
        
        
        test.starttest();
        List<HRGanttChildController.ServiceAppintmentWrap> tentativeAppts = HRGanttChildController.getTentativeAppointments(TentativeTestCase.id);
        system.debug('tentativeAppts: ' + tentativeAppts);
        test.stopTest();
        system.assertEquals(2, tentativeAppts.size());
        
	}
    @isTest public static void getConfirmedAppointmentsTest(){
        case ConfirmedTestCase = FSL_TestDataFactory.createClaim();
        
        workOrder ConfirmedTestWO = FSL_TestDataFactory.HRTradeWorkOrderWithCase(ConfirmedTestCase.Id);
        
        test.startTest();
        FSL_TestDataFactory.createFSLUser();
        
        test.stopTest();
        
        User u = [SELECT Id, FirstName, LastName
                  FROM User 
                  WHERE LastName = 'Cunningham'];
        
        ServiceResource testResource = FSL_TestDataFactory.createNewServiceResource(u.Id);
        system.debug('testResource: ' + testResource);
        
        ServiceAppointment testServApp = FSL_TestDataFactory.createNewServiceAppointment(ConfirmedTestWO.Id, 
                                                                                         'Confirmed', 
                                                                                         ConfirmedTestCase.Id,
                                                                                         testResource.Id);
        
        ServiceAppointment testServApp2 = FSL_TestDataFactory.createNewServiceAppointment(ConfirmedTestWO.Id, 
                                                                                          'Awaiting Confirmation', 
                                                                                          ConfirmedTestCase.Id,
                                                                                          testResource.Id);
        List<ServiceAppointment> srvAppts = [SELECT Id, status, Claim__c, Service_Resource__c
                                             FROM ServiceAppointment
                                             WHERE Claim__c = :ConfirmedTestCase.Id];
        system.debug('ConfirmedTestCase: ' + ConfirmedTestCase.Id);
        system.debug('testResource: ' + testResource.Id);
        system.debug('srvAppts: ' + srvAppts);
        
        
        List<HRGanttChildController.ServiceAppintmentWrap> testAppts = HRGanttChildController.getConfirmedAppointments(ConfirmedTestCase.id);
        
        system.assertEquals(2, testAppts.size());
    }
    
    @isTest public static void confirmAppointmentsTest(){
        //FSL Data
        /*List<ServiceAppointmentStatus> x = [SELECT Id, ApiName, isDefault, MasterLabel, SortOrder, StatusCode
                                            FROM ServiceAppointmentStatus];
        
        system.debug('***statuses: ' + x);*/
        
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
        
        
        workOrder ConfirmationTestWO = FSL_TestDataFactory.createWorkOrderWithCase('Home Repair Trades', ConfirmationTestCase.Id, WT.Id, testTerritory.Id,'300 Bourke Street', 'Melbourne', 'VIC', '3000', 'Australia');
        //system.debug('ConfirmationTestWO: ' + ConfirmationTestWO);
        
        ServiceAppointment testServApp = FSL_TestDataFactory.createNewServiceAppointment(ConfirmationTestWO.Id, 'New');
        ServiceAppointment testServApp2 = FSL_TestDataFactory.createNewServiceAppointment(ConfirmationTestWO.Id, 'New');
        
        
        List<Id> testAppIds = new List<Id>();
        testAppIds.add(testServApp.Id);
        testAppIds.add(testServApp2.Id);
        
        DateTime testTime = DateTime.now()+1;
        //system.debug('testTime: ' + testTime);
        
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
        
        List<ServiceAppointment> ScheduledAppts = [SELECT Id
                                   				   FROM ServiceAppointment
                                   				   WHERE ParentRecordId = :ConfirmationTestWO.Id];
        
        List<AssignedResource> AssingRes = [SELECT Id
                                            FROM AssignedResource
                                            WHERE ServiceAppointmentId = :testServApp.Id];
        
        system.debug('SchedAppts: ' + ScheduledAppts);
        system.debug('AssinRes: ' + AssingRes);
        
        
        HRGanttChildController.confirmAppointments(testAppIds);
        
        List<ServiceAppointment> testAppts = [SELECT Id, Status
                                              FROM ServiceAppointment
                                              WHERE Id IN :testAppIds /*AND Status = 'Confirmed'*/];
        
        system.debug('testAppts: ' + testAppts);
        //system.assertEquals(2, testAppts.size());
        
    }
    
    @isTest public static void unScheduleAppointmentsTest(){
        
        case unScheduleTestCase = FSL_TestDataFactory.createClaim();
        
        workOrder unScheduleTestWO = FSL_TestDataFactory.HRTradeWorkOrderWithCase(unScheduleTestCase.Id);
        
        ServiceAppointment testServApp = FSL_TestDataFactory.createNewServiceAppointment(unScheduleTestWO.Id, 'New');
        System.debug('testServApp:'+testServApp);
        
        List<Id> testAppIds = new List<Id>();
        testAppIds.add(testServApp.Id);
        
        test.startTest();
        HRGanttChildController.unScheduleAppointments(testAppIds);
        test.stopTest();
    }
    
    @isTest public static void getClaimScheduledAppointmentsTest(){
        case getScheduledTestCase = FSL_TestDataFactory.createClaim();
        
        workOrder getScheduledTestWO = FSL_TestDataFactory.HRTradeWorkOrderWithCase(getScheduledTestCase.Id);
        
        ServiceAppointment testServApp = FSL_TestDataFactory.createNewServiceAppointment(getScheduledTestWO.Id, 'Tentative');       
        
        test.startTest();
        HRGanttChildController.getClaimScheduledAppointments(getScheduledTestCase.id);
        test.stopTest();
    }
}