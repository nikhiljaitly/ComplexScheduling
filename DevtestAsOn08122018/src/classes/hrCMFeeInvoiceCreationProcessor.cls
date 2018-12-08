/************************************************************************************************************
Name: hrCMFeeInvoiceCreationProcessor
=============================================================================================================
Purpose: Class which hosts the invocable method to be called for Invoice Creation from WorkOrder.
===============================================================================================================
History
-----------
VERSION    AUTHOR           DATE             DETAIL        DESCRIPTION
1.0        xx	         	xxx        		 Created        HomeRepair - Finance Module
*************************************************************************************************************/

public with sharing class hrCMFeeInvoiceCreationProcessor {
    /***************************************************************** 
    Purpose: Invocable Method called from the Process builder which controls invoice creation logic.                                                     
    Parameters: List of Apex object type which holds claimjobId and claimjobStatus values.
    Returns: none
    Throws [Exceptions]: None                                                          
    History                                                             
    --------                                                            
   VERSION    AUTHOR            DATE             DETAIL            DESCRIPTION
	1.0        xx	         	xxx        		 Created        HomeRepair - Finance Module  
    ****************************************************************************************/
	@InvocableMethod
    public static void collectWorkOrder(List<homeRepairCMFeeClaimJobDetailsWrapper> claimJobDetails) {
        Map<Id,String> claimJobMap = new Map<Id,String>();
        for(homeRepairCMFeeClaimJobDetailsWrapper cj : claimJobDetails) {
            claimJobMap.put(cj.claimjobId, cj.claimjobStatus);          
            
        }
        hrCMFeeInvoiceCreationService.createInvoiceRecord(claimJobMap);
    }
    
}