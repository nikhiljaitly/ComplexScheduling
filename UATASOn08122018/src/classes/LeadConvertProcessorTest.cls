/* =====================================================================================
Type:       Test class
Purpose:    Test cases for LeadConvertProcessor (For Lead Trigger )
========================================================================================*/
@isTest
private class LeadConvertProcessorTest{
    static testMethod void LeadConvertProcessorAllTest() { 
        Lead ld=new Lead();
        ld = HomeRepairTestDataFactory.createLead('Test','Test','TestLastName')[0]; 
        ld.Status='2nd Form Submitted';  
        ld.Phone='0429283938';
        update ld;             
        HomeRepairTestDataFactory.createAttachment(ld.Id,'Test Lead','Test','Lead');
        HomeRepairTestDataFactory.createAttachment(ld.Id,'Test Lead','Lead','Test');
        Database.LeadConvert lc = new database.LeadConvert();
        lc.setLeadId(ld.id);
        lc.setDoNotCreateOpportunity(false);
        lc.setConvertedStatus('Converted');
        Home_Repairs_Trigger_Switch__c hrts = HomeRepairTestDataFactory.createHomeRepairsTriggerSwitch();
        Database.LeadConvertResult lcr = Database.convertLead(lc);
        System.assert(lcr.isSuccess());
    }
}