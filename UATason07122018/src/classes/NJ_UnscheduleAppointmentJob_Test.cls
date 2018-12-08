/**
 * This is a test class for NJ_UnscheduleAppointmentJob
 * @CreatedDate : 23/11/2018
 * @CreatedBy : Nikhil Jaitly
 */

@isTest

public with sharing class NJ_UnscheduleAppointmentJob_Test {
    
    public static testMethod void testschedule() {
        //test data setup
        
            
        DateTime currentTime = DateTime.now();
        system.debug('currentTime: ' + currentTime);
            
        Datetime statusChange = currentTime.addMinutes(-60*3);
        system.debug('statusChange: ' + statusChange);
        
        system.debug('transistions: ' + FSL.GlobalAPIS.GetAllStatusTransitions());
        
        
        FSL.GlobalAPIS.addStatusTransition('Tentative', 'New');
        
        Case testCase = FSL_TestDataFactory.createClaim();
        workOrder testWO = FSL_TestDataFactory.HRTradeWorkOrderWithCase(testCase.Id);
        
        worktype testWT = [SELECT Id, Name
                           FROM workType
                           WHERE id = :testWO.WorkTypeId];
        system.debug('work type: '  + testWT);
            
        ServiceAppointment testServ = FSL_TestDataFactory.createNewServiceAppointment(testWo.Id, 'Tentative', testCase.Id);
        ServiceAppointment testServ1 = FSL_TestDataFactory.createNewServiceAppointment(testWo.Id, 'Tentative', testCase.Id);
        
        /*testServ.Status_Change_to_Tentative__c = statusChange;   
        testServ1.Status_Change_to_Tentative__c = statusChange;
            
        update testServ;
        update testServ1;*/
            
        List<ServiceAppointment> testSrvs = new list<ServiceAppointment>();
        testSrvs.add(testServ);
        testSrvs.add(testServ1);
        
        for(ServiceAppointment x : testSrvs){
            x.Status_Change_to_Tentative__c = statusChange;
        }
            
        update testSrvs;
            
        Test.StartTest();
        
        NJ_UnscheduleAppointmentJob newJob = new NJ_UnscheduleAppointmentJob();
        System.schedule('unschJob', '0 5 * * * ?',newJob);
        
        Test.stopTest();
        
        List<ServiceAppointment> testServAppts = [SELECT Id, status
                                                  FROM ServiceAppointment
                                                  WHERE id IN :testSrvs];
        system.debug('Service Appts after: ' + testServAppts);
            
        for(ServiceAppointment y : testServAppts){
            system.assertEquals('New', y.status);
        }
        
    }    
        
   }