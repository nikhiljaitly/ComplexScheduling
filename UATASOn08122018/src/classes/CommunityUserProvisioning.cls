/************************************************************************************************************
Name: CommunityUserProvisioning
=============================================================================================================
Purpose: Class which hosts the invocable method to be called a new contact is created for a community user upon 
Lead Conversion
===============================================================================================================
History
-----------
VERSION    AUTHOR           DATE             DETAIL        DESCRIPTION
1.0        Mathew         10/12/2017        Created       Trade PortalCommunity
*************************************************************************************************************/

public class CommunityUserProvisioning {

    /***************************************************************** 
    Purpose: Invocable Method called from the Process builder which controls post payment failure logic.
    Parameters: List of Apex object type which holds payment transaction status and payment transaction Id values.
    Returns: none
    Throws [Exceptions]: None                                                          
    History                                                             
    --------                                                            
    VERSION        AUTHOR         DATE           DETAIL       Description 
    1.0            Mathew        07/11/2017      Created     Smart Meter project  
    *******************************************************************/
    @InvocableMethod
    public static void collectContacts(List<ID> contactIds) {
        system.debug('Entering collectContacts: '+ 'contactIds: ' + contactIds);
        Map<ID, Contact> contactMap = new Map<ID, Contact>([SELECT ID, FirstName, LastName,
        													Email, AccountId, Account.Name,
        													Account.Owner.UserRoleId
        													FROM Contact
        													WHERE ID IN : contactIds]);
        system.debug('ContactMAPPPP'+contactMap);
		if(!contactMap.IsEmpty()){	
        	CommunityUserProvisioningService.createCommunityUsers(contactMap);
    	}
        system.debug('Exiting collectContacts => VOID');
    }
}