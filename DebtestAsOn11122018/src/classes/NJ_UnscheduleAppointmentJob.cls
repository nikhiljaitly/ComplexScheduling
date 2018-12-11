/**
 * This class is used to unschedule service appointment if their status is not changed in 2 hours
 * @CreatedDate : 06/11/2018
 * @CreatedBy : Nikhil Jaitly
 */
public class NJ_UnscheduleAppointmentJob implements Schedulable {
	 public static final Integer STATUS_CHANGE_THRESHOLD = 2;
	 /**
	 * Execute method of the schedulable class
	 * @CreatedDate : 06/11/2018
	 * @CreatedBy : Nikhil Jaitly
	 */
   public void execute(SchedulableContext SC) {
   	DateTime currentTime = DateTime.now();
   	Decimal timeDiff;
   	List<ServiceAppointment> svAppointsUpdate = new List<ServiceAppointment>();
   	for(ServiceAppointment sa : [SELECT Id, Status_Change_to_Tentative__c
   															 FROM ServiceAppointment
   															 WHERE Status = :NJ_Constants.SA_STATUS_TENTATIVE
   															 AND Status_Change_to_Tentative__c != null
                                							 AND Work_Type_Name__c !='Assessment']) {
   		timeDiff = (currentTime.getTime() - sa.Status_Change_to_Tentative__c.getTime())/(1000.0 * 60.0 * 60.0);
   		if(timeDiff > STATUS_CHANGE_THRESHOLD) {
   			svAppointsUpdate.add(new ServiceAppointment(Id = sa.Id, Status = NJ_Constants.SA_STATUS_NEW,
   																									Service_Resource__c = null, Committed_Start_Date__c = null,
   																									Committed_End_Date__c = null, SchedStartTime = null,
   																									SchedEndTime = null, Tier_2_Trade_Account__c = null
   																									));
   		}
   	}
   	if(!svAppointsUpdate.isEmpty()) {
   		update svAppointsUpdate;
   	}
   }

   /*public static void test() {
   	DateTime currentTime = DateTime.now();
   	Decimal timeDiff;
   	List<ServiceAppointment> svAppointsUpdate = new List<ServiceAppointment>();
   	for(ServiceAppointment sa : [SELECT Id, Status_Change_to_Tentative__c
   															 FROM ServiceAppointment
   															 WHERE Status = :NJ_Constants.SA_STATUS_TENTATIVE
   															 AND Status_Change_to_Tentative__c != null]) {
   		timeDiff = (currentTime.getTime() - sa.Status_Change_to_Tentative__c.getTime())/(1000.0 * 60.0 * 60.0);
   		if(timeDiff > STATUS_CHANGE_THRESHOLD) {
   			svAppointsUpdate.add(new ServiceAppointment(Id = sa.Id, Status = NJ_Constants.SA_STATUS_NEW,
   																									Service_Resource__c = null, Committed_Start_Date__c = null,
   																									Committed_End_Date__c = null, SchedStartTime = null,
   																									SchedEndTime = null
   																									));
   		}
   	}
   	if(!svAppointsUpdate.isEmpty()) {
   		update svAppointsUpdate;
   	}
   }*/

}