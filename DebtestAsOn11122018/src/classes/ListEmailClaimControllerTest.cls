/*Used for  ListEmailClaimController Class*/
@istest 
public class  ListEmailClaimControllerTest {    
    static testmethod void testListEmailClaimController() {
        EmailTemplate validEmailTemplate =[select id from EmailTemplate limit 1];    
        Policy__c po=HomeRepairTestDataFactory.createPolicy();
        system.debug(po.id);
        Contact con=HomeRepairTestDataFactory.createContact('Test');
        system.debug(con.id);
        Case cs=HomeRepairTestDataFactory.createCaseWithOriginAndPolicy(po.id,con.Id);
         
        WorkType wt=HomeRepairTestDataFactory.createWorkType('Repair Items','Test');   
        WorkOrder wo=HomeRepairTestDataFactory.createWorkOrderWithCase('Home Repair Trades',cs.id,wt.id);
        All_Service_Appointments__c asa=HomeRepairTestDataFactory.createAllServiceAppointments(cs.id,wt.id);
        asa.Service_Resource__c=userinfo.getuserid();
        update asa;
        HomeRepairTestDataFactory.addContentVersionToParent(cs.Id);
        ContentVersion cv=[SELECT Id, ContentDocumentId FROM ContentVersion limit 1];
        List<String> contentDocumentIds=new List<String>();
        contentDocumentIds.add(cv.ContentDocumentId);
        Test.startTest();
            ListEmailClaimController.getClaimContactsEmailList(cs.Id);
            ListEmailClaimController.getClaimContacts(cs.Id);
            
            ListEmailClaimController.getFiles(cs.Id);
            ListEmailClaimController.getTemplates();
            ListEmailClaimController.getTemplateDetails(validEmailTemplate.Id);
            ListEmailClaimController.getContentDocumentAsAttachement(contentDocumentIds);
            List<String> userIds=new List<String>();
            userIds.add(userinfo.getuserid());
            ListEmailClaimController.postChatterToClaim(cs.id,userIds);
            ListEmailClaimController.sendAnEmailMsg(null,userIds,userIds,userIds,'Test','Test sent Email',contentDocumentIds,cs.id);
            ListEmailClaimController.sendAnEmailMsg(validEmailTemplate.Id,userIds,userIds,userIds,'Test','Test sent Email',contentDocumentIds,cs.id);
        Test.stopTest();
        
    }
}