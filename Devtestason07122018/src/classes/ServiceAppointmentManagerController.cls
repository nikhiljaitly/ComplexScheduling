/***
 * Class Name:		ServiceAppointmentManagerController 
 * 
 * Author: 			Stephen Moss
 * Created Date:	07/08/2018
 * Description:		Controller for the lightning component ServiceAppointmentManager
 * 
***/

public class ServiceAppointmentManagerController {
    
    /*** 
     * Method Name:		getSADetails
     * Author:			Stephen Moss
     * Created Date:	07/08/2018
     * Description:		Get the details for the passed in Service Appointment Id
     ***/
    @AuraEnabled
	public static srvAppointmentWrapper getSADetails(Id srvAppointmentId) {
        List<ServiceAppointment> apptList = [SELECT Id, AppointmentNumber, Status, WorkTypeId, WorkType.Name, Subject, EarliestStartTime, 
                                            DueDate,  SchedStartTime, SchedEndTime, Service_Resource__c, Service_Resource__r.Name
                                            FROM ServiceAppointment
                                            WHERE Id = :srvAppointmentId
                                            LIMIT 1];
        if(!apptList.isEmpty()) {
            System.Debug(LoggingLevel.DEBUG, '***Found SA Details: ' + apptList[0]);
            System.Debug(LoggingLevel.DEBUG, '***Service Resource Id: ' + apptList[0].Service_Resource__c);
            System.Debug(LoggingLevel.DEBUG, '***Service Resource Name: ' + apptList[0].Service_Resource__r.Name);
            // create and return Wrapper object
            srvAppointmentWrapper rtnAppointment = new srvAppointmentWrapper(apptList[0]);
            return rtnAppointment;
        } else {
        	return null;    
        }
		
	}
    
    /*** 
     * Method Name:		updateSADetails
     * Author:			Stephen Moss
     * Created Date:	25/08/2018
     * Description:		Update the details for the passed in Service Appointment
     ***/
    @AuraEnabled
	public static srvUpdateResponseWrapper updateSADetails(Id srvAppointmentId,
                                                        String srvSubject,
                                                        DateTime srvEarlyStart,
                                                        DateTime srvDueDate) {
                                                            
        List<ServiceAppointment> apptList = [SELECT Id, AppointmentNumber, Status, WorkTypeId, WorkType.Name, Subject, EarliestStartTime, 
                                            DueDate,  SchedStartTime, SchedEndTime, Service_Resource__c, Service_Resource__r.Name
                                            FROM ServiceAppointment
                                            WHERE Id = :srvAppointmentId
                                            LIMIT 1];
        if(!apptList.isEmpty()) {
        	try {
            	// update the appointment
            	apptList[0].Subject = srvSubject;
                apptList[0].EarliestStartTime = srvEarlyStart;
                apptList[0].DueDate = srvDueDate;
                update apptList[0];
				srvUpdateResponseWrapper rspSuccess = new srvUpdateResponseWrapper();
            	rspSuccess.updateStatus = 'SUCCESS';
            	rspSuccess.updateMessage = 'Appointment Successfully Updated';
                srvAppointmentWrapper rtnAppointment = new srvAppointmentWrapper(apptList[0]);
                rspSuccess.updatedAppointment = rtnAppointment;
            	return rspSuccess;                                                                
        	} catch (Exception e) {
            	srvUpdateResponseWrapper rspException = new srvUpdateResponseWrapper();
            	rspException.updateStatus = 'ERROR';
            	rspException.updateMessage = e.getMessage();
            	return rspException;
        	}
        } else {
            srvUpdateResponseWrapper rspEmptyList = new srvUpdateResponseWrapper();
           	rspEmptyList.updateStatus = 'ERROR';
            rspEmptyList.updateMessage = 'Service Appointment ' + srvAppointmentId + ' NOT FOUND'; 
            return rspEmptyList;
        }
                                                            
                                                            
        
        
        /*List<ServiceAppointment> apptList = [SELECT Id, AppointmentNumber, Status, WorkTypeId, WorkType.Name, Subject, EarliestStartTime, 
                                            DueDate,  SchedStartTime, SchedEndTime, Service_Resource__c, Service_Resource__r.Name
                                            FROM ServiceAppointment
                                            WHERE Id = :srvAppointmentId
                                            LIMIT 1];
        if(!apptList.isEmpty()) {
            System.Debug(LoggingLevel.DEBUG, '***Found SA Details: ' + apptList[0]);
            System.Debug(LoggingLevel.DEBUG, '***Service Resource Id: ' + apptList[0].Service_Resource__c);
            System.Debug(LoggingLevel.DEBUG, '***Service Resource Name: ' + apptList[0].Service_Resource__r.Name);
            // create and return Wrapper object
            srvAppointmentWrapper rtnAppointment = new srvAppointmentWrapper(apptList[0]);
            return rtnAppointment;
        } else {
        	return null;    
        }*/
		
	}
    
    /*** 
     * Method Name:		getSACandidates
     * Author:			Stephen Moss
     * Created Date:	07/08/2018
     * Description:		Get the candidates for the passed in Service Appointment Id
     ***/
    @AuraEnabled
    public static List<srvCandidateWrapper> getSACandidates(Id srvAppointmentId) {
        
         // FSL.GradeSlotsService class
		 // The GetGradedMatrix method returns a matrix of resource id's and graded time slots

		 Id serviceAppointmentId = srvAppointmentId;
		 ServiceAppointment sa = [select id, EarliestStartTime, DueDate from ServiceAppointment where Id=:serviceAppointmentId];
		 // Shouldn't hardcode Scheduling Policy...
         Id schedulingPolicyId=[select id from FSL__Scheduling_Policy__c where Name='Customer First' limit 1].Id;
		 // Generate the graded time slots for the service appointment 
		 FSL.GradeSlotsService mySlotService = new FSL.GradeSlotsService(schedulingPolicyId,serviceAppointmentId);
		 // Store the matrix of service resource id's and graded time slots
		 FSL.AdvancedGapMatrix myResultMatrix = mySlotService.GetGradedMatrix(true);
		 Map<Id,FSL.ResourceScheduleData> mySRGradedTimeSlotMap = myResultMatrix.ResourceIDToScheduleData;
		 for (id thisresourceid : mySRGradedTimeSlotMap.keySet()){
  		 	 for (FSL.SchedulingOption thisso : mySRGradedTimeSlotMap.get(thisresourceid).SchedulingOptions ) {
    			 system.debug('***** Resource id' + thisresourceid);
    			 system.debug('***** Start - ' + thisso.Interval.Start);
    			 system.debug('***** Finish - ' + thisso.Interval.Finish);
    			 system.debug('****** Grade - ' + thisso.Grade); 
  			 }
        }
        
        // Get Service Resource Details
        List<ServiceResource> resourceList = [SELECT Id, Name, IsCapacityBased
                                              FROM ServiceResource
                                              WHERE Id IN :mySRGradedTimeSlotMap.keySet()];
        
        // Now Build the Return Dataset
		List<srvCandidateWrapper> rtnCandidates = new List<srvCandidateWrapper>();
        for (ServiceResource s : resourceList) {
            srvCandidateWrapper sc = new srvCandidateWrapper();
            sc.serviceResourceId = s.Id;
            sc.serviceResourceName = s.Name;
            sc.isCapacityBased = s.IsCapacityBased;
            for (FSL.SchedulingOption thisso : mySRGradedTimeSlotMap.get(s.Id).SchedulingOptions ) {
                srvCandidateSlotWrapper apptSlot = new srvCandidateSlotWrapper();
                apptSlot.slotStart = thisso.Interval.Start;
                apptSlot.slotFinish = thisso.Interval.Finish;
                apptSlot.slotGrade = String.valueOf(thisso.Grade);
                sc.appointmentSlots.add(apptSlot);
            }
            rtnCandidates.add(sc);
        }
        
        return rtnCandidates;    
    }
    
    /*** 
     * Method Name:		scheduleAppointmentForCandidate
     * Author:			Stephen Moss
     * Created Date:	09/08/2018
     * Description:		Schedule an Appointment for a specified candidate
     ***/
    @AuraEnabled
    public static srvScheduleResponseWrapper scheduleAppointmentForCandidate(Id srvAppointmentId, Id srvResourceId, Long apptStartTime) {
        System.Debug(LoggingLevel.DEBUG, '***Service Appointment Id = ' + srvAppointmentId);
        System.Debug(LoggingLevel.DEBUG, '***Service Resource Id = ' + srvResourceId);
        System.Debug(LoggingLevel.DEBUG, '***Start Time (ms) = ' + apptStartTime);
        DateTime srvApptStartTimeGMT = DateTime.newInstance(apptStartTime);
        System.Debug(LoggingLevel.DEBUG, '***Start Time (GMT DateTime) = ' + srvApptStartTimeGMT);
        System.Debug(LoggingLevel.DEBUG, '***Start Date/Time (Local) = ' + srvApptStartTimeGMT.format());
        
        // find the Service Appointment
        List<ServiceAppointment> srvList = [SELECT Id, Duration, DurationType, Status, SchedStartTime, SchedEndTime
                                            FROM ServiceAppointment
                                            WHERE Id = :srvAppointmentId];
        if (!srvList.isEmpty()) {
            
            try {
                // update Status, Scheduled Start and Scheduled Finish on Service Appointment
            	ServiceAppointment s = srvList[0];
            	s.Status = 'Scheduled';
            	s.SchedStartTime = srvApptStartTimeGMT;
            	Integer numMinutes = 0;
            	if (s.DurationType == 'Hours') {
                	numMinutes = Integer.valueOf((s.Duration * 60).round());
                	s.SchedEndTime = srvApptStartTimeGMT.addMinutes(numMinutes);
            	} else {
                	// convert Minutes to seconds
                	numMinutes = Integer.valueOf((s.Duration).round());
                	s.SchedEndTime = srvApptStartTimeGMT.addMinutes(numMinutes);
            	}
            	update s;
            
            	// check if there is an existing Resource Assignment Record, if not create it
            	List<AssignedResource> assignedResourceList = [SELECT Id, ServiceResourceId, ServiceAppointmentId
                                                           FROM AssignedResource
                                                           WHERE ServiceAppointmentId = :srvAppointmentId
                                                           LIMIT 1];
            	if (!assignedResourceList.isEmpty()) {
                	// update existing
                	AssignedResource a = assignedResourceList[0];
                	a.ServiceResourceId = srvResourceId;
                	update a;
            	} else {
                	// create new
                	AssignedResource newAR = new AssignedResource();
                	newAR.ServiceAppointmentId = srvAppointmentId;
                	newAR.ServiceResourceId = srvResourceId;
                	insert newAR;
            	}
            	
                srvScheduleResponseWrapper rspSuccess = new srvScheduleResponseWrapper();
                rspSuccess.schedulingStatus = 'SUCCESS';
                rspSuccess.schedulingMessage = 'Appointment Successfully Scheduled';
                return rspSuccess;
            } catch (Exception e) {
                srvScheduleResponseWrapper rspException = new srvScheduleResponseWrapper();
                rspException.schedulingStatus = 'ERROR';
                rspException.schedulingMessage = e.getMessage();
                return rspException;
            }
            
        } else {
         	System.Debug(LoggingLevel.ERROR, '***[ServiceAppointmentManagerController.scheduleAppointmentForCandidate] Could not find existing Service Appointment Id: ' + srvAppointmentId);
            	srvScheduleResponseWrapper rspError = new srvScheduleResponseWrapper();
            	rspError.schedulingStatus = 'ERROR';
                rspError.schedulingMessage = 'Appointment ' + srvAppointmentId + ' could not be found in the system.';
                return rspError;
        }
    }
    
    
    /***
     * Private Wrapper Classes for simplifying return JSON payloads
     ***/
    
    
    /*** 
     * Class Name:		srvAppointmentWrapper
     * Author:			Stephen Moss
     * Created Date:	07/08/2018
     * Description:		Wrapper Class for Service Appointment JSON to be returned to
     * 					Lightning Component
     ***/
    private class srvAppointmentWrapper {
        
        // default no argument constructor
        // if you want to map fields manually
        private srvAppointmentWrapper() {
            
        }
        
        // constructor to map a Service Appointment to the wrapper
        // automatically upon creation
        private srvAppointmentWrapper(ServiceAppointment srvAppt) {
            
            // default time and date if a field is empty
            DateTime defaultDT = DateTime.newInstanceGmt(2000, 01, 01);
            
            this.Id = srvAppt.Id;
            this.appointmentNumber = srvAppt.AppointmentNumber;
            this.status = srvAppt.Status;
            this.workTypeId = srvAppt.WorkTypeId;
            this.workTypeName = srvAppt.WorkType.Name;
            
            if (srvAppt.Subject != null) {
            	this.subject = srvAppt.Subject;    
            } else {
                this.subject = '';
            }
            
            this.earliestStart = srvAppt.EarliestStartTime;
            this.dueDate = srvAppt.DueDate;
            
            if (srvAppt.SchedStartTime != null) {
                this.scheduledStartTime = srvAppt.SchedStartTime;
             } else {
                this.scheduledStartTime = defaultDT;
             }
            if (srvAppt.SchedEndTime != null) {
                this.scheduledFinishTime = srvAppt.SchedEndTime;
            } else {
                this.scheduledFinishTime = defaultDT;
            }

            if (srvAppt.Service_Resource__c != null) {
                this.serviceResourceId = srvAppt.Service_Resource__c;
            } else {
                this.serviceResourceId = '[Not Assigned]';
            }

            if (srvAppt.Service_Resource__r.Name != null) {
            	this.serviceResourceName = srvAppt.Service_Resource__r.Name;    
            } else {
                this.serviceResourceName = '[Not Assigned]';
            }
            
        }
        
        // Wrapper Class Properties
        @AuraEnabled
        String Id { get; set; }
        @AuraEnabled
        String appointmentNumber { get; set; }
        @AuraEnabled
        String status { get; set; }
        @AuraEnabled
        String workTypeId { get; set; }
        @AuraEnabled
        String workTypeName { get; set; }
        @AuraEnabled
        String subject { get; set; }
        @AuraEnabled
        DateTime earliestStart { get; set; }
        @AuraEnabled
        DateTime dueDate { get; set; }
        @AuraEnabled
        DateTime scheduledStartTime { get; set; }
        @AuraEnabled
        DateTime scheduledFinishTime { get; set; }
        @AuraEnabled
        String serviceResourceId { get; set; }
        @AuraEnabled
        String serviceResourceName { get; set; }
    }
    
    /*** 
     * Class Name:		srvCandidateWrapper
     * Author:			Stephen Moss
     * Created Date:	07/08/2018
     * Description:		Wrapper Class for Service Appointment Candidate JSON to be returned to
     * 					Lightning Component
     ***/
    private class srvCandidateWrapper {
        
        // default no argument constructor
        private srvCandidateWrapper() {
            appointmentSlots = new List<srvCandidateSlotWrapper>();
        }
        
        // Wrapper Class Properties
        @AuraEnabled
        Id serviceResourceId { get; set; }
        @AuraEnabled
        String serviceResourceName { get; set; }
        @AuraEnabled
        Boolean isCapacityBased { get; set; }
        @AuraEnabled
        List<srvCandidateSlotWrapper> appointmentSlots { get; set; }
        
    }
    
    /*** 
     * Class Name:		srvCandidateSlotWrapper
     * Author:			Stephen Moss
     * Created Date:	07/08/2018
     * Description:		Wrapper Class for Service Appointment Candidate Slot
     ***/
    private class srvCandidateSlotWrapper {
        
        // default no argument constructor
        private srvCandidateSlotWrapper() {
            
        }
        
        // Wrapper Class Properties
        @AuraEnabled
        DateTime slotStart { get; set; }
        @AuraEnabled
        DateTime slotFinish { get; set; }
        @AuraEnabled
        String slotGrade { get; set; }
                
    }
    
    
    /*** 
     * Class Name:		srvScheduleResponseWrapper
     * Author:			Stephen Moss
     * Created Date:	09/08/2018
     * Description:		Wrapper Class for response from Service
     * 					Appointment Scheduling Request
     ***/
    private class srvScheduleResponseWrapper {
        
        // default no argument constructor
        private srvScheduleResponseWrapper() {
            
        }
        
        // Wrapper Class Properties
        @AuraEnabled
        String schedulingStatus { get; set; }
        @AuraEnabled
        String schedulingMessage { get; set; }
    }
    
    /*** 
     * Class Name:		srvUpdateResponseWrapper
     * Author:			Stephen Moss
     * Created Date:	27/08/2018
     * Description:		Wrapper Class for response from Service
     * 					Appointment Update Request
     ***/
    private class srvUpdateResponseWrapper {
        
        // default no argument constructor
        private srvUpdateResponseWrapper() {
            updatedAppointment = new srvAppointmentWrapper();
        }
        
        // Wrapper Class Properties
        @AuraEnabled
        String updateStatus { get; set; }
        @AuraEnabled
        String updateMessage { get; set; }
        @AuraEnabled
        srvAppointmentWrapper updatedAppointment { get; set; }
    }
    

}