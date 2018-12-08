public class homeRepPersonDetailAURA {
  @AuraEnabled 
  public static String getContactId(){
    String userId = userinfo.getUserId();
    User loggedUser = [SELECT ContactId, Contact.AccountId FROM User WHERE Id =:userId LIMIT 1];
    if (!String.IsBlank(loggedUser.ContactId))
        return JSON.serialize(loggedUser);
    else
      return 'null';
  }
}