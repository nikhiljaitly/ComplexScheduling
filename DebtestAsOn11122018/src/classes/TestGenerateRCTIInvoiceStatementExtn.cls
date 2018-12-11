@isTest
private class TestGenerateRCTIInvoiceStatementExtn{
    @isTest
    static void GenerateRCTIInvoiceStatementExtnTest(){
        HomeRepairTestDataFactory.createAccounts('HomeRepair .Net. Au Pty Ltd');
      // GenerateRCTIInvoiceStatementExtn genRCTIExt=new GenerateRCTIInvoiceStatementExtn(); 
         InvoiceStatementExtn genRCTIExt=new InvoiceStatementExtn();      
        Account acc = genRCTIExt.acc; 
        // Initialising Standard Controller Extension
        ApexPages.StandardController sc = new ApexPages.StandardController(acc);  
        InvoiceStatementExtn genRCTIExtSc=new InvoiceStatementExtn(sc);   
    }

}