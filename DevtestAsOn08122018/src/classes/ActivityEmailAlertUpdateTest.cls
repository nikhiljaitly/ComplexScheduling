@isTest
public class ActivityEmailAlertUpdateTest {
    @isTest static void testFieldUpdate(){
        //data setup
        Activity_Email_Alert__c makeSafeAlert = new Activity_Email_Alert__c(Name = 'MakeSafe Tasks Unclosed', 
                                                                            Overdue_Activity_Count__c =0);
        
        insert makeSafeAlert;
        
        List<Task> makeSafeTests = new List<Task>();
        
        for (integer i = 0; i < 5; i++){
            Task makeSafe = new Task();
            makeSafe.Subject = 'MS no action 2 hours';
            makesafe.Description = 'Makesafe work order has not been submitted by HomeRepair within 2 hours';
            makeSafe.Status = 'Not Started';
            system.debug('makeSafe' + i + ' ' + makeSafe);
            makeSafeTests.add(makeSafe);
        }
        system.debug('makeSafeTests: ' + makeSafeTests);
        
        test.startTest();
        
        insert makeSafeTests;
        
        activityEmailAlertUpdate.updateActivityEmailAlert();
        test.stopTest();
        
        Activity_Email_Alert__c msAlert = [SELECT id, Activity_Description__c, 
                                                     Overdue_Activity_Count__c
                                                     FROM Activity_Email_Alert__c
                                                     WHERE Name = 'MakeSafe Tasks Unclosed'
                                                     LIMIT 1];
        
        system.debug('msAlert: ' + msAlert);
        
        system.assertEquals(5, msAlert.Overdue_Activity_Count__c);
    }
}