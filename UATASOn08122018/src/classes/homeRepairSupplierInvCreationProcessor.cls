/************************************************************************************************************
Name: homeRepairSupplierInvCreationProcessor
=============================================================================================================
Purpose: Class which hosts the invocable method to be called for Invoice Creation from WorkOrder.
===============================================================================================================
History
-----------
VERSION    AUTHOR           DATE             DETAIL        DESCRIPTION
1.0        xx	         	xxx        		 Created        HomeRepair - Finance Module
*************************************************************************************************************/

public with sharing class homeRepairSupplierInvCreationProcessor {
    /***************************************************************** 
    Purpose: Invocable Method called from the Process builder which controls invoice creation logic.                                                     
    Parameters: List of Apex object type which holds workorderNumber and workorderStatus values.
    Returns: none
    Throws [Exceptions]: None                                                          
    History                                                             
    --------                                                            
   VERSION    AUTHOR            DATE             DETAIL            DESCRIPTION
	1.0        xx	         	xxx        		 Created        HomeRepair - Finance Module  
    ****************************************************************************************/
	@InvocableMethod
    public static void collectWorkOrder(List<homeRepairSupplierWODetailsWrapper> workOrderDetails) {
        Map<Id,String> workorderMap = new Map<Id,String>();
        for(homeRepairSupplierWODetailsWrapper wo : workOrderDetails) {
            workorderMap.put(wo.workorderId, wo.workorderStatus);          
            
        }
        system.debug('workorderMap: ' + workOrderMap);
    	 homeRepairSupplierInvCreationService.createInvoiceRecord(workorderMap);
    }
    
}