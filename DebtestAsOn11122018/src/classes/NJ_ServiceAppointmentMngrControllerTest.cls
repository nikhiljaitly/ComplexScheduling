@isTest
public class NJ_ServiceAppointmentMngrControllerTest{
    
    /*@isTest static void testDataCreation(){
        ServiceResource newSR = FSL_TestDataFactory.createNewServiceResource();
        system.debug('newSR: ' + newSR);
        
        OperatingHours OP = FSL_TestDataFactory.createOperatingHours('name');
        
        system.debug('OP: ' + OP);
        
        TimeSlot TTS = FSL_TestDataFactory.createTimeSlot('Thursday', 7, 17, 'Normal', OP.Id);
        TimeSlot WTS = FSL_TestDataFactory.createTimeSlot('Wednesday', 7, 17, 'Normal', OP.Id);
        TimeSlot FTS = FSL_TestDataFactory.createTimeSlot('Friday', 7, 17, 'Normal', OP.Id);
        
        system.debug('TTS: ' + TTS);
        system.debug('WTS: ' + WTS);
        system.debug('FTS: ' + FTS);
        
        ServiceTerritory ST = FSL_TestDataFactory.createServiceTerritory('name', OP.Id, '303 Collins St', 'Melbourne',
                                                                        'VIC', '3000','Australia');
        
        system.debug('ST: ' + ST);
        
        
        
        ServiceTerritoryMember newSTM = FSL_TestDataFactory.createServiceTerritoryMember(newSR.Id, ST.Id, OP.Id);
        system.debug('newSTM: ' + newSTM);
        
        Skill S = FSL_TestDataFactory.findSkill('ELECTRICIAN');
        system.debug('s: ' + s);
        
        ServiceResourceSkill srK = FSL_TestDataFactory.createSRSkill(newSR.Id, S.Id);
        system.debug('srk: ' + srk);
        
        WorkType WT = FSL_TestDataFactory.createWorkType('Repair Items', 'ELECTRICIAN');
        system.debug('WT: ' + WT);
        
        SkillRequirement skReq = FSL_TestDataFactory.createSkillReq(WT.Id, s.Id);
        system.debug('skReq: ' + skReq);
        
        
        FSL_TestDataFactory.assignFSLPermissionSets(newSR.RelatedRecordId);
        
        
        
    }*/
    
    @isTest public static void getSADetailsTest(){
        case getDetailsTestCS = FSL_TestDataFactory.createClaim();
        workOrder testWO = FSL_TestDataFactory.HRTradeWorkOrderWithCase(getDetailsTestCS.id);
        system.debug('testWO: ' + testWO);
        ServiceAppointment testServ = FSL_TestDataFactory.createNewServiceAppointment(testWo.Id , 'Tentative');
        
        
        test.startTest();
        NJ_ServiceAppointmentManagerController.srvAppointmentWrapper testWrap = NJ_ServiceAppointmentManagerController.getSADetails(testServ.Id);
        system.debug('testWrap: ' + testWrap);
        String woID = testWrap.workOrderId;
        system.debug('woID: ' + woID);
        
        system.assertEquals(testServ.ParentRecordId, woID);
        test.stopTest();
        
        
    }
    
    @isTest static void updateSADetailsTest(){
        case updateDetailsTestCS = FSL_TestDataFactory.createClaim();
        workOrder testWO = FSL_TestDataFactory.HRTradeWorkOrderWithCase(updateDetailsTestCS.id);
        system.debug('testWO: ' + testWO);
        ServiceAppointment testServ = FSL_TestDataFactory.createNewServiceAppointment(testWo.Id , 'Tentative');
        
        test.startTest();
        NJ_ServiceAppointmentManagerController.srvUpdateResponseWrapper testUpdate = 
            NJ_ServiceAppointmentManagerController.updateSADetails(testServ.Id, 
                                                               	   'testCase', 
                                                               	   DateTime.now(), 
                                                                   (DateTime.now()+5));
        
        string AssrtMessge = testUpdate.updateMessage;
        system.assertEquals('Appointment Successfully Updated', AssrtMessge);
        
        string AssrtStats = testUpdate.updateStatus;
        system.assertEquals('SUCCESS', AssrtStats);
        test.stopTest();
    }
    
