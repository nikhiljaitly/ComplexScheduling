/************************************************************************************************************
Name: APInvoiceSharingSrvc
=============================================================================================================
Purpose: Class with re-usable methods which manages sharing access for Invoice__c.
===============================================================================================================
History
-----------
VERSION    AUTHOR           DATE             DETAIL       DESCRIPTION
1.0        Vasu         4/07/2018        Created       Home Repair Claim System  
*************************************************************************************************************/
public without sharing class APInvoiceSharingSrvc {
    public static void createSharingforAPInvoice(List<AP_Invoice__c> invList) {
        
        system.debug('Entering createSharingforInvoice: '+ 'invLIst: ' + invLIst);
        
        Map<Id,Id> roleToGroup = new Map<Id,Id>();                                                         
        
        for (Group grp: [Select Id,Name,RelatedId,Type From Group where RelatedId in (select id from UserRole where PortalType = 'CustomerPortal')]){
            roleToGroup.put(grp.RelatedId,grp.Id); 
         }  
        
        List<AP_Invoice__Share> invShareList = new List<AP_Invoice__Share>();
        invShareList  = prepareAPInvoiceShareList(invList,roleToGroup);
        
        if(!invShareList.IsEmpty()){
            try{
                Upsert invShareList;
            }catch(DMLException e) {
                system.debug('Error while upserting Invoice__Share ' + e.getMessage());
            }           
        }
        system.debug('Exiting createSharingforInvoice method');
        
    }
    
    public static List<AP_Invoice__Share> prepareAPInvoiceShareList(List<AP_Invoice__c> invList,Map<Id,id> roleToGroup){
        system.debug('Entering prepareAPInvoiceShareList: '+ 'invLIst: ' + invLIst);
        List<AP_Invoice__Share> invShareList = new List<AP_Invoice__Share>();
        
        for(AP_Invoice__c inv : invList){
            AP_Invoice__Share invshare = new AP_Invoice__Share();
            invshare.ParentId = inv.Id;
            if (roleToGroup.containskey(inv.Trade_User_Role_Id__c)){
                system.debug('Trade_User_Role_Id__c: ' + inv.Trade_User_Role_Id__c);
                invShare.UserOrGroupId = roleToGroup.get(inv.Trade_User_Role_Id__c);
            }
            invShare.AccessLevel = 'edit';
            invShareList.add(invShare);
          }
        system.debug('Exiting  prepareAPInvoiceShareList method '+'invshList: ' + invList);
        return invShareList;
    }
}