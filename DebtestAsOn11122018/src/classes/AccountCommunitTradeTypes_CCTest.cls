/***************************************************************** 
Purpose: Test class for AccountCommunitTradeTypes_CC 
History                                                             
--------                                                            
VERSION        AUTHOR         DATE           DETAIL       Description 
1.0            Vasu          20/02/2018      Created      Home Repair Claim System  
*******************************************************************/
@istest 
public class AccountCommunitTradeTypes_CCTest {    
    static testmethod void test_AccountCommunitTradeTypes_CC() {
        List<Account> accList=HomeRepairTestDataFactory.createAccounts('Test');
        AccountCommunitTradeTypes_CC.getAccount(accList[0].Id);
        Account acc=new Account();
        AccountCommunitTradeTypes_CC.getselectOptions(acc,'Type');  
    }
}