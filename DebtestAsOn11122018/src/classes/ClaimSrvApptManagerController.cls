/***
 * Class Name:		ClaimSrvApptManagerController 
 * 
 * Author: 			Stephen Moss
 * Created Date:	09/08/2018
 * Description:		Controller for the lightning component ClaimSrvApptManager
 * 
***/
public class ClaimSrvApptManagerController {
    
    /*** 
     * Method Name:		getSADetails
     * Author:			Stephen Moss
     * Created Date:	07/08/2018
     * Description:		Get the details for the passed in Service Appointment Id
     ***/
    @AuraEnabled
	public static List<workOrderWrapper> getClaimServiceData(Id claimId) {
        List<WorkOrder> workOrderList = [SELECT Id, Status, WorkTypeId, WorkType.Name, CaseId, WorkOrderNumber
                                            FROM WorkOrder
                                            WHERE CaseId = :claimId
                                            ORDER BY WorkOrderNumber];
        if(!workOrderList.isEmpty()) {
            
            // build a set to use for getting Service Appointments
            Set<Id> woIdSet = new Set<Id>();
            for (WorkOrder w : workOrderList) {
                woIdSet.add(w.Id);
            }
            
            List<ServiceAppointment> saList = [SELECT Id, Status, Subject, ParentRecordId, AppointmentNumber
                                               FROM ServiceAppointment
                                               WHERE ParentRecordId IN :woIdSet
                                               ORDER BY AppointmentNumber];
            
            // Build the return payload
            List<workOrderWrapper> returnWOList = new List<workOrderWrapper>();
            for (WorkOrder w1 : workOrderList) {
                workOrderWrapper woWrapper = new workOrderWrapper();
                woWrapper.workOrderId = w1.Id;
                woWrapper.workOrderNumber = w1.WorkOrderNumber;
                woWrapper.workTypeName = w1.workType.Name;
                woWrapper.workOrderStatus = w1.Status;
                if (!saList.isEmpty()) {
                    for (ServiceAppointment s : saList) {
                        if (s.ParentRecordId == w1.Id) {
                            srvApptWrapper saWrapper = new srvApptWrapper();
                            saWrapper.srvApptId = s.Id;
                            saWrapper.srvApptNumber = s.AppointmentNumber;
                            saWrapper.srvApptStatus = s.Status;
                            saWrapper.srvApptSubject = s.Subject;
                            woWrapper.srvAppointments.add(saWrapper);
                        }
                    }
                }
                returnWOList.add(woWrapper);
            }
            
			
            return returnWOList;
        } else {
        	// no Work Orders for Claim
            return null;    
        }
	}
    
    
    
    
    /*** 
     * Class Name:		workOrderWrapper
     * Author:			Stephen Moss
     * Created Date:	09/08/2018
     * Description:		Wrapper Class for Work Order JSON to be returned to
     * 					Lightning Component
     ***/
    private class workOrderWrapper {
        
        // default no argument constructor
        private workOrderWrapper() {
            srvAppointments = new List<srvApptWrapper>();
        }
        
        // Wrapper Class Properties
        @AuraEnabled
        Id workOrderId { get; set; }
        @AuraEnabled
        String workOrderNumber { get; set; }
        @AuraEnabled
        String workTypeName { get; set; }
        @AuraEnabled
        String workOrderStatus { get; set; }
        @AuraEnabled
        List<srvApptWrapper> srvAppointments { get; set; }
        
    }
    
    /*** 
     * Class Name:		srvApptWrapper
     * Author:			Stephen Moss
     * Created Date:	09/08/2018
     * Description:		Wrapper Class for Service Appointment
     ***/
    private class srvApptWrapper {
        
        // default no argument constructor
        private srvApptWrapper() {
            
        }
        
        // Wrapper Class Properties
        @AuraEnabled
        Id srvApptId { get; set; }
        @AuraEnabled
        String srvApptNumber { get; set; }
        @AuraEnabled
        String srvApptStatus { get; set; }
        @AuraEnabled
        String srvApptSubject { get; set; }
                
    }

}