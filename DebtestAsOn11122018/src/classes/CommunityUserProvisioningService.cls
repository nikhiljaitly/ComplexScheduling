/************************************************************************************************************
Name: CommunityUserProvisioningService
=============================================================================================================
Purpose: Class having re-usable Community User Creation logic.
===============================================================================================================
History
-----------
VERSION    AUTHOR           DATE             DETAIL        DESCRIPTION
1.0        Mathew         10/12/2017        Created       Trade Portal Community
*************************************************************************************************************/

public class CommunityUserProvisioningService {

    /***************************************************************** 
    Purpose: Method to perform updates on the certificate record when payment succeeds.                                                       
    Parameters: Map of payment transaction Id to payment status.
    Returns: none
    Throws [Exceptions]: None                                                          
    History                                                             
    --------                                                            
    VERSION        AUTHOR         DATE           DETAIL       Description 
    1.0            Mathew        07/11/2017      Created     Smart Meter project  
    *******************************************************************/
    public static void createCommunityUsers(Map<ID,Contact> contactRecords) {
        system.debug('Entering createCommunityUsers: '+'contactRecordIds: '+contactRecords.keySet()+ 'ContactRecords: '+contactRecords.Values());
     Profile commUserProfile = [select Id, Name from Profile where Name = 'Trade Platfrom Community Plus User'];
     List<User> commUserList = new List<User>();
     User u;
     for(Contact con : contactRecords.Values()){
       if(con.Account.Owner.UserRoleId != NULL)
             String usernameUniqueKey = UserInfo.getOrganizationId() + System.currentTimeMillis();
        u = new User();
         //u.UserName = con.Email+'.homerepair1';
         u.UserName = con.Email+'.hrDEV';
         u.Email = con.Email;
         u.ProfileId = commUserProfile.Id;
         u.CommunityNickName = Con.FirstName.substring(0,2)+String.valueOf(System.currentTimeMillis()).subString(0, 8);
         u.Alias = String.valueOf(System.currentTimeMillis()).subString(0, 8);
            u.FirstName = con.FirstName;
            u.LastName = con.LastName;
            u.ContactId = con.Id;
             u.Localesidkey = 'en_AU';
            u.Emailencodingkey = 'UTF-8';
            u.Languagelocalekey = 'en_US';
            u.TimeZoneSidKey = 'Australia/Sydney';
            commUserList.add(u);         
     }
        try{
          if(!commUserList.IsEmpty())
              //Database.SaveResult[] srList = Database.insert(commUserList, false);
              insert commUserList;
              //system.debug('Exiting processCCEWRelatedRecordsOnSuccess: ' + 'saveResults: ' + srList);
        }catch(DMLException e) {
          System.Debug('User Insert Error'+ e.getMessage());
        }     
    }
}