/***
 * Class Name:    ServiceAppointmentManagerController 
 * 
 * Author:      Stephen Moss
 * Created Date:  07/08/2018
 * Description:   Controller for the lightning component ServiceAppointmentManager
 * 
***/

public class NJ_ServiceAppointmentManagerController {
    
    /*** 
     * Method Name:   getSADetails
     * Author:      Stephen Moss
     * Created Date:  07/08/2018
     * Description:   Get the details for the passed in Service Appointment Id
     ***/
    @AuraEnabled
  public static srvAppointmentWrapper getSADetails(Id srvAppointmentId) {
        List<ServiceAppointment> apptList = [SELECT Id, AppointmentNumber, Status, WorkTypeId, WorkType.Name, Subject, EarliestStartTime, 
                                            DueDate,  SchedStartTime, SchedEndTime, Service_Resource__c, Service_Resource__r.Name, ParentRecordId,
                                            Claim__c, Committed_Start_Date__c, Committed_End_Date__c,Tier_2_Trade__r.Name, ServiceTerritory.Name,
                                            Tier_2_Trade_Account__r.Name, Is_Time_Bound__c, Service_Resource__r.IsCapacityBased
                                            FROM ServiceAppointment
                                            WHERE Id = :srvAppointmentId
                                            LIMIT 1];
        if(!apptList.isEmpty()) {
            List<WorkOrder> woList = [SELECT Id, Special_Instructions__c, Description, Special_Instructions_New__c
                                      FROM WorkOrder
                                      WHERE Id = :apptList[0].ParentRecordId];
            System.Debug(LoggingLevel.DEBUG, '***Found SA Details: ' + apptList[0]);
            System.Debug(LoggingLevel.DEBUG, '***Service Resource Id: ' + apptList[0].Service_Resource__c);
            System.Debug(LoggingLevel.DEBUG, '***Service Resource Name: ' + apptList[0].Service_Resource__r.Name);
            // create and return Wrapper object
            
            srvAppointmentWrapper rtnAppointment = new srvAppointmentWrapper(apptList[0], woList);
        
            return rtnAppointment;
        } else {
          return null;    
        }
    
  }
    
