/* =====================================================================================
Type:       Test class
Purpose:    Test cases for PopulateFullNameOfProduct (For Process Bulider)
========================================================================================*/
@isTest
private class TestPopulateFullNameOfProduct{
    static testMethod void fetchProductForFullNameTest() {
        List<String> ids=new List<String>();
        // Create the Product Record.
        List<Product2> proList=HomeRepairTestDataFactory.createProductWithPricebookEntryAndWorkCodes('Level Testing');
        system.debug(proList);
        ids.add(proList[0].id);
        PopulateFullNameOfProduct.fetchProductForProductFullName(ids);
    }
}