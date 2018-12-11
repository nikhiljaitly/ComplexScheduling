/*Used for  Lead_FinalRegistration_CC Class*/

@istest 
public class  Lead_FinalRegistration_CCTest {    
    static testmethod void testLead_FinalRegistrationProcess() {
        List<Lead> leadList=HomeRepairTestDataFactory.createLead('Test Lead','Lead Last Name');    
        Test.startTest();  
            Lead_FinalRegistration_CC.getLead(leadList[0].Id); 
            Lead_FinalRegistration_CC.updateFinalRegLead(leadList[0]);       
        Test.stopTest();
        System.AssertEquals([SELECT Status FROM Lead].Status,'2nd Form Submitted');  
    }
}