    @isTest static void updateSADetailsNegativeTest(){
        case updateDetailsTestCS = FSL_TestDataFactory.createClaim();
        workOrder testWO = FSL_TestDataFactory.HRTradeWorkOrderWithCase(updateDetailsTestCS.id);
        system.debug('testWO Id: ' + testWO.Id);
        
        workOrderLineItem testLineItem = FSL_TestDataFactory.createWOLI(testWO.Id);
        system.debug('testLineItem Id: ' + testLineItem.Id);
        ServiceAppointment testServ = FSL_TestDataFactory.createNewServiceAppointment(testLineItem.Id , 'Tentative');
        
        system.debug('testServ parent: ' + testServ.ParentRecordId);
        
        test.startTest();
        try{
        NJ_ServiceAppointmentManagerController.srvUpdateResponseWrapper testUpdate = 
            NJ_ServiceAppointmentManagerController.updateSADetails(testServ.Id, 
                                                               	   'testCase', 
                                                               	   DateTime.now(), 
                                                                   (DateTime.now()-1));
        }catch(exception e){
            system.debug('Error: ' + e.getMessage());
        }
        /*string AssrtMessge = testUpdate.updateMessage;
        system.assertEquals('Appointment Successfully Updated', AssrtMessge);
        
        string AssrtStats = testUpdate.updateStatus;
        system.assertEquals('SUCCESS', AssrtStats);*/
        test.stopTest();
    }
    
    @isTest static void updateSADetailsNegativeTest1(){
        case updateDetailsTestCS = FSL_TestDataFactory.createClaim();
        workOrder testWO = FSL_TestDataFactory.HRTradeWorkOrderWithCase(updateDetailsTestCS.id);
        system.debug('testWO: ' + testWO);
        ServiceAppointment testServ = FSL_TestDataFactory.createNewServiceAppointment(testWo.Id , 'Tentative');
        
        test.startTest();
        //irrelevant hardcoded Id
        Id unfindable = '0015D00000OmKgBQAV';
        NJ_ServiceAppointmentManagerController.srvUpdateResponseWrapper testUpdate = 
            NJ_ServiceAppointmentManagerController.updateSADetails(unfindable, 
                                                               	   'testCase', 
                                                               	   DateTime.now(), 
                                                                   (DateTime.now()+5));
        
        string AssrtMessge = testUpdate.updateStatus;
        system.debug('AssrtMessge: ' + AssrtMessge);
        system.assertEquals('ERROR', AssrtMessge);
        
        string AssrtStats = testUpdate.updateMessage;
        system.debug('AssrtStats: ' + AssrtStats);
        system.assertEquals('Service Appointment ' + unfindable + ' NOT FOUND', AssrtStats);
        test.stopTest();
    }
    
