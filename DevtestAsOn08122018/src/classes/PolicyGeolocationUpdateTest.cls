/* =====================================================================================
Type:       Test class
Purpose:    Test cases for PolicyGeolocationUpdate  (For Process Bulider)
========================================================================================*/
@isTest
private class PolicyGeolocationUpdateTest{
    static testMethod void updatePolicyGeolocationTest() {
        List<String> ids=new List<String>();
        // Create the Policy__c Record.
        Policy__c po=new Policy__c(AddressLine1__c='Test',AddressLine2__c='Test',AddressLine3__c='Test',Suburb__c='Test',State__c='NSW',Postcode__c='2018');
        insert po;
        ids.add(po.id);
        Test.startTest();
           PolicyGeolocationUpdate.updatePolicyGeolocation(ids);
        Test.stopTest();
        
    }
}