    /*** 
     * Method Name:   updateSADetails
     * Author:      Stephen Moss
     * Created Date:  25/08/2018
     * Description:   Update the details for the passed in Service Appointment
     ***/
    @AuraEnabled
  public static srvUpdateResponseWrapper updateSADetails(Id srvAppointmentId,
                                                        String srvSubject,
                                                        DateTime srvEarlyStart,
                                                        DateTime srvDueDate) {
                                                            
        List<ServiceAppointment> apptList = [SELECT Id, AppointmentNumber, Status, WorkTypeId, WorkType.Name, Subject, EarliestStartTime, 
                                            DueDate,  SchedStartTime, SchedEndTime, Service_Resource__c, Service_Resource__r.Name, ParentRecordId
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
                List<WorkOrder> woList = [SELECT Id, Special_Instructions__c, Description, Special_Instructions_New__c
                                          FROM WorkOrder
                                          WHERE Id = :apptList[0].ParentRecordId];
                srvAppointmentWrapper rtnAppointment = new srvAppointmentWrapper(apptList[0], woList);
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
     * Method Name:     updateWorkOrder
     * Author:          Nikhil 
     * Created Date:    27/10/2018
     * Description:     This method is used to update work orders
     ***/
    @AuraEnabled
    public static Boolean updateWorkOrder(String woId, String claimId, String specIns, String descr, Boolean applyAll, String saId, Boolean isTimeBound,
                                          DateTime commStartTime, DateTime commEndTime) {
        System.debug(' woId ' + woId + ' claimId ' + claimId + ' specIns '+ specIns + ' descr '+ descr + ' applyAll '+ applyAll);
        Boolean isSuccess = false;
        List<WorkOrder> woUpdate = new List<WorkOrder>();
        if(applyAll) {
            for(WorkOrder wo : [SELECT Id, Special_Instructions__c, Description,Special_Instructions_New__c 
                                FROM WorkOrder
                                WHERE Claim__c = :claimId]) {
                wo.Special_Instructions_New__c = specIns;
                wo.Description = descr;
                woUpdate.add(wo);
            }
        } else {
            woUpdate.add(new WorkOrder(Id = woId, Special_Instructions_New__c = specIns, Description = descr));
        }

        try {
            update woUpdate;
            if(isTimeBound) {
              ServiceAppointment saUpdate = new ServiceAppointment(Id = saId, Is_Time_Bound__c = isTimeBound, Committed_Start_Date__c = commStartTime,
                                                                   Committed_End_Date__c = commEndTime);
              update saUpdate;
            }
            isSuccess = true;
        } catch(Exception ex) {
            System.debug(ex.getMessage());
            isSuccess = false;
        }
        return isSuccess;
    }
    /*** 
     * Method Name:   getSACandidates
     * Author:      Stephen Moss
     * Created Date:  07/08/2018
     * Description:   Get the candidates for the passed in Service Appointment Id
     ***/
    @AuraEnabled
    public static List<srvCandidateWrapper> getSACandidates(Id srvAppointmentId, Id workOrderId, String workType) {
        System.debug('getSACandidates srvAppointmentId  '+srvAppointmentId + 'workOrderId ' + workOrderId + ' workType'+workType);
         // FSL.GradeSlotsService class
     // The GetGradedMatrix method returns a matrix of resource id's and graded time slots

     Id serviceAppointmentId = srvAppointmentId;
     ServiceAppointment sa = [select id, EarliestStartTime, DueDate from ServiceAppointment where Id=:serviceAppointmentId];
         System.debug(' ServiceAppointment '+sa);
     // Shouldn't hardcode Scheduling Policy...
         Id schedulingPolicyId=[select id from FSL__Scheduling_Policy__c where Name='Customer First' limit 1].Id;
         System.debug(' schedulingPolicyId '+schedulingPolicyId);

     // Generate the graded time slots for the service appointment 
     FSL.GradeSlotsService mySlotService = new FSL.GradeSlotsService(schedulingPolicyId,serviceAppointmentId);
         System.debug(' mySlotService '+mySlotService);

     // Store the matrix of service resource id's and graded time slots
     FSL.AdvancedGapMatrix myResultMatrix = mySlotService.GetGradedMatrix(true);
         System.debug(' myResultMatrix '+myResultMatrix);

     Map<Id,FSL.ResourceScheduleData> mySRGradedTimeSlotMap = myResultMatrix.ResourceIDToScheduleData;
         System.debug(' mySRGradedTimeSlotMap '+mySRGradedTimeSlotMap);

     for (id thisresourceid : mySRGradedTimeSlotMap.keySet()){
         for (FSL.SchedulingOption thisso : mySRGradedTimeSlotMap.get(thisresourceid).SchedulingOptions ) {
           system.debug('***** Resource id' + thisresourceid);
           system.debug('***** Start - ' + thisso.Interval.Start);
           system.debug('***** Finish - ' + thisso.Interval.Finish);
           system.debug('****** Grade - ' + thisso.Grade); 
         }
        }
        String assignedResourceId;
        for(AssignedResource ar : [SELECT Id,ServiceResourceId
                                   FROM AssignedResource
                                   WHERE ServiceAppointment.ParentRecordId = :workOrderId
                                   AND ServiceAppointment.WorkType.Name = :workType]) {

            assignedResourceId = ar.ServiceResourceId != null ? ar.ServiceResourceId : null;
        }
        
        // Get Service Resource details
        Set<Id> timeSlots = mySRGradedTimeSlotMap.keySet();
        String srQuery = ' SELECT Id, Name, IsCapacityBased, Contact__r.Name,Capacity_Used__c ';
        srQuery += ' FROM ServiceResource ';
        if(assignedResourceId != null) {
            srQuery += ' WHERE Id = :assignedResourceId';
        } else {
            srQuery += ' WHERE Id IN :timeSlots ';
        }
        System.debug('Nikhil srQuery '+srQuery + ' assignedResourceId '+assignedResourceId);
        List<ServiceResource> resourceList = Database.query(srQuery);
        
        // Now Build the Return Dataset
    List<srvCandidateWrapper> rtnCandidates = new List<srvCandidateWrapper>();
        for (ServiceResource s : resourceList) {
            srvCandidateWrapper sc = new srvCandidateWrapper();
            sc.serviceResourceId = s.Id;
            sc.serviceResourceName = s.Name;
            sc.isCapacityBased = s.IsCapacityBased;
            sc.percentCapacityUsed = s.Capacity_Used__c;
            if(mySRGradedTimeSlotMap.containsKey(s.Id)) {
                for (FSL.SchedulingOption thisso : mySRGradedTimeSlotMap.get(s.Id).SchedulingOptions ) {
                    srvCandidateSlotWrapper apptSlot = new srvCandidateSlotWrapper();
                    apptSlot.slotStart = thisso.Interval.Start;
                    apptSlot.slotFinish = thisso.Interval.Finish;
                    apptSlot.slotGrade = String.valueOf(thisso.Grade);
                    sc.appointmentSlots.add(apptSlot);
                }
            }
            rtnCandidates.add(sc);
        }
        return rtnCandidates;    
    }
    public class TempCandidateMetadata {
        @AuraEnabled
        public String workType;
        @AuraEnabled
        public String servTerritory;
        @AuraEnabled
        public List<NJ_SelectOptionLightning> areas;
    }
    /**
     * This method is used to get metadata for tier2 candidates
     * @param  srvAppointmentId - Id of the service appointment
     * @return                  Metadata of the tier2 candidate
     */
    @AuraEnabled
    public static TempCandidateMetadata initTempCandidates(Id srvAppointmentId) {
        TempCandidateMetadata tcm = new TempCandidateMetadata();
        for(ServiceAppointment sa : [SELECT Id, WorkType.Name, ServiceTerritory.Name
                                     FROM ServiceAppointment
                                     WHERE Id =:srvAppointmentId]) {
            tcm.workType = sa.WorkType.Name;
            tcm.servTerritory = sa.ServiceTerritory.Name;                             
        }
        tcm.areas = new List<NJ_SelectOptionLightning> { new NJ_SelectOptionLightning('','All')};
        tcm.areas.addAll(NJ_Utilities.getPicklistValues(Account.sObjectType, 'Service_Areas__c'));
        return tcm;
    }
    /**
     * This method is used to search tier2 candidates
     * @param  tradeType - trade type selected by the user
     * @param  servArea - service areas selected by the user
     * @param  nme - name of the account
     * @return List<Account> found using search
     * @Author : Nikhil
     */
    @AuraEnabled
    public static List<Account> findTempCandidates(String workOrderId, String tradeType, String servArea, String nme) {
      System.debug(' workOrderId '+ workOrderId +'Nik tradeType ' + tradeType + ' servArea '+servArea + ' nme' + nme);
      ServiceAppointment saDetails;
      List<Account> foundAccounts = new List<Account>();
      for(ServiceAppointment sa : [SELECT Id, Tier_2_Trade_Account__c, Tier_2_Trade_Account__r.Name, Tier_2_Trade_Account__r.Service_Areas__c
                                   FROM ServiceAppointment
                                   WHERE ParentRecordId = :workOrderId
                                   AND Tier_2_Trade_Account__c != null
                                   LIMIT 1]) {
        saDetails = sa;
      }
      if(saDetails != null) {
        foundAccounts.add(new Account(Id = saDetails.Tier_2_Trade_Account__c, Name = saDetails.Tier_2_Trade_Account__r.Name,
                                      Service_Areas__c = saDetails.Tier_2_Trade_Account__r.Service_Areas__c));
      } else {
          Set<Id> ttAcc = new Set<Id>();
          Set<Id> servAreaAcc = new Set<Id>();
          Set<Id> nameAcc = new Set<Id>();
          Set<Id> nameAccApproved = new Set<Id>();  // For Approved Trade Compliances only. Added by Nikhil on 02/11/2018
          Set<Id> finalAcc = new Set<Id>();
          if(String.isNotBlank(tradeType)) {
            String ttStr = '%' + tradeType + '%';
            for(Trade_Type__c tt : [SELECT Id, Account__c
                                    FROM Trade_Type__c
                                    WHERE Work_Type__r.Name LIKE :ttStr
                                    AND Status__c = 'Approved' ]) {
              ttAcc.add(tt.Account__c);
            }
          }
          if(String.isNotBlank(servArea)) {
            for(Account ac : [SELECT Id
                              FROM Account
                              WHERE Service_Areas__c includes (:servArea)]) {
              servAreaAcc.add(ac.Id);
            } 
          }
          if(String.isNotBlank(nme)) {
            String nameStr = '%' + nme + '%';
            for(Account acc : [SELECT Id
                               FROM Account
                               WHERE Name LIKE :nameStr
                               ]) {
              nameAcc.add(acc.Id);
            }
          }
          if(String.isNotBlank(tradeType) && String.isNotBlank(servArea)) {
            finalAcc.addAll(ttAcc);
            finalAcc.retainAll(servAreaAcc);
          } else if(String.isNotBlank(tradeType)) {
            finalAcc.addAll(ttAcc);
          } else if(String.isNotBlank(servArea)) {
            finalAcc.addAll(servAreaAcc);
          }
          if(!nameAcc.isEmpty()) {
            finalAcc.addAll(nameAcc);
          }
          for(Account acc : [SELECT Id, Name, Service_Areas__c,
                            (SELECT Id FROM Trade_Types__r WHERE Status__c = 'Approved')
                             FROM Account
                             WHERE Id IN :finalAcc]) {
            if(!acc.Trade_Types__r.isEmpty()) {
              foundAccounts.add(acc);
            }
          }
      }
        
      System.debug('FoundAccounts'+foundAccounts);  
      return foundAccounts;

    }
      /**
     * This method is used to schedule temp candidate appointment
     * @param  
     * @return List<Account> found using search
     * @Author : Nikhil
     */
    @AuraEnabled
    public static srvScheduleResponseWrapper scheduleTempCandidate(Id servAppId, Id accId, Datetime commStartTime, Datetime commEndTime, String workOrderId) {
      System.debug('Nikhil servAppId '+servAppId + ' accId '+ accId + ' commStartTime '+ commStartTime + ' commEndTime' +commEndTime + ' workOrderId '+workOrderId);
      List<Id> contactIds = new List<Id>();
      Id tempAssignedAcc;
      for(Contact ct : [SELECT Id
                        FROM Contact
                        WHERE AccountId = :accId]) {
        contactIds.add(ct.Id);
      }
      System.debug('contactIds '+contactIds);
      Set<Id> userIds = new Set<Id>();
      Set<Id> userIdsFSL = new Set<Id>();

      for(User usr : [SELECT Id
                      FROM User
                      WHERE ContactId IN :contactIds]) {
        userIds.add(usr.Id);
      }
      for(PermissionSetAssignment psa : [SELECT AssigneeId
                                         FROM PermissionSetAssignment
                                         WHERE PermissionSet.Name LIKE '%FSL%'
                                         AND AssigneeId IN :contactIds 
                                         ]) {
        userIdsFSL.add(psa.AssigneeId); 
      }
      userIds.removeAll(userIdsFSL);
      if(!userIds.isEmpty()) {
        Id accoId  = (new List<Id>(userIds)).get(0);
        List<User> usAcc = [Select AccountId from User WHERE ID = :accoId];
        Id acc = usAcc[0].AccountId; 
        tempAssignedAcc = acc;
      }
      System.debug('tempAssignedUser '+tempAssignedAcc +' servAppId '+servAppId);
      if(tempAssignedAcc != null && servAppId != null) {
        Savepoint sp = Database.setSavePoint();
        try {
          update new ServiceAppointment(Id = servAppId, Status = 'Tentative', Status_Change_to_Tentative__c = Datetime.now(), Tier_2_Trade_Account__c  = tempAssignedAcc, Committed_Start_Date__c = commStartTime, Committed_End_Date__c =  commEndTime);
          update new WorkOrder(Id = workOrderId, Service_resource_Company__c = tempAssignedAcc);
          srvScheduleResponseWrapper rspSuccess = new srvScheduleResponseWrapper();
          rspSuccess.schedulingStatus = 'SUCCESS';
          rspSuccess.schedulingMessage = 'Appointment Successfully Scheduled';
          return rspSuccess;
        } catch (Exception ex) {
          Database.rollback(sp);
          String mesg = ex.getMessage();
          if(mesg.contains('Cannot change status from Awaiting Confirmation to Tentative')) {
            mesg = 'Cannot change status from Awaiting Confirmation to Tentative';
          }
          throw new AuraHandledException(mesg);
        }
      } else {
        throw new AuraHandledException('No user found!!!');
      }
    }


    /*** 
     * Method Name:   scheduleAppointmentForCandidate
     * Author:      Stephen Moss
     * Created Date:  09/08/2018
     * Description:   Schedule an Appointment for a specified candidate
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
        List<ServiceAppointment> srvList = [SELECT Id, Duration, DurationType, Status, SchedStartTime, SchedEndTime, Service_Resource__c
                                            FROM ServiceAppointment
                                            WHERE Id = :srvAppointmentId];
        if (!srvList.isEmpty()) {
            Savepoint sp = Database.setSavePoint();
            try {
                // update Status, Scheduled Start and Scheduled Finish on Service Appointment
              ServiceAppointment s = srvList[0];
              s.Status = 'Tentative';
                //Updating the Service Reosurce - Added by Nikhil
                s.Service_resource__c = srvResourceId;
              s.Status_Change_to_Tentative__c = Datetime.now();
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
                  System.debug('Update Existing Assigned Resource - Service Resource'+srvResourceId); 
                  AssignedResource a = assignedResourceList[0];
                  a.ServiceResourceId = srvResourceId;
                  update a;
              } else {
                  // create new
                  System.debug('Create New Assigned Resource'+srvResourceId); 
                  AssignedResource newAR = new AssignedResource();
                  newAR.ServiceAppointmentId = srvAppointmentId;
                  newAR.ServiceResourceId = srvResourceId;
                  insert newAR;
              }
                if(srvResourceId != null) {
                  System.debug('Service Resource Updated:'+srvResourceId) ; 
                  update new ServiceAppointment(Id = srvAppointmentId, Service_Resource__c = srvResourceId);
                }
                srvScheduleResponseWrapper rspSuccess = new srvScheduleResponseWrapper();
                rspSuccess.schedulingStatus = 'SUCCESS';
                rspSuccess.schedulingMessage = 'Appointment Successfully Scheduled';
                return rspSuccess;
            } catch (Exception e) {
                Database.rollback(sp);
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
     * Class Name:    srvAppointmentWrapper
     * Author:      Stephen Moss
     * Created Date:  07/08/2018
     * Description:   Wrapper Class for Service Appointment JSON to be returned to
     *          Lightning Component
     ***/
    public class srvAppointmentWrapper {
        
        // default no argument constructor
        // if you want to map fields manually
        public srvAppointmentWrapper() {
            
        }
        public srvAppointmentWrapper(ServiceAppointment srvAppt, List<WorkOrder> woList) {
            this(srvAppt);
            if(!woList.isEmpty()) {
                this.wo = woList[0];
            } else {
                this.wo = new WorkOrder();
            }
        }        
        // constructor to map a Service Appointment to the wrapper
        // automatically upon creation
        public srvAppointmentWrapper(ServiceAppointment srvAppt) {
            
            // default time and date if a field is empty

           // DateTime defaultDT = DateTime.newInstanceGmt(2000, 01, 01);
            
            DateTime defaultDT = DateTime.now();
            
            
            this.Id = srvAppt.Id;
            this.appointmentNumber = srvAppt.AppointmentNumber;
            this.status = srvAppt.Status;
            this.workTypeId = srvAppt.WorkTypeId;
            this.workTypeName = srvAppt.WorkType.Name;
            this.workOrderId = srvAppt.ParentRecordId;
            this.claimId = srvAppt.Claim__c;
            this.isTimeBound = srvAppt.Is_Time_Bound__c;
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
            if (srvAppt.Committed_Start_Date__c != null) {
                this.committedStartTime = srvAppt.Committed_Start_Date__c;
             } else {
                this.committedStartTime = defaultDT;
             }
            if (srvAppt.Committed_End_Date__c != null) {
                this.committedFinishTime = srvAppt.Committed_End_Date__c;
            } else {
                this.committedFinishTime = defaultDT;
            }
            if(srvAppt.Is_Time_Bound__c) {
              this.timeBoundCommittedStartTime = srvAppt.Committed_Start_Date__c;
              this.timeBoundCommittedFinishTime = srvAppt.Committed_End_Date__c;
            }

            if (srvAppt.Service_Resource__c != null) {
                this.serviceResourceId = srvAppt.Service_Resource__c;
            } else {
                this.serviceResourceId = '[Not Assigned]';
            }

            if (srvAppt.Service_Resource__r.Name != null) {
              this.isCapacityBased = srvAppt.Service_Resource__r.IsCapacityBased;
              this.serviceResourceName = srvAppt.Service_Resource__r.Name;    
            } else {
                this.isCapacityBased = true;
                this.serviceResourceNameTier2 = srvAppt.Tier_2_Trade_Account__r.Name;
            }
            
        }
        
        // Wrapper Class Properties
        @AuraEnabled
        WorkOrder wo { get; set; }
        @AuraEnabled
        String Id { get; set; }
        @AuraEnabled
        String appointmentNumber { get; set; }
        @AuraEnabled
        public String workOrderId { get; set; }
        @AuraEnabled
        String claimId { get; set; }
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
        DateTime committedStartTime { get; set; }
        @AuraEnabled
        DateTime committedFinishTime { get; set; }
        @AuraEnabled
        DateTime timeBoundCommittedStartTime { get; set; }
        @AuraEnabled
        DateTime timeBoundCommittedFinishTime { get; set; }
        @AuraEnabled
        String serviceResourceId { get; set; }
        @AuraEnabled
        String serviceResourceName { get; set; }
        @AuraEnabled
        Boolean isTimeBound { get; set; }
        @AuraEnabled
        String serviceResourceNameTier2 { get; set; } // For Tier 2 Trades
        @AuraEnabled
        Boolean isCapacityBased { get; set; }
    }
    
    /*** 
     * Class Name:    srvCandidateWrapper
     * Author:      Stephen Moss
     * Created Date:  07/08/2018
     * Description:   Wrapper Class for Service Appointment Candidate JSON to be returned to
     *          Lightning Component
     ***/
    public class srvCandidateWrapper {
        
        // default no argument constructor
        public srvCandidateWrapper() {
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
        Decimal percentCapacityUsed { get; set; }
        @AuraEnabled
        List<srvCandidateSlotWrapper> appointmentSlots { get; set; }
        
    }
    
    /*** 
     * Class Name:    srvCandidateSlotWrapper
     * Author:      Stephen Moss
     * Created Date:  07/08/2018
     * Description:   Wrapper Class for Service Appointment Candidate Slot
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
     * Class Name:    srvScheduleResponseWrapper
     * Author:      Stephen Moss
     * Created Date:  09/08/2018
     * Description:   Wrapper Class for response from Service
     *          Appointment Scheduling Request
     ***/
    public class srvScheduleResponseWrapper {
        
        // default no argument constructor
        public srvScheduleResponseWrapper() {
            
        }
        
        // Wrapper Class Properties
        @AuraEnabled
        String schedulingStatus { get; set; }
        @AuraEnabled
        String schedulingMessage { get; set; }
    }
    
    /*** 
     * Class Name:    srvUpdateResponseWrapper
     * Author:      Stephen Moss
     * Created Date:  27/08/2018
     * Description:   Wrapper Class for response from Service
     *          Appointment Update Request
     ***/
    public class srvUpdateResponseWrapper {
        
        // default no argument constructor
        public srvUpdateResponseWrapper() {
            updatedAppointment = new srvAppointmentWrapper();
        }
        
        // Wrapper Class Properties
        @AuraEnabled
        public String updateStatus { get; set; }
        @AuraEnabled
        public String updateMessage { get; set; }
        @AuraEnabled
        public srvAppointmentWrapper updatedAppointment { get; set; }
    }
    

}