/***************************************************************** 
Purpose: Test class for BatchClaimJobIngestionStagingProcess 
History                                                             
--------                                                            
VERSION        AUTHOR         DATE           DETAIL       Description 
1.0            Vasu          20/02/2018      Created      Home Repair Claim System  
*******************************************************************/
@istest 
public class BatchClaimJobIngestionStagingProcessTest {    
    static testmethod void testBatchClaimJobIngestionStagingProcess() {
        HomeRepairTestDataFactory.createAccounts('Test');
        List<Claim_Job_Ingestion_Staging__c> cjobList=HomeRepairTestDataFactory.createClaimJobIngestionStaging('25533986','7177774','7177774','A020490615');
        HomeRepairTestDataFactory.createClaimJobWorkItemStaging('8370852','7177774',cjobList[0].id);        
        Test.startTest();  
        BatchClaimJobIngestionStagingProcess objClaim = new BatchClaimJobIngestionStagingProcess();
        Database.executeBatch(objClaim);          
        Test.stopTest();
        System.AssertEquals([SELECT id FROM Policy__c].size(),1);       
    }
}