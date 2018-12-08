/************************************************************************************************************
Name: AccountSharingForCommunityUsers
=============================================================================================================
Purpose: Class to manage programmatic sharing of Accounts with new Community Users.
===============================================================================================================
History
-----------
VERSION    AUTHOR           DATE             DETAIL        DESCRIPTION
1.0        Mathew         13/12/2017        Created       Trade Portal
*************************************************************************************************************/

public class AccountSharingForCommunityUsers{
    /***************************************************************** 
    Purpose: Invocable Method called from the Process builder which controls Apex Managed Sharing.                                                      
    Parameters: List of Community User Record Ids
    Returns: none
    Throws [Exceptions]: None                                                          
    History                                                             
    --------                                                            
    VERSION        AUTHOR         DATE           DETAIL       Description 
    1.0            Mathew        13/12/2017      Created       Trade Portal
    *******************************************************************/
    @InvocableMethod
    public static void createAccountShareForCommunityUsers(List<ID> userIds) {
        system.debug('Entering createAccountShareForCommunityUsers: '+ 'userIds: ' + userIds);
        List<AccountShare> accountShareList = new List<AccountShare>();
        Map<ID, User> commUsersMap = new Map<ID, User>([SELECT ID, AccountId,
        												ContactId, UserName
        												FROM User 
        												WHERE ID IN : userIds
        											]);
        if(!commUsersMap.IsEmpty()){
        	AccountShare accntShr;
	        for(User u : commUsersMap.Values()){ 
	        	accntShr = new AccountShare();
		        accntShr.AccountAccessLevel = 'Edit';
		        accntShr.CaseAccessLevel = 'Edit';
		        //accntShr.ContactAccessLevel = 'Edit';
		        accntShr.OpportunityAccessLevel = 'Edit';
		        accntShr.AccountId = u.AccountId;
		        accntShr.UserOrGroupId =  u.Id;
		        accountShareList.add(accntShr);
	        }
        }
		if(!accountShareList.IsEmpty()){
			insert accountShareList;
		}        
		system.debug('Exiting createAccountShareForCommunityUsers ==> VOID ');
    }
}