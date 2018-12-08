/* =====================================================================================
Type:       Test class
Purpose:    Test cases for Lead_FinalRegistration_CC (For LeadFinalForm Component )
========================================================================================*/
@isTest
private class Lead_FinalRegistration_CCTest{
    static testMethod void Lead_FinalRegistrationAllTest() { 
        Lead ld=new Lead();
        Blob bodyBlob=Blob.valueOf('Unit Test Attachment Body');
        String base64Data= EncodingUtil.base64encode(bodyBlob);
        ld = HomeRepairTestDataFactory.createLead('Test','Test','TestLastName')[0];
        Lead_FinalRegistration_CC.getLead(ld.Id);
        Attachment att=HomeRepairTestDataFactory.createAttachment(ld.Id,'Test Lead','Test','Lead');
        Lead_FinalRegistration_CC.getFiles(ld.Id);
        Lead_FinalRegistration_CC.deleteFiles(att.Id);        
        Lead_FinalRegistration_CC.updateFinalRegLead(ld);
    }
}