    @isTest static void updateWorkOrderTest(){
        case testCS = FSL_TestDataFactory.createClaim();
        //system.debug('claim number: ' + testCS.CaseNumber);
        workOrder testWO = FSL_TestDataFactory.HRTradeWorkOrderWithCase(testCS.id);
        //system.debug('testWO claim__c: ' + testWO.Claim__c);
        //get case after insertion to get case number
        Case insertedTestCS = [SELECT Id, CaseNumber 
                               FROM Case
                               WHERE Id = :testCS.Id];
        system.debug('testCS after insert: ' + insertedTestCS);
        workOrder insertedTestWO = [SELECT Id, Claim__c
                                    FROM workOrder
                                    WHERE Id = :testWO.Id];
        system.debug('testWO after insert: ' + insertedTestWO);
        ServiceAppointment testServ = FSL_TestDataFactory.createNewServiceAppointment(testWo.Id , 'Tentative');
        
        test.startTest();
        //applyAll = true
        Boolean ExpectTrue = NJ_ServiceAppointmentManagerController.updateWorkOrder(testWo.Id, 
                                                                                    insertedTestCS.CaseNumber, 
                                                                                    'DEWITT', 
                                                                                    'descr', 
                                                                                    TRUE, 
                                                                                    testServ.Id, 
                                                                                    TRUE, 
                                                                                    DateTime.now(), 
                                                                                    (DateTime.now()+5));
        system.debug('ExpectTrue: ' + ExpectTrue);
        //applyALL = false
        Boolean ExpectTrue2 = NJ_ServiceAppointmentManagerController.updateWorkOrder(testWo.Id, 
                                                                                    insertedTestCS.CaseNumber, 
                                                                                    'DEWITT', 
                                                                                    'descr', 
                                                                                    FALSE, 
                                                                                    testServ.Id, 
                                                                                    TRUE, 
                                                                                    DateTime.now(), 
                                                                                    (DateTime.now()+5));
        
        test.stopTest();
        system.assertEquals(true, (ExpectTrue && ExpectTrue2));
    }
    @isTest 
    static void getSACandidatesTest(){
        //FSL Data
        //scheduling polcy
        FSL__Scheduling_Policy__c shedulePol = FSL_TestDataFactory.createShedulingPolicy('Customer First');
        //System.debug('Scheduling Policy: ' + shedulePol);
        
        //scheduling policy work rules
        FSL_TestDataFactory.createWorkRulesforPolicy(shedulePol.Id);
        /*List<FSL__Scheduling_Policy_Work_Rule__c> testWRList = [SELECT Id, Name, FSL__Scheduling_Policy__c,
                                                                FSL__Work_Rule__c
                                              FROM FSL__Scheduling_Policy_Work_Rule__c
                                              WHERE FSL__Scheduling_Policy__c = :shedulePol.Id];
        
        for (FSL__Scheduling_Policy_Work_Rule__c f0 : testWRList) {
            system.debug('Scheduling Policy Work Rule: ' + f0);
        }
        
        
        List<FSL__Work_Rule__c> wrList = [SELECT Id, Name, FSL__Active__c, FSL__Boolean_Operator__c,
                                                 FSL__Break_Duration__c, FSL__Break_Start__c,
                                                 FSL__Crew_Resources_Availability__c, 
                                          		 FSL__Description__c, FSL__Enable_Overtime__c,
                                          		 FSL__Evaluation_Order__c, FSL__Is_Fixed_Gap__c,
                                          	     FSL__Match_Skill_Level__c, FSL__Maximum_Travel_From_Home__c,
                                          	 	 FSL__Maximum_Travel_From_Home_Type__c, FSL__Minimum_Gap__c,
                                          		 FSL__Object_Group_Field__c, FSL__Pass_Empty_Values__c,
                                          		 FSL__Resource_Group_Field__c, FSL__Resource_Property__c,
                                          		 FSL__Service_Property__c, FSL__Service_Schedule_Time_Property__c,
                                          	  	 FSL__Service_Time_Operator__c, FSL__Service_Time_Property__c,
                                          		 FSL__Start_of_Day__c, FSL__Travel_From_Home__c,
                                          		 FSL__Travel_To_Home__c, FSL__Match_Constant_Boolean_Value__c,
                                          		 FSL__Working_Location_Enable_Primary__c, RecordTypeId
                                          FROM FSL__Work_Rule__c];
        for (FSL__Work_Rule__c f1 : wrList) {
        	System.Debug('System Work Rule: ' + f1);    
        }*/
        
        
        //scheduling policy objectives
        FSL_TestDataFactory.createSchedulingPolicyObjectives(shedulePol.Id);
        /*List<FSL__Scheduling_Policy_Goal__c> testServObjList = [SELECT Id, Name, FSL__weight__c,
                                                                FSL__Scheduling_Policy__c, FSL__Service_Goal__c
                                                                FROM FSL__Scheduling_Policy_Goal__c
                                                                WHERE FSL__Scheduling_Policy__c = :shedulePol.Id];
        for (FSL__Scheduling_Policy_Goal__c f2 : testServObjList) {
        	system.debug('Scheduling Policy Service Goal ' + f2);    
        }
        
        
        List<FSL__Service_Goal__c> srvPolList = [SELECT Id, Name, FSL__Ignore_Home_Base_Coordinates__c,
                                                 		FSL__Object_Group_Field__c, FSL__Prioritize_Resource__c,
                                                 		FSL__Resource_Priority_Field__c, FSL__Resource_Group_Field__c,
                                                 		RecordTypeId
                                      FROM FSL__Service_Goal__c];
        
        for (FSL__Service_Goal__c f3 : srvPolList) {
           System.Debug('System Service Goal: ' + f3); 
        }*/
        
            
        //operating hours
        OperatingHours OP = FSL_TestDataFactory.createOperatingHours('FSL_Base');
        //system.debug('FSL_Base: ' + OP);
        
        //Time Slots
        TimeSlot MTS = FSL_TestDataFactory.createTimeSlot('Monday', 7, 20, 'Normal', OP.Id);
        TimeSlot TueTS = FSL_TestDataFactory.createTimeSlot('Tuesday', 7, 20, 'Normal', OP.Id);
        TimeSlot WTS = FSL_TestDataFactory.createTimeSlot('Wednesday', 7, 20, 'Normal', OP.Id);
        TimeSlot ThurTS = FSL_TestDataFactory.createTimeSlot('Thursday', 7, 20, 'Normal', OP.Id);
        TimeSlot FTS = FSL_TestDataFactory.createTimeSlot('Friday', 7, 20, 'Normal', OP.Id);
        
        /*List<TimeSlot> FSL_Base_Slots = [SELECT Id, TimeSlotNumber, DayOfWeek, FSL__Designated_Work_Boolean_Fields__c, StartTime,
                                         		EndTime, OperatingHoursId, FSL__Slot_Color__c, Type
                                         FROM TimeSlot
                                         WHERE OperatingHoursId = :OP.Id];
        
        system.debug('FSL_Base_Slots: ' + FSL_Base_Slots);*/

        //Service Territory
        ServiceTerritory ST = FSL_TestDataFactory.createServiceTerritory('FSL_Base_Territory', OP.Id, '303 Collins St', 'Melbourne',
                                                                        'VIC', '3000','Australia');
        //system.debug('FSL_Base_Territory: ' + ST);
        
        //user and permissions
        test.startTest();
        
        //assign FSL permission sets to test resource
        FSL_TestDataFactory.createUserWithPermissions(TRUE);
        
        test.stopTest();
        
        User usr = [SELECT Id, LastName
                  FROM User
                  WHERE LastName = 'Cunningham'];
        
        //Service Resource
        ServiceResource newSR = FSL_TestDataFactory.createNewServiceResource(usr.Id);
		system.debug('Service Resource: ' + newSR);
        
        List<User> SRUsr = [SELECT Id, FirstName,LastName, Email, Username, isActive
                            FROM User
                            WHERE Id = :newSR.RelatedRecordId];
        for (User u : SRUsr) {
            System.Debug('Service Resource User: ' + u);
        }
        
        
        //Service Territory Memeber junction object
        ServiceTerritoryMember newSTM = FSL_TestDataFactory.createServiceTerritoryMember(newSR.Id, ST.Id, OP.Id);
        System.debug('Service Territory Memeber: ' + newSTM);
        
        //Skill (Electrician)
        Skill S = FSL_TestDataFactory.findSkill('ELECTRICIAN');
        
        System.Debug('Electrician Skill: ' + S);
        
        //Service Resource Skill (Electrician)
        ServiceResourceSkill srK = FSL_TestDataFactory.createSRSkill(newSR.Id, S.Id);
        
        System.Debug('Service Resource Skill: ' + srK);
        
        //Work Type (Electrician)
        WorkType WT = FSL_TestDataFactory.createWorkType('Repair Items', 'ELECTRICIAN');
        system.debug('Work Type: ' + WT);
        
        //Skill Requirement
        SkillRequirement skReq = FSL_TestDataFactory.createSkillReq(WT.Id, s.Id);
        system.debug('Work Type Skill Requirement: ' + skReq);
        
        //claim and WO data
        case getCandidatesTestCS = FSL_TestDataFactory.createClaim();
        
        
        
        workOrder testWO = FSL_TestDataFactory.createWorkOrderWithCase('Home Repair Trades', getCandidatesTestCS.Id, WT.Id, ST.Id,'300 Bourke Street', 'Melbourne', 'VIC', '3000', 'Australia');
        system.debug('testWO: ' + testWO);
        
        //ServiceAppointment testServ = FSL_TestDataFactory.createNewServiceAppointment(testWo, 'New', ST.Id);
        
        // assumes SA automatically created according to Work Type
        ServiceAppointment testServ = [SELECT Id, AppointmentNumber, WorkTypeId, ServiceTerritoryId, Street,
                                       			City, State, PostalCode, Country, EarliestStartTime, DueDate,
                                       			Status, Duration, DurationType
                                       FROM ServiceAppointment
                                       WHERE ParentrecordId = :testWO.Id];
        
        // adjust Due Date on auto-created Service Appointment
        testServ.DueDate = testServ.EarliestStartTime + 5;
        update testServ;
     
        
        //updated workOrder and Service appointment to service territory
        //testServ.ServiceTerritoryId = ST.Id;
        //update testServ;
        
        //testWO.ServiceTerritoryId = ST.Id;
        //update testWO;
        
        //get Skill Requirements for Work Order
        List<SkillRequirement> woSkillList = [SELECT Id, SkillNumber, RelatedRecordId, SkillId
                                  FROM SkillRequirement
                                  WHERE RelatedRecordId = :testWO.Id];
        
        System.Debug('***Service Territory Id: ' + ST.Id);
        System.Debug('***Operating Hours Id: ' + OP.Id);
        System.Debug('***Work Type Id:' + WT.Id);
        System.Debug('***Skill Id: ' + S.Id);
        System.Debug('***Work Order: ' + testWO);
        System.Debug('***WO Skill Requirements: ' + woSkillList);
        System.Debug('***Service Appointment: ' + testServ);
        System.Debug('***SA WorkTypeId: ' + testServ.WorkTypeId);
        
       
        
        
        List<PermissionSetAssignment> psaList = [SELECT Id, AssigneeId, PermissionSetId
                                                FROM PermissionSetAssignment
                                                WHERE AssigneeId = :newSR.RelatedRecordId];
        for (PermissionSetAssignment psa : psaList) {
            System.Debug('User Permission Set Assignment: ' + psa);
        }
        
        // LOOKS LIKE PERMISSION SETS AREN'T BEING ASSIGNED BEFORE GET CANDIDATES IS CALLED
        // AS BEING ADDED IN A FUTURE METHOD!!!
        
        System.debug(LoggingLevel.INFO, '***Calling getSACandidates Controller Method...');
        List<NJ_ServiceAppointmentManagerController.srvCandidateWrapper> srvCandidateList = NJ_ServiceAppointmentManagerController.getSACandidates(testServ.Id, testWO.Id, 'ELECTRICIAN');
        System.Debug('***Candidate List Returned: ' + srvCandidateList);
    }
    
