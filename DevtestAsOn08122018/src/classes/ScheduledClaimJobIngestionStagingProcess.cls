/***************************************************************** 
Purpose: Schedule job to run BatchClaimJobIngestionStagingDelete 
History                                                             
--------                                                            
VERSION        AUTHOR         DATE           DETAIL       Description 
1.0            Vasu          30/11/2018      Created      Home Repair Claim System  
*******************************************************************/
global class ScheduledClaimJobIngestionStagingProcess implements Schedulable {
   global void execute(SchedulableContext sc) {
       BatchClaimJobIngestionStagingProcess objClaim = new BatchClaimJObIngestionStagingProcess();
       Database.executeBatch(objClaim);      
   }
}