/* =====================================================================================
Type:       Test class
Purpose:    Test cases for ListEmailClaimController
========================================================================================*/
@isTest
private class ListEmailClaimControllerTest{
    @testSetup 
    static void setup(){
        //Create the Policy Record.
        Policy__c po=HomeRepairTestDataFactory.createPolicy();
        system.debug(po.id);
        //Create the Contact Record.
        Contact con=HomeRepairTestDataFactory.createContact('ClaimTest');
        //Create the Case Record.
        Case cs=HomeRepairTestDataFactory.createCaseWithOriginAndPolicy(po.id,con.Id);                
         
        WorkType wt=HomeRepairTestDataFactory.createWorkType('Repair Items','Assessment');
        Claim_Job__c cj=HomeRepairTestDataFactory.createClaimJob(cs.Id);
        WorkOrder wo=HomeRepairTestDataFactory.createWorkOrderWithCase('Home Repair Trades',cs.id,wt.id,cj.id);
        List<WorkOrderLineItem> woliList=HomeRepairTestDataFactory.createWorkOrderLineItem('Home Repair',cs.id,wt.Id,wo.Id,1);
        Account acc=HomeRepairTestDataFactory.createTradeAccount();
        Contact tradeCont = HomeRepairTestDataFactory.createTradeContact('Test',acc.Id);
        user tradeUser = HomeRepairTestDataFactory.createTradeUser(tradeCont.Id);
        HomeRepairTestDataFactory.assignFSLPermissionSets(tradeUser.Id);
        ServiceResource sr = HomeRepairTestDataFactory.createNewServiceResource(userInfo.getUserId());
        ServiceAppointment sa= HomeRepairTestDataFactory.createNewServiceAppointment(wo.Id, 'New', cs.Id, sr.Id);
        Room__c rm=HomeRepairTestDataFactory.createRoom(cs.id,woliList);
        HomeRepairTestDataFactory.addContentVersionToParent(cs.id);
    }   
    static testMethod void ListEmailClaimControllerAllTest() {
        Case cs = [SELECT id FROM Case LIMIT 1];
        ListEmailClaimController.getClaimContactsEmailList(cs.id);
        ListEmailClaimController.getClaimContacts(cs.id);
        ListEmailClaimController.getFiles(cs.id);
        ListEmailClaimController.getTemplates();
        String tempId=[SELECT Id,Name,Subject,TemplateType,body FROM EmailTemplate limit 1].Id;
        ListEmailClaimController.getTemplateDetails(tempId);
        List<Messaging.EmailFileAttachment> emailAttachmentList=ListEmailClaimController.getContentDocumentAsAttachement(new List<string>{cs.id});
        List<string> conList = new List<string>();
        List<String> IdList=new List<String>();
        for(Contact con : [SELECT id,Email FROM Contact]){
            conList.add(con.Id);
            IdList.add(con.Id);
        }
        List<string> attIds=new List<string>();
        attIds.add(cs.id);
        ListEmailClaimController.postChatterToClaim(cs.Id,conList);
        User ur=[SELECT id,Email FROM user LIMIT 1];
        List<Messaging.SingleEmailMessage> semList=new List<Messaging.SingleEmailMessage>();
        ListEmailClaimController.generateEmails('test@test.com',ur.id,cs.Id,tempId,'Test','Test',emailAttachmentList,semList,false);
        List<String> emailList=new List<String>();
        emailList.add(ur.Email);
        IdList.add(ur.Id);
        ListEmailClaimController.sendAnEmailMsg(tempId,IdList,emailList,emailList,'Test','Test',attIds,cs.Id);
    }
}