/***************************************************************** 
Purpose: Schedule job to run BatchClaimJobIngestionStagingProcess 
History                                                             
--------                                                            
VERSION        AUTHOR         DATE           DETAIL       Description 
1.0            Vasu          20/02/2018      Created      Home Repair Claim System  
*******************************************************************/
global class ScheduledClaimIngestionStagingProcess implements Schedulable {
   global void execute(SchedulableContext sc) {
       BatchClaimJobIngestionStagingProcess objClaim = new BatchClaimJObIngestionStagingProcess();
       Database.executeBatch(objClaim);      
   }
}