public class NJ_ClaimAppointmentsController {
      
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
        For(WorkOrder trade : [SELECT Id, Status, WorkTypeId, WorkType.Name, CaseId, WorkOrderNumber,Case.CaseNumber
                                 FROM WorkOrder
                                WHERE CaseId = :claimId
                             ORDER BY WorkOrderNumber
                                Limit 200]){
            woMap.put(trade.Id,trade);
            System.debug('Work Order:'+' '+trade);
            System.debug('Claim Number:'+trade.Case.CaseNumber);                        
            System.debug('WOMAP:'+' '+woMap);                        
        }
        if(!woMap.isEmpty()) {
            Set<Id> appointmentWorkOrderSet = new Set<Id>();
            // Query all related Service Appointments
 			List<ClaimWorkWrapper> returnWOList = new List<ClaimWorkWrapper>();
            for(ServiceAppointment sa : [SELECT Id, Status,ParentRecordId, AppointmentNumber, Sort_Order__c,SchedStartTime, SchedEndTime,DurationInMinutes,
                                               	EarliestStartTime, DueDate, Service_Resource__r.Name, Claim__c, Claim__r.Claim_Number__c,Claim__r.CaseNumber,
                                             	(Select Product2.Name, Product_Description__c
                                                   From Work_Order_Line_Items__r WHERE Cash_Settled__c != True)
                                           FROM ServiceAppointment
                                          WHERE ParentRecordId IN :woMap.keySet()
                                       ORDER BY Sort_Order__c ASC NULLS LAST
                                          Limit 500]){                              
                
               	returnWOList.add(new ClaimWorkWrapper(sa,woMap.get(sa.ParentRecordId)));	
                appointmentWorkOrderSet.add(sa.ParentRecordId);
                System.debug('Sort Order'+sa.Sort_Order__c);
                System.debug('Service Appointment'+sa); 
                System.debug('ClaimNumber'+sa.Claim__r.CaseNumber);                              
                System.debug('ClaimWorkWrapper'+returnWOList);                              
            }
            
            for(String workOrderId : woMap.keySet()){
                if(!appointmentWorkOrderSet.contains(workOrderId))
                	returnWOList.add(new ClaimWorkWrapper(Null,woMap.get(workOrderId)));
                	System.debug('WOLIST in for loop'+returnWOList);
            }            
            
            System.debug('WOLIST:'+returnWOList);
            return JSON.serialize(returnWOList);
            
        } 
        else {
            // no Work Orders for Claim
            System.debug('Is It else ?');
            return null;    
        }
	}

    //this method is for getting the ClaimNumber to be shown on ClaimAppointments section.
  /*  @AuraEnabled
	public static ClaimNumberWrapper getClaimNumber(Id claimId) {
      
      ClaimNumberWrapper caseForNumber = new ClaimNumberWrapper();
      List<Case> sampleCase = [SELECT Id, CaseNumber FROM Case WHERE ID = :claimId];
      
      String caseNumber = sampleCase[0].CaseNumber;
      String claimHead = 'Claim Appopintments'+' - '+caseNumber;  
        
      caseForNumber.claimHeader = claimHead ;
      System.debug('ClaimHeader'+caseForNumber.claimHeader) ; 
       
      return caseForNumber;
    } */
    
     /*** 
     * Class Name:		ClaimNumberWrapper
     * Author:			Nikhil Jaitly
     * Created Date:	02/11/2018
     * Description:		Wrapper Class for ClaimNumber
     * 					
     ***/
 /*   Public class ClaimNumberWrapper {
        // Wrapper Class Properties
    List<Case> claimno;
    String claimNumberPre;
    String claimHeader;  
        
        public ClaimNumberWrapper(Id claimId){
            
      List<Case> sampleCase = [SELECT Id, CaseNumber FROM Case WHERE ID = :claimId];
      
      String caseNumber = sampleCase[0].CaseNumber;
      String claimHead = 'Claim Appopintments'+' - '+caseNumber;  
        
      this.claimHeader = claimHead ;
        }
   
    }   */
    
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
        String claimNumber;
        List<WorkScopeWrapper> workScopeList;
        
        Public ClaimWorkWrapper(ServiceAppointment sa, WorkOrder trade){
           // System.debug('CaseNumber'+sa.Claim__r.CaseNumber);
            if(sa != null && sa.Claim__c != null) {
                this.claimNumber = sa.Claim__r.CaseNumber;
            }
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
        
        public String getTimeEntry(Decimal durationInMinutes){
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
        String prodDescription;
        Public WorkScopeWrapper(WorkOrderLineItem workItem){
            this.productName = workItem.Product2.Name;
            this.prodDescription = workItem.Product_Description__c;
        }          
    }
}