public class CP_ClaimAppointmentsController {
      
	Static Map<Id,WorkOrder> woMap = new Map<Id,WorkOrder>();
    
    /*** 
     * Method Name:		getSADetails
     * Author:			Stephen Moss
     * Created Date:	07/08/2018
     * Description:		Get the details for the passed in Service Appointment Id
     ***/

    @AuraEnabled
	public static String getClaimServiceData(Id claimId) {

        //Fetch all the Claim related Work order
        woMap = new Map<Id,WorkOrder>();
        For(WorkOrder trade : [SELECT Id, Status, WorkTypeId, WorkType.Name, CaseId, WorkOrderNumber
                                 FROM WorkOrder
                                WHERE CaseId = :claimId
                             ORDER BY WorkOrderNumber
                                Limit 200]){
            woMap.put(trade.Id,trade);
        }
        if(!woMap.isEmpty()) {
            Set<Id> appointmentWorkOrderSet = new Set<Id>();
            // Query all related Service Appointments
 			List<ClaimWorkWrapper> returnWOList = new List<ClaimWorkWrapper>();
            for(ServiceAppointment sa : [SELECT Id, Status,ParentRecordId, AppointmentNumber, Sort_Order__c,SchedStartTime, SchedEndTime,DurationInMinutes,
                                               	EarliestStartTime, DueDate, Service_Resource__r.Name,
                                             	(Select Product2.Name 
                                                   From Work_Order_Line_Items__r)
                                           FROM ServiceAppointment
                                          WHERE ParentRecordId IN :woMap.keySet()
                                       ORDER BY Sort_Order__c NULLS LAST
                                          Limit 500]){                              
                returnWOList.add(new ClaimWorkWrapper(sa,woMap.get(sa.ParentRecordId)));	
                appointmentWorkOrderSet.add(sa.ParentRecordId);
            }
            
            for(String workOrderId : woMap.keySet()){
                if(!appointmentWorkOrderSet.contains(workOrderId))
                	returnWOList.add(new ClaimWorkWrapper(Null,woMap.get(workOrderId)));
            }            
            
            return JSON.serialize(returnWOList);
        } 
        else {
            // no Work Orders for Claim
            return null;    
        }
	}

    /*** 
     * Class Name:		ClaimWorkWrapper
     * Author:			Devendra Dhaka
     * Created Date:	09/08/2018
     * Description:		Wrapper Class for Work Order JSON to be returned to
     * 					Lightning Component
     ***/
    Public class ClaimWorkWrapper {
        // Wrapper Class Properties
        String workOrderId;
        String appointmentId;
        String workOrderNumber;
        String workTypeName;
        String appointmentNumber;
        String appointmentDuration;
        String appointmentStatus;
        List<WorkScopeWrapper> workScopeList;
        
        Public ClaimWorkWrapper(ServiceAppointment sa, WorkOrder trade){
            
            this.appointmentDuration = '0 Hours';
            this.appointmentNumber = 'Appointment not created';
            if(sa!=Null){
            	this.appointmentNumber = sa.AppointmentNumber;
                this.appointmentDuration = getTimeEntry(sa.DurationInMinutes);
                this.appointmentStatus = sa.Status;
                this.appointmentId = sa.Id;	
                
                if(sa.Work_Order_Line_Items__r!=Null){
                    this.workScopeList = new List<WorkScopeWrapper>();
                    for(WorkOrderLineItem work : sa.Work_Order_Line_Items__r){
                        this.workScopeList.add(new WorkScopeWrapper(work));
                    }    
                }
            }
        	this.workOrderId = trade.Id;
            this.workOrderNumber = trade.WorkOrderNumber;
            this.workTypeName = trade.workType.Name;
      
        }
        
        Private String getTimeEntry(Decimal durationInMinutes){
            if(durationInMinutes == Null)
                return '0 Minutes';
            
            Integer hours = Integer.valueOf( durationInMinutes / 60 );
            Integer mins = Integer.valueOf( durationInMinutes - hours*60 );
           // return hours+' Hours '+mins+' Minutes';
           return hours+' Hours ';
        }
    }
    
    /*** 
     * Class Name:		WorkScopeWrapper
     * Author:			Devendra Dhaka
     * Created Date:	09/08/2018
     * Description:		Wrapper Class for WOLIs
     ***/
    Public class WorkScopeWrapper {
        String productName;
        Public WorkScopeWrapper(WorkOrderLineItem workItem){
            this.productName = workItem.Product2.Name;
        }          
    }
}