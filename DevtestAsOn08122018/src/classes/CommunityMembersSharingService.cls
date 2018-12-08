/************************************************************************************************************
=============================================================================================================
Purpose: Class with re-usable methods which manages sharing access for Community Members
===============================================================================================================
History
-------------------------------------------------------------------------------------
VERSION    AUTHOR           DATE             DETAIL        DESCRIPTION
1.0        Vasu            21/06/2018        Created       HR Claim system
*************************************************************************************************************/
public class CommunityMembersSharingService { 
    /***************************************************************** 
    Purpose: To grant access to Community members
    Parameters: 
    Returns: None
    Throws [Exceptions]: Yes                                                           
    History                                                             
    --------                                                            
    VERSION        AUTHOR         DATE           DETAIL       Description 
    1.0            Vasu        21/06/2018        Created     HR Claim system 
    *******************************************************************/   
    public static void grantAccessToCommunityMembers(Map<WorkOrder,String> certficateToTester){
        Map<String, String> accountToUserMap = new Map<String, String>();
        List<WorkOrderShare> workOrderShareList = new List<WorkOrderShare>();
        for(User u : [Select ID,AccountId From User where AccountId IN : certficateToTester.Values()]){
            accountToUserMap.put(u.AccountId, u.Id);
        }   
   }
}