    @isTest static void scheduleAppointmentForCandidateTest(){
        
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
    }
    
    @isTest static void findTempCandidatesTest(){
        workType testWT = FSL_TestDataFactory.createWorkType('Repair Items', 'ELECTRICIAN');
        
        //set service areas for trade account
        List<String> TestServiceAreas = new List<String>();
        TestServiceAreas.add('VIC - Melbourne');
        TestServiceAreas.add('VIC - Melbourne CBD');
        TestServiceAreas.add('VIC - Melbourne - E / SE');
        TestServiceAreas.add('VIC - Melbourne - E / SE');
        TestServiceAreas.add('VIC - Melbourne NE');
        TestServiceAreas.add('VIC - Melbourne NW');
        TestServiceAreas.add('VIC - Melbourne - W');
        //create Trade Account
        Account testTier2 = FSL_TestDataFactory.createServiceResource('testTier2', TestServiceAreas);
        
        //trade compliance
        Trade_Type__c testCompliance = FSL_TestDataFactory.createTradeCompliance(testTier2.Id, testWT.Id);
        
        
        case testClaim = FSL_TestDataFactory.createClaim();
        
        workOrder TestWO = FSL_TestDataFactory.createWorkOrderWithCase('Home Repair Trades', testClaim.Id, testWT.Id, '300 Bourke Street', 
                                                                       												  'Melbourne', 
                                                                       												  'VIC', 
                                                                       												  '3000', 
                                                                      												  'Australia');
        
        ServiceAppointment testSA = FSL_TestDataFactory.createNewServiceAppointment(testWO.Id, testTier2.Id, 'New');
        system.debug('***TestWO Id: ' + TestWO.Id);
        system.debug('***SA ParentId: ' + testSA.ParentRecordId);
        system.debug('***testSA Account: ' + testSa.Tier_2_Trade_Account__c);
        
        test.startTest();
        List<Account> testRunAccounts = NJ_ServiceAppointmentManagerController.findTempCandidates(testWT.Id, 'ELECTRICIAN', 'VIC - Melbourne', 'testTier2');
        
        system.debug('testRun: ' + testRunAccounts);
        test.stopTest();
        
        //system.assertEquals('testTier2', testRunAccounts[0].Name);
    }
    @isTest static void findTempCandidatesTest1(){
        workType testWT = FSL_TestDataFactory.createWorkType('Repair Items', 'ELECTRICIAN');
        
        //set service areas for trade account
        List<String> TestServiceAreas = new List<String>();
        TestServiceAreas.add('VIC - Melbourne');
        TestServiceAreas.add('VIC - Melbourne CBD');
        TestServiceAreas.add('VIC - Melbourne - E / SE');
        TestServiceAreas.add('VIC - Melbourne - E / SE');
        TestServiceAreas.add('VIC - Melbourne NE');
        TestServiceAreas.add('VIC - Melbourne NW');
        TestServiceAreas.add('VIC - Melbourne - W');
        //create Trade Account
        Account testTier2 = FSL_TestDataFactory.createServiceResource('testTier2', TestServiceAreas);
        
        //trade compliance
        Trade_Type__c testCompliance = FSL_TestDataFactory.createTradeCompliance(testTier2.Id, testWT.Id);
        
        
        case testClaim = FSL_TestDataFactory.createClaim();
        
        workOrder TestWO = FSL_TestDataFactory.createWorkOrderWithCase('Home Repair Trades', testClaim.Id, testWT.Id, '300 Bourke Street', 
                                                                       												  'Melbourne', 
                                                                       												  'VIC', 
                                                                       												  '3000', 
                                                                      												  'Australia');
        
        ServiceAppointment testSA = FSL_TestDataFactory.createNewServiceAppointment(testWO.Id, testTier2.Id, 'New');
        system.debug('***TestWO Id: ' + TestWO.Id);
        system.debug('***SA ParentId: ' + testSA.ParentRecordId);
        system.debug('***testSA Account: ' + testSa.Tier_2_Trade_Account__c);
        
        test.startTest();
        List<Account> testRunAccounts = NJ_ServiceAppointmentManagerController.findTempCandidates(testWO.Id, 'ELECTRICIAN', 'VIC - Melbourne', 'testTier2');
        
        system.debug('testRun: ' + testRunAccounts);
        test.stopTest();
        
        //system.assertEquals('testTier2', testRunAccounts[0].Name);
    }
    
