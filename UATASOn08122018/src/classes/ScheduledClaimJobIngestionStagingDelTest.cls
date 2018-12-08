/***************************************************************** 
Purpose: Schedule job to run ScheduledClaimJobIngestionStagingDelTest
History                                                             
--------                                                            
VERSION        AUTHOR         DATE           DETAIL       Description 
1.0            Vasu          30/11/2018      Created      Home Repair Claim System  
========================================================================================*/
@isTest
private class ScheduledClaimJobIngestionStagingDelTest {    
    
    static testMethod void ScheduledClaimJobIngestionStagingDeleteTest() {
        
        User usr = [Select id from User where Id = :UserInfo.getUserId()];
        
        System.RunAs(usr){
            system.debug('=================ScheduledClaimJobIngestionStagingDeleteTest Starts ================');
            //Create general settings record
            GeneralSettings__c generalSettings  = HomeRepairTestDataFactory.generalSettings('ITSupportEmail',
                                                                                           'hrtest@gmail.com');    
            //Create the Policy Record.
            Policy__c po=HomeRepairTestDataFactory.createPolicy();
            //Create the Contact Record.
            Contact con=HomeRepairTestDataFactory.createContact('ClaimTest');
            //Create the Case Record.
            Case cs=HomeRepairTestDataFactory.createCaseWithOriginAndPolicy(po.id,con.Id);
            WorkType wt=HomeRepairTestDataFactory.createWorkType('Repair Items','Carpenter');
            Claim_Job__c cj=HomeRepairTestDataFactory.createClaimJob(cs.Id);
            Test.StartTest();
            ScheduledClaimJobIngestionStagingDelete s=new ScheduledClaimJobIngestionStagingDelete();
            s.execute(null) ;
            Test.StopTest();
            system.debug('=================ScheduledClaimJobIngestionStagingDeleteTest Ends ================');
        }
    }
    
    
}