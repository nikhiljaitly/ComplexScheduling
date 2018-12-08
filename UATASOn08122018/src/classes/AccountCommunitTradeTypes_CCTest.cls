/* =====================================================================================
Type:       Test class
Purpose:    Test cases for AccountCommunitTradeTypes_CC
========================================================================================*/
@istest 
public class AccountCommunitTradeTypes_CCTest {  
    @testSetup 
    static void setup(){
        List<Account> accList=HomeRepairTestDataFactory.createAccounts('Test');
        
        HomeRepairTestDataFactory.createAttachment(accList[0].Id,'bodyData','description','Test');
        //Create the Policy Record.
        Policy__c po=HomeRepairTestDataFactory.createPolicy();
        system.debug(po.id);
        //Create the Contact Record.
        Contact con=HomeRepairTestDataFactory.createContact('ClaimTest');
        //Create the Case Record.
        Case cs=HomeRepairTestDataFactory.createCaseWithOriginAndPolicy(po.id,con.Id);                      
        WorkType wt=HomeRepairTestDataFactory.createWorkType('Repair Items','Painter');
        //accList[0].Work_Type__c=wt.Id;
        //accList[0].Service_Areas__c='National';        
        update accList;
        Claim_Job__c cj=HomeRepairTestDataFactory.createClaimJob(cs.Id);
        WorkOrder wo=HomeRepairTestDataFactory.createWorkOrderWithCase('Home Repair Trades',cs.id,wt.id,cj.id); 
        
        
        OperatingHours bhs = new OperatingHours();
        bhs.Name = 'Base Calendar (Syd/Vic)';
        bhs.Name = 'Australia/Sydney';
        insert bhs;
        
        ServiceTerritory territory = new ServiceTerritory();
        territory.Name = 'National';
        territory.OperatingHoursId = bhs.Id;
        insert territory;
        
        
        List<ServiceTerritory> terrotiries = new List<ServiceTerritory>();
        ServiceTerritory territory1 = new ServiceTerritory();
        territory1.Name = 'QLD';
        territory1.OperatingHoursId = bhs.Id;
        territory1.ParentTerritoryId = territory.Id;
        ServiceTerritory territory2 = new ServiceTerritory();
        territory2.Name = 'VIC';
        territory2.OperatingHoursId = bhs.Id;
        territory2.ParentTerritoryId = territory.Id;
        ServiceTerritory territory3 = new ServiceTerritory();
        territory3.Name = 'NSW';
        territory3.OperatingHoursId = bhs.Id;
        territory3.ParentTerritoryId = territory.Id;
        
        terrotiries.add(territory1);
        terrotiries.add(territory2);
        terrotiries.add(territory3);
        insert terrotiries;                     
        
    }     
    static testmethod void test_AccountCommunitTradeTypes_CC() {
        List<Account> accList=[Select id from Account];
        AccountCommunitTradeTypes_CC.getAccount(accList[0].Id);
        AccountCommunitTradeTypes_CC.getAccountForm();
        Account acc=new Account();        
        AccountCommunitTradeTypes_CC.getselectOptions(acc,'Type'); 
        List<Lead> ldList=HomeRepairTestDataFactory.createLead('Test','Test','Test');  
        AccountCommunitTradeTypes_CC.updateFinalRegLead(ldList[0]);
        
        Attachment att=[Select Id,Name,Description from attachment where parentId =: accList[0].Id];
        AccountCommunitTradeTypes_CC.deleteFiles(att.Id);
        Trade_Type__c ttype=new Trade_Type__c();
        ttype.Trade_Type__c='Painter';
        String ttypeId=AccountCommunitTradeTypes_CC.insertTradeTypeForAccount(accList[0],ttype);
        HomeRepairTestDataFactory.addContentVersionToParent(ttypeId);
        HomeRepairTestDataFactory.addContentVersionToParent(ttypeId);        
        List<Trade_Type__c> ttypeList=[Select id,Trade_Type__c from Trade_Type__c];
        string ttypeString=JSON.serializePretty(ttypeList);
        AccountCommunitTradeTypes_CC.getCacheTable();
        AccountCommunitTradeTypes_CC.updateAccount(accList[0],ttypeString);
        AccountCommunitTradeTypes_CC.upsertTradeCompliance(ttypeString);
        
        
    }
}