    @isTest static void initTempCandidatesTest(){
        workType testWT = FSL_TestDataFactory.createWorkType('Repair Items', 'ELECTRICIAN');
        
        //set service areas for trade account
        List<String> TestServiceAreas = new List<String>();
        TestServiceAreas.add('VIC - Melbourne');
        TestServiceAreas.add('VIC - Melbourne CBD');
        TestServiceAreas.add('VIC - Melbourne - E / SE');
        TestServiceAreas.add('VIC - Melbourne - E / SE');
        TestServiceAreas.add('VIC - Melbourne NE');
        TestServiceAreas.add('VIC - Melbourne NW');
        TestServiceAreas.add('VIC - Melbourne - W');
        //create Trade Account
        Account testTier2 = FSL_TestDataFactory.createServiceResource('testTier2', TestServiceAreas);
        
        //trade compliance
        Trade_Type__c testCompliance = FSL_TestDataFactory.createTradeCompliance(testTier2.Id, testWT.Id);
        
        
        case testClaim = FSL_TestDataFactory.createClaim();
        
        workOrder TestWO = FSL_TestDataFactory.createWorkOrderWithCase('Home Repair Trades', testClaim.Id, testWT.Id, '300 Bourke Street', 
                                                                       												  'Melbourne', 
                                                                       												  'VIC', 
                                                                       												  '3000', 
                                                                      												  'Australia');
        
        ServiceAppointment testSA = FSL_TestDataFactory.createNewServiceAppointment(testWO.Id, testTier2.Id, 'New');
        
        test.startTest();
        NJ_ServiceAppointmentManagerController.TempCandidateMetadata testMetaData = NJ_ServiceAppointmentManagerController.initTempCandidates(testSA.Id);
        
        system.debug('metaData: ' + testMetaData);
        test.stopTest();
        
        system.assertNotEquals(null, testMetaData);
    }
    
    @isTest public static void scheduleTempCandidateTest(){
        //FSL Data
        
        //ServiceResource testResource = FSL_TestDataFactory.createNewServiceResource();
        //set service areas for trade account
        List<String> TestServiceAreas = new List<String>();
        TestServiceAreas.add('VIC - Melbourne');
        TestServiceAreas.add('VIC - Melbourne CBD');
        TestServiceAreas.add('VIC - Melbourne - E / SE');
        TestServiceAreas.add('VIC - Melbourne - E / SE');
        TestServiceAreas.add('VIC - Melbourne NE');
        TestServiceAreas.add('VIC - Melbourne NW');
        TestServiceAreas.add('VIC - Melbourne - W');
        
        Account testTier2Trade = FSL_TestDataFactory.createServiceResource('testTier2Trade', TestServiceAreas);
        
        Contact testContact = FSL_TestDataFactory.createContact(testTier2Trade.Id);
        
        //create user
        test.startTest();
       	FSL_TestDataFactory.createFSLUser(testContact.Id);
        test.stopTest();
        
        User testCandidate = [SELECT Id, Lastname
                              FROM User
                              WHERE LastName = 'Cunningham'];
        
        
        //testCandidate.ContactId = testContact.Id;
        //update testCandidate;
        
        //Operating Hours
        OperatingHours testOPHours = FSL_TestDataFactory.createOperatingHours('FSL_Base');
        //system.debug('FSL_Base: ' + testOPHours);
        
        //setup service territory
        ServiceTerritory testTerritory = FSL_TestDataFactory.createServiceTerritory('FSL_Base_Territory', testOPHours.Id, '303 Collins St', 'Melbourne',
                                                                        'VIC', '3000','Australia');
        
        //setup service territory memeber
        //ServiceTerritoryMember newSTM = FSL_TestDataFactory.createServiceTerritoryMember(testResource.Id, testTerritory.Id, testOPHours.Id);
        //System.debug('Service Territory Memeber: ' + newSTM);
        
		//create Work Type        
        WorkType WT = FSL_TestDataFactory.createWorkType('Repair Items', 'ELECTRICIAN');
    	
        
        case ScheduleTempTestCase = FSL_TestDataFactory.createClaim();
        
        
        workOrder ScheduleTempTestWO = FSL_TestDataFactory.createWorkOrderWithCase('Home Repair Trades', ScheduleTempTestCase.Id, WT.Id, testTerritory.Id,'300 Bourke Street', 'Melbourne', 'VIC', '3000', 'Australia');
        //system.debug('ConfirmationTestWO: ' + ConfirmationTestWO);
        
        ServiceAppointment testServApp = FSL_TestDataFactory.createNewServiceAppointment(ScheduleTempTestWO.Id, 'New');
        //ServiceAppointment testServApp2 = FSL_TestDataFactory.createNewServiceAppointment(ScheduleTempTestWO.Id, 'New');
        
        
        DateTime commStartTime = DateTime.now()+1;
        DateTime commEndTime = DateTime.now()+2;
        //system.debug('testTime: ' + testTime);
        
        
        
        
        
        //call API
        system.debug('********status transistions: ' + FSL.GlobalAPIS.GetAllStatusTransitions());
        
        FSL.GlobalAPIS.addStatusTransition('New', 'Tentative');
        FSL.GlobalAPIS.addStatusTransition('New', 'Confirmed');
        FSL.GlobalAPIS.addStatusTransition('Tentative', 'Confirmed');
        FSL.GlobalAPIS.addStatusTransition('New', 'Awaiting Confirmation');
        
        
        
        
        NJ_ServiceAppointmentManagerController.srvScheduleResponseWrapper testRunResponse =  NJ_ServiceAppointmentManagerController.scheduleTempCandidate(testServApp.Id, testTier2Trade.Id, commStartTime, commEndTime, ScheduleTempTestWO.Id);
        system.debug('testRunResponse: ' + testRunResponse);
        
        
    }
    @isTest public static void scheduleTempCandidateNegativeTest(){
        //FSL Data
        
        //ServiceResource testResource = FSL_TestDataFactory.createNewServiceResource();
        //set service areas for trade account
        List<String> TestServiceAreas = new List<String>();
        TestServiceAreas.add('VIC - Melbourne');
        TestServiceAreas.add('VIC - Melbourne CBD');
        TestServiceAreas.add('VIC - Melbourne - E / SE');
        TestServiceAreas.add('VIC - Melbourne - E / SE');
        TestServiceAreas.add('VIC - Melbourne NE');
        TestServiceAreas.add('VIC - Melbourne NW');
        TestServiceAreas.add('VIC - Melbourne - W');
        
        Account testTier2Trade = FSL_TestDataFactory.createServiceResource('testTier2Trade', TestServiceAreas);
        
        Contact testContact = FSL_TestDataFactory.createContact(testTier2Trade.Id);
        
        //create user
        test.startTest();
        FSL_TestDataFactory.createFSLUser(testContact.Id);
        test.stopTest();
        
		User testCandidate = [SELECT Id, LastName
                              FROM User
                              WHERE LastName = 'Cunningham'];        
        
        //testCandidate.ContactId = testContact.Id;
        //update testCandidate;
        
        //Operating Hours
        OperatingHours testOPHours = FSL_TestDataFactory.createOperatingHours('FSL_Base');
        //system.debug('FSL_Base: ' + testOPHours);
        
        //setup service territory
        ServiceTerritory testTerritory = FSL_TestDataFactory.createServiceTerritory('FSL_Base_Territory', testOPHours.Id, '303 Collins St', 'Melbourne',
                                                                        'VIC', '3000','Australia');
        
        //setup service territory memeber
        //ServiceTerritoryMember newSTM = FSL_TestDataFactory.createServiceTerritoryMember(testResource.Id, testTerritory.Id, testOPHours.Id);
        //System.debug('Service Territory Memeber: ' + newSTM);
        
		//create Work Type        
        WorkType WT = FSL_TestDataFactory.createWorkType('Repair Items', 'ELECTRICIAN');
    	
        
        case ScheduleTempTestCase = FSL_TestDataFactory.createClaim();
        
        
        workOrder ScheduleTempTestWO = FSL_TestDataFactory.createWorkOrderWithCase('Home Repair Trades', ScheduleTempTestCase.Id, WT.Id, testTerritory.Id,'300 Bourke Street', 'Melbourne', 'VIC', '3000', 'Australia');
        //system.debug('ConfirmationTestWO: ' + ConfirmationTestWO);
        
        ServiceAppointment testServApp = FSL_TestDataFactory.createNewServiceAppointment(ScheduleTempTestWO.Id, 'New');
        //ServiceAppointment testServApp2 = FSL_TestDataFactory.createNewServiceAppointment(ScheduleTempTestWO.Id, 'New');
        
        
        DateTime commStartTime = DateTime.now()+1;
        DateTime commEndTime = DateTime.now()+2;
        //system.debug('testTime: ' + testTime);
        
        
        
        
        
        //call API
        system.debug('********status transistions: ' + FSL.GlobalAPIS.GetAllStatusTransitions());
        
        /*FSL.GlobalAPIS.addStatusTransition('New', 'Tentative');
        FSL.GlobalAPIS.addStatusTransition('New', 'Confirmed');
        FSL.GlobalAPIS.addStatusTransition('Tentative', 'Confirmed');
        FSL.GlobalAPIS.addStatusTransition('New', 'Awaiting Confirmation');*/
        
        
        
        Try{
        	NJ_ServiceAppointmentManagerController.srvScheduleResponseWrapper testRunResponse =  NJ_ServiceAppointmentManagerController.scheduleTempCandidate(testServApp.Id, testTier2Trade.Id, commStartTime, commEndTime, ScheduleTempTestWO.Id);
        	system.debug('testRunResponse: ' + testRunResponse);
        }catch(AuraHandledException ax){
            system.debug('Exception: ' + ax.getMessage());
        }
        
        
        
    }
}