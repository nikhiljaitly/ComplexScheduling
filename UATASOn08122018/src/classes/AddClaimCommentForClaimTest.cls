/* =====================================================================================
Type:       Test class
Purpose:    Test cases for AddClaimCommentForClaim
========================================================================================*/
@isTest
private class AddClaimCommentForClaimTest{
    static testMethod void fetchClaimForClaimJobTest() {
        List<String> ids=new List<String>();
		 //Create the Policy Record.
        Policy__c po=HomeRepairTestDataFactory.createPolicy();
        //Create the Contact Record.
        Contact con=HomeRepairTestDataFactory.createContact('ClaimTest');
        //Create the Case Record.
        Case cs=HomeRepairTestDataFactory.createCaseWithOriginAndPolicy(po.id,con.Id);
        Vendor_Note__c vend = HomeRepairTestDataFactory.createVendorNote(cs.Id);  
        ids.add(vend.id);
        AddClaimCommentForClaim.addClaimComment(ids);
    }
}