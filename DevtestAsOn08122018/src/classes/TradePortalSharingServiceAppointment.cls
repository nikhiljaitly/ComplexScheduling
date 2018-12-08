/************************************************************************************************************
Name: TradePortalSharingWrapper
=============================================================================================================
Purpose: Class to manage apex sharing of certificates with new Service Resource (when one Service Resource is replaces with onother one).
===============================================================================================================
History
-----------
VERSION    AUTHOR           DATE             DETAIL        DESCRIPTION
1.0        Vasu             22/06/2018       Created       Home Repair
*************************************************************************************************************/

public class TradePortalSharingServiceAppointment{
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
    public static void TradePortalSharingServiceAppointment(List<TradePortalSharingWrapper> serviceAppointmentList) {
        system.debug('ServiceAppointmentList: '+ serviceAppointmentList);
        Map<Id, String> serviceAppointmentMap = new Map<Id, String>();
        for(TradePortalSharingWrapper sa : serviceAppointmentList) {
            if(sa.updateType == 'New'||sa.updateType == 'Update'){
                serviceAppointmentMap.put(sa.serviceAppointment.ParentRecordId,
                                          sa.serviceAppointment.Service_Resource__r.RelatedRecordId);
            }
        }
    }
}