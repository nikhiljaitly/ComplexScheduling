/* =====================================================================================
Type:       Test class
Purpose:    Test cases for UpdateClaimWithFirstJobDetails (For Process Bulider)
========================================================================================*/
@isTest
private class UpdateClaimWithFirstJobDetailsTest{
    static testMethod void UpdateClaimWithFirstJobDetailsTest() {
        List<String> ids=new List<String>();
        // Create the Case Record.
        Case cs = new Case(Status ='new', Priority = 'Medium', Origin = 'Email',Maintenance_Details__c='Test Claim Note',Maintenance_Required__c='Yes'); 
        insert cs;
        Claim_Job__c cj=new Claim_Job__c();
        cj.Source_Internal_Reference_Id__c='cc:6857112';
        cj.Claim__c=cs.Id;
        cj.Action_Type__c='authority';
        insert cj;
        
        ids.add(cs.id);
        UpdateClaimWithFirstJobDetails.UpdateClaimWithFirstJobDetails(ids);
    }
}