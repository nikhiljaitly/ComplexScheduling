public class ActivityEmailAlertUpdate {
	@InvocableMethod
    public static void updateActivityEmailAlert(){
        //get all current tasks fitting criteria
        List<Task> unclosedTasks = [SELECT id, subject, status
                     				FROM Task
                     				WHERE subject = 'MS no action 2 hours' 
                                    AND status = 'Not Started'];
        
        //update single kept record on Activity_Email_Alert__c 
        if(unclosedTasks.size() > 0){ 
            integer unclosedTasksCount = unclosedTasks.size();
            
            Activity_Email_Alert__c AlertToUpdate = [SELECT id, Activity_Description__c, 
                                                     		Overdue_Activity_Count__c
                                                     FROM Activity_Email_Alert__c
                                                     WHERE Name = 'MakeSafe Tasks Unclosed'
                                                     LIMIT 1];
            //count equal to list size
            try{
                AlertToUpdate.Overdue_Activity_Count__c = unclosedTasksCount;
                update AlertToUpdate;
            } catch(exception e){
                system.debug(loggingLevel.DEBUG, '***Problem with AlertToUpdate'+ AlertToUpdate);
                return;
                
            }
        }
    }
}