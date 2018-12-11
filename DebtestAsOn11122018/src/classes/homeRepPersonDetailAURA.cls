public without sharing class homeRepPersonDetailAURA {
  @AuraEnabled 
  public static String getContactId(){
    String userId = userinfo.getUserId();
    User loggedUser = [SELECT Id,ContactId, Contact.AccountId FROM User WHERE Id =:userId LIMIT 1];
    if (!String.IsBlank(loggedUser.ContactId))
        return JSON.serialize(loggedUser);
    else
      return 'null';
  }
  @AuraEnabled 
  public static String getServiceResourceId(){
    String userId = userinfo.getUserId();
    //return userId;
    ServiceResource serviceResource = [SELECT Id FROM ServiceResource WHERE RelatedRecordId =:userId LIMIT 1];
    if (!String.IsBlank(serviceResource.Id))
        return serviceResource.Id;
    else
      return 'null';
  }
  @AuraEnabled 
  public static List<ServiceResource> getServiceResources(){
    String userId = userinfo.getUserId();
    User loggedUser = [SELECT Id,AccountId,Contact.AccountId FROM User WHERE Id =:userId LIMIT 1];
    List<contact> contactList=[SELECT id FROM contact WHERE AccountId =: loggedUser.Contact.AccountId LIMIT 1];
    Set<String> userSet=new Set<String>();
    for(user us : [select id,ContactId from User where ContactId IN : contactList]){
          userSet.add(us.id);
    }
    List<ServiceResource> srList=new List<ServiceResource>();
    srList = [SELECT Id,Name,ResourceType FROM ServiceResource WHERE RelatedRecordId IN : userSet];
    return srList;
    //return JSON.serialize(loggedUser);
  }
  @AuraEnabled 
  public static String getServiceResourceId(String serviceResourceId){
    ServiceResource serviceResource = [SELECT Id FROM ServiceResource WHERE Id =: ServiceResourceId LIMIT 1];
    return serviceResource.Id;
  }
}