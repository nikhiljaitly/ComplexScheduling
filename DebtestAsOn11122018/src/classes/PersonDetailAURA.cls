public class PersonDetailAURA {
  @AuraEnabled 
  public static String getContactId(){
    String userId = userinfo.getUserId();
    User loggedUser = [SELECT ContactId FROM User WHERE Id =:userId LIMIT 1];
    if (!String.IsBlank(loggedUser.ContactId))
        return loggedUser.ContactId;
    else
      return null;
  }

}