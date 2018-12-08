/************************************************************************************************************
Name: CommunitySharingUpdServiceResource
=============================================================================================================
Purpose: Class to manage apex sharing of certificates with new Service Resource (when one Service Resource is replaces with onother one).
===============================================================================================================
History
-----------
VERSION    AUTHOR           DATE             DETAIL        DESCRIPTION
1.0        Vasu             22/06/2018       Created       Home Repair
*************************************************************************************************************/

public class CommunitySharingUpdServiceResource{
    /***************************************************************** 
    Purpose: Invocable Method called from the Process builder which controls Apex Managed Sharing.                                                      
    Parameters: Apex object type which captures WorkOrder and latest service resource from the process.
    Returns: none
    Throws [Exceptions]: None                                                          
    History                                                             
    --------                                                            
    VERSION        AUTHOR         DATE           DETAIL       Description 
    1.0            Vasu        22/06/2018        Created      Home Repair  
    *******************************************************************/
    @InvocableMethod
    public static void collectCertificatesForLatestTesters(List<CommunitySharingWrapper> workOrderList) {
        system.debug('WorkOrder: '+ workorderList);
        Map<WorkOrder, String> workOrderMap = new Map<WorkOrder, String>();
        for(CommunitySharingWrapper acsw : workOrderList) {
            if(acsw.updateType == 'Change'){
                workOrderMap.put(acsw.workorder,acsw.oldAccountId);
            }
        }
    }
}