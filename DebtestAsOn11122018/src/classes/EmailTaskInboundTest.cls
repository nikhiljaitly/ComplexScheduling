@isTest
private class EmailTaskInboundTest {
    @isTest
    static void EmailTaskInboundWithCaseTest(){
      //Create the Policy Record.
      Policy__c po=HomeRepairTestDataFactory.createPolicy();
      //Create the Contact Record.
      Contact con=HomeRepairTestDataFactory.createContact('ClaimTest');
      //Create the Case Record.
      Case cs=HomeRepairTestDataFactory.createCaseWithOriginAndPolicy(po.id,con.Id);
      List<String> toAddresses = new List<String>(); 
      toAddresses.add('test@test.com');
      EmailTaskInbound emailTask = new EmailTaskInbound();
      Messaging.inboundEmail email = new Messaging.inboundEmail();
      email.subject = cs.CaseNumber;
      email.plainTextBody = 'my plain text';
      email.toAddresses=toAddresses;
      
      // add an attachment
      Messaging.InboundEmail.BinaryAttachment attachment = new Messaging.InboundEmail.BinaryAttachment();
      attachment.body = blob.valueOf('my attachment text');
      attachment.fileName = 'textfile.txt';
      attachment.mimeTypeSubType = 'text/plain';
      
      Messaging.Inboundemail.TextAttachment attachmentText = new Messaging.Inboundemail.TextAttachment();
      attachmentText.body = 'my attachment text';
      attachmentText.fileName = 'textfile.txt';
      attachmentText.mimeTypeSubType = 'text/plain';
          
      email.binaryAttachments = new Messaging.inboundEmail.BinaryAttachment[] { attachment };
      email.textAttachments= new Messaging.Inboundemail.TextAttachment[]{attachmentText};
      
      Messaging.InboundEnvelope env = new Messaging.InboundEnvelope();        
      emailTask.handleInboundEmail(email, env);        
    }
    @isTest
    static void EmailTaskInboundWithoutCaseTest(){
      List<String> toAddresses = new List<String>(); 
      toAddresses.add('test@test.com');
      EmailTaskInbound emailTask = new EmailTaskInbound();
      Messaging.inboundEmail email = new Messaging.inboundEmail();
      email.subject = 'case #';
      email.plainTextBody = 'my plain text';
      email.toAddresses=toAddresses;
      
      Messaging.InboundEnvelope env = new Messaging.InboundEnvelope();        
      emailTask.handleInboundEmail(email, env);
    }

}