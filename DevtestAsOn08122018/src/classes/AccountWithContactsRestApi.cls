@RestResource(urlMapping='/AccountWithContacts/*')
global with sharing class AccountWithContactsRestApi {  
    @HttpGet
    global static void doGet() {
        RestRequest req = RestContext.request;
        RestResponse res = RestContext.response;
        String accountId = req.requestURI.substring(req.requestURI.lastIndexOf('/')+1);
        List<Account> accList=[select id,Name, (Select id,Name,Phone,Email,MobilePhone from Contacts) from Account where id='0010K00001eDrXS'];
        AccountWithContactsWrapper accWrap;
        for(Account acc:accList){
            List<ContactsWrapper> conWrapList=new List<ContactsWrapper>();
            if(acc.contacts.size() > 0){
                for(Contact con : acc.contacts){
                    ContactsWrapper cw=new ContactsWrapper(con);
                    conWrapList.add(cw);
                }        
            }
            accWrap=new AccountWithContactsWrapper(acc,conWrapList);
        }
        system.debug(JSON.serialize(accWrap));
        RestContext.response.addHeader('Content-Type', 'application/json');
        RestContext.response.responseBody = Blob.valueOf(JSON.serialize(accWrap));
        //return JSON.serialize(accWrap);
    }
}