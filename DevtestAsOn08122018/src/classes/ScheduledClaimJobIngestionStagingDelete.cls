/***************************************************************** 
Purpose: Schedule job to run BatchClaimJobIngestionStagingDelete
History                                                             
--------                                                            
VERSION        AUTHOR         DATE           DETAIL       Description 
1.0            Vasu          30/11/2018      Created      Home Repair Claim System  
*******************************************************************/
global class ScheduledClaimJobIngestionStagingDelete implements Schedulable {
   global void execute(SchedulableContext sc) {
       BatchClaimJobIngestionStagingDelete  batchClaimDelete = new BatchClaimJobIngestionStagingDelete ();
       Database.executeBatch(batchClaimDelete);      
   }
}