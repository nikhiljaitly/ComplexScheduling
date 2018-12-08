/* =====================================================================================
Type:       Test class
Purpose:    Test cases for ClaimNotesForClaim (For Process Bulider)
========================================================================================*/
@isTest
private class TestClaimNotesForClaim{
    static testMethod void fetchClaimForClaimJobTest() {
        List<String> ids=new List<String>();
        // Create the Case Record.
        Case cs = new Case(Status ='new', Priority = 'Medium', Origin = 'Email',Maintenance_Details__c='Test Claim Note',Maintenance_Required__c='Yes'); 
        insert cs;
        ids.add(cs.id);
        ClaimNotesForClaim.fetchClaimForClaim(ids);
    }
}