public class CP_HRGanttChildController {

  
    /*** 
     * Method Name:		getClaimScheduledAppointments
     * Author:			Stephen Moss
     * Created Date:	13/08/2018
     * Description:		Get the Service Appointment details for the 
     * 					passed in Service Appointment Id where the SA
     * 					is at a stage of "Scheduled" or greater
     * 					in the lifecycle
     ***/
    @AuraEnabled
	public static String getClaimScheduledAppointments(Id claimId) {
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
            
            // Build the return payload
            List<SrvTradeWrapper> returnSAList = new List<SrvTradeWrapper>();
            // old criteria - WHERE (ParentRecordId IN :woIdSet) AND (Status != 'None')
            for(ServiceAppointment s : [SELECT Id, Status, Subject, ParentRecordId, AppointmentNumber,
                                               		WorkType.Name, SchedStartTime, SchedEndTime,DurationInMinutes,
                                               		EarliestStartTime, DueDate,
                                               		Service_Resource__r.Name, Duration ,DurationType
                                          FROM ServiceAppointment
                                         WHERE (ParentRecordId IN :woIdSet)
                                      ORDER BY Sort_Order__c
                                         Limit 100]){

				// SA Details for Map
                srvApptWrapper saWrapper = new srvApptWrapper();
                saWrapper.srvApptId = s.Id;
                saWrapper.srvApptNumber = s.AppointmentNumber;
                saWrapper.srvApptStatus = s.Status;
                saWrapper.srvApptSubject = s.Subject;
                saWrapper.workTypeName = s.workType.Name;
                saWrapper.schedStart = s.SchedStartTime;
                saWrapper.schedFinish = s.SchedEndTime;
                saWrapper.earliestStart = s.EarliestStartTime;
                saWrapper.dueDate = s.DueDate;
                saWrapper.assignedToName = s.Service_Resource__r.Name;
                                             
                System.Debug(LoggingLevel.DEBUG, '***saWrapper = ' + saWrapper);
                                             
                SrvTradeWrapper tradeWrapper = new SrvTradeWrapper();
                tradeWrapper.srvAppt = saWrapper;
                tradeWrapper.workHeader = s.WorkType.Name + ' - '+s.AppointmentNumber + ' - '+getTimeEntry(s.DurationInMinutes);
                returnSAList.add(tradeWrapper);                
            }

            
            return JSON.serialize(returnSAList);
        } else {
        	// no Work Orders for Claim
            return null;    
        }
	}
    
    Private Static String getTimeEntry(Decimal durationInMinutes){
        if(durationInMinutes == Null)
            return '0 Minutes';
            
        Integer hours = Integer.valueOf( durationInMinutes / 60 );
        Integer mins = Integer.valueOf( durationInMinutes - hours*60 );
        return hours+' Hours '+mins+' Minutes';
    }
    
    
    /*** 
     * Class Name:		srvTradeWrapper
     * Author:			Stephen Moss
     * Created Date:	09/08/2018
     * Description:		Wrapper Class for Service Appointment return list
     ***/
    private class SrvTradeWrapper {
        String workHeader;
        SrvApptWrapper srvAppt;           
    }

    /*** 
     * Class Name:		srvApptWrapper
     * Author:			Stephen Moss
     * Created Date:	09/08/2018
     * Description:		Wrapper Class for Service Appointment
     ***/
    private class srvApptWrapper {
        // Wrapper Class Properties
        Id srvApptId;
        String srvApptNumber;
        String srvApptStatus;
        String srvApptSubject;
        String workTypeName;
        String assignedToName;
        DateTime schedStart;
        DateTime schedFinish;
        DateTime earliestStart;
        DateTime dueDate;
    }
}