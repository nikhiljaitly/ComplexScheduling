/***
 * Class Name:      HRGanttChildController 
 * 
 * Author:          Stephen Moss
 * Created Date:    13/08/2018
 * Description:     Controller for the lightning component HRGanttChild
 * 
***/

public class HRGanttChildController {
    public static final String SA_STATUS_TENTATIVE = 'Tentative';
    public static final String SA_STATUS_CONFIRMED = 'Confirmed';
    public static final String SA_STATUS_AWAITING_CONFIRMATION = 'Awaiting Confirmation';
    public static final String SA_STATUS_AWAITING_CANCELLED = 'Canceled';
    public static final String SA_STATUS_AWAITING_NEW = 'New';
    public static final String WO_STATUS_ACCEPTED_WO = 'Accepted WO';
    public static final String WO_STATUS_NEW = 'New';
    public static final String WO_STATUS_WORKORDER_SCHEDULED = 'Work Order Scheduled';
    public class ServiceAppintmentWrap {
        @AuraEnabled
        public ServiceAppointment servApp;
        @AuraEnabled
        public Boolean isSelected;
        @AuraEnabled
        public String woNumber;
        public ServiceAppintmentWrap(ServiceAppointment sa) {
            this.servApp = sa;
            isSelected = false;
           
        }
    }
    /**
     * This method is used to get tentative service appointments
     * @param claimId Case Id
     * @return tentaAppointments : list of service appointment wrappers
     */
    @AuraEnabled
    public static List<ServiceAppintmentWrap> getTentativeAppointments(Id claimId) {
        Map<Id,ServiceAppintmentWrap> tentaAppointments = new Map<Id,ServiceAppintmentWrap>();
        List<ServiceAppointment> woAppointments = new List<ServiceAppointment>();
        Boolean addSA;
        for(WorkOrder wo : [SELECT Id, (SELECT Id, AppointmentNumber, Status, ParentRecordId, Work_Type_Name__c
                                        FROM ServiceAppointments)
                            FROM WorkOrder
                            WHERE CaseId = :claimId]) {
            addSA = true;
            for(ServiceAppointment sa : wo.ServiceAppointments) {
                if(sa.Status != SA_STATUS_TENTATIVE) {
                    addSA = false;
                    break;
                }
                woAppointments.add(sa);
            }
            // add SA only when all of them are tentative
            if(addSA) {
                for(ServiceAppointment sa : woAppointments) {
                    tentaAppointments.put(sa.Id, new ServiceAppintmentWrap(sa));
                }
            }
        }
        
        System.debug('SAs to confirm:'+tentaAppointments);
        
        return tentaAppointments.values();
    }
    /**
     * This method is used to get confirmed service appointments
     * @param claimId Case Id
     * @return tentaAppointments : list of service appointment wrappers
     */
    @AuraEnabled
    public static List<ServiceAppintmentWrap> getConfirmedAppointments(Id claimId) {
        List<ServiceAppintmentWrap> tentaAppointments = new List<ServiceAppintmentWrap>();
        List<String> confirmStatus = new List<String> { SA_STATUS_CONFIRMED, SA_STATUS_AWAITING_CONFIRMATION, SA_STATUS_TENTATIVE};
        for(ServiceAppointment sa : [SELECT Id, AppointmentNumber,Work_Type_Name__c, Service_Resource__r.IsCapacityBased, Status
                                     FROM ServiceAppointment
                                     WHERE Status IN :confirmStatus 
                                     AND Claim__c = :claimId
                                     AND (Service_Resource__c != Null
                                          OR Tier_2_Trade_Account__c != Null) ]) {
            tentaAppointments.add(new ServiceAppintmentWrap(sa));
        }
        
                
        return tentaAppointments;
    }
        /**
     * This method is used to schedule tentative appointments
     * @param claimId Case Id
     * @return tentaAppointments : list of service appointment wrappers
     */
    @AuraEnabled
    public static void confirmAppointments(List<Id> appIds) {
        Map<Id,AssignedResource> appointAssignedResource = new Map<Id,AssignedResource>();
        List<ServiceAppointment> appointments = new List<ServiceAppointment>();
        for(AssignedResource ar : [SELECT Id, ServiceResource.IsCapacityBased, ServiceAppointmentId, ServiceAppointment.Tier_2_Trade_Account__c
                                   FROM AssignedResource
                                   WHERE ServiceAppointment.Id IN :appIds]) {
            appointAssignedResource.put(ar.ServiceAppointmentId, ar);
        }
        for(Id app : appIds) {
            if(appointAssignedResource.containsKey(app) && appointAssignedResource.get(app).ServiceResource != null &&  !appointAssignedResource.get(app).ServiceResource.IsCapacityBased) {
                appointments.add(new ServiceAppointment(Id = app, Status = SA_STATUS_CONFIRMED, Committed_End_Date__c = null,
                                                        Tier_2_Trade__c = null, Committed_Start_Date__c = null));

            } else {
                appointments.add(new ServiceAppointment(Id = app, Status = SA_STATUS_AWAITING_CONFIRMATION));
           }
        }
        Savepoint sp = Database.setSavePoint();
        try {
            if(!appointments.isEmpty()) {
                update appointments;
            }
            Set<Id> woIds = new Set<Id>();
            for(ServiceAppointment sa : [SELECT Id, ParentRecordId
                                         FROM ServiceAppointment
                                         WHERE Id IN :appIds ]) {
                woIds.add(sa.ParentRecordId);
            }
            // Map of work orders and their service appointment
            Map<Id,List<ServiceAppointment>> workOrderAllAppointments = new Map<Id, List<ServiceAppointment>>();
            List<ServiceAppointment> woAppointments;
            for(ServiceAppointment sa : [SELECT Id, ParentRecordId, Service_Resource__c, Service_Resource__r.IsCapacityBased, Tier_2_Trade_Account__c, Status
                                         FROM ServiceAppointment
                                         WHERE ParentRecordId IN :woIds]) {
                if(!workOrderAllAppointments.containsKey(sa.ParentRecordId)) {
                    workOrderAllAppointments.put(sa.ParentRecordId, new List<ServiceAppointment>());
                }
                woAppointments = workOrderAllAppointments.get(sa.ParentRecordId);
                woAppointments.add(sa);
                workOrderAllAppointments.put(sa.ParentRecordId, woAppointments);
            }
            Boolean updateWorkOrder;
            String workOrderStatus;
            Map<Id, WorkOrder> woToUpdateMap = new Map<Id, WorkOrder>();
            for(Id wo : workOrderAllAppointments.keySet()) {
                updateWorkOrder = true;
                List<ServiceAppointment> saAppointments = workOrderAllAppointments.get(wo);
                if(!saAppointments.isEmpty()) {
                    workOrderStatus = saAppointments[0].Service_Resource__c != null && !saAppointments[0].Service_Resource__r.IsCapacityBased
                                    ? WO_STATUS_ACCEPTED_WO
                                    : WO_STATUS_WORKORDER_SCHEDULED;
                    for(ServiceAppointment sa : workOrderAllAppointments.get(wo)) {
                        if(sa.Status != SA_STATUS_CONFIRMED && sa.Status != SA_STATUS_AWAITING_CONFIRMATION) {
                            updateWorkOrder = false;
                            break;
                        }
                    }
                    if(updateWorkOrder && !woToUpdateMap.containsKey(wo)) {
                        woToUpdateMap.put(wo, new WorkOrder(Id = wo, Status = workOrderStatus));
                    }
                }
            }
            
            
            
            if(!woToUpdateMap.isEmpty()) {
                update woToUpdateMap.values();
            }
        } catch(Exception ex) {
            Database.rollBack(sp);
            throw new AuraException(ex.getMessage());
        }
    }
    /**
     * This method is used to Unschedule tentative appointments
     * @param claimId Case Id
     * @return tentaAppointments : list of service appointment wrappers
     */
    @AuraEnabled
    public static void unScheduleAppointments(List<Id> appIds) {
        System.debug('appIds '+appIds);
     
        
        List<ServiceAppointment> appointments = new List<ServiceAppointment>();
        Map<Id, WorkOrder> workOrderUpdateMap = new Map<Id, WorkOrder>();
        Set<Id> woIds = new Set<Id>();
        for(ServiceAppointment sa : [SELECT Id, ParentRecordId
                                     FROM ServiceAppointment
                                     WHERE Id IN :appIds]) {
            woIds.add(sa.ParentRecordId);
            appointments.add(new ServiceAppointment(Id = sa.Id, Status = SA_STATUS_AWAITING_NEW, Committed_End_Date__c = null,  
                                                        SchedStartTime = null, Service_Resource__c = null,
                                                        SchedEndTime = null,Committed_Start_Date__c = null,
                                                        Tier_2_Trade__c = null, Tier_2_Trade_Account__c = null, 
                                                        Is_Time_Bound__c = false));
             if(sa.ParentRecordId != null && !workOrderUpdateMap.containsKey(sa.ParentRecordId)) {
                workOrderUpdateMap.put(sa.ParentRecordId, new WorkOrder(Id = sa.ParentRecordId, Service_resource_Company__c = null));
             }
        }
        Savepoint sp = Database.setSavePoint();
        try {
            if(!appointments.isEmpty()) {
                update appointments;
            }
        } catch(Exception ex) {
            Database.rollBack(sp);
            throw new AuraException(ex.getMessage());
        }
        
        Map<Id,List<ServiceAppointment>> workOrderAllAppointments = new Map<Id, List<ServiceAppointment>>();
        List<ServiceAppointment> woAppointments;
        for(ServiceAppointment sa : [SELECT Id, ParentRecordId, Service_Resource__c, Service_Resource__r.IsCapacityBased, Tier_2_Trade_Account__c, Status
                                     FROM ServiceAppointment
                                     WHERE ParentRecordId IN :woIds]) {
            if(!workOrderAllAppointments.containsKey(sa.ParentRecordId)) {
                workOrderAllAppointments.put(sa.ParentRecordId, new List<ServiceAppointment>());
            }
            woAppointments = workOrderAllAppointments.get(sa.ParentRecordId);
            woAppointments.add(sa);
            workOrderAllAppointments.put(sa.ParentRecordId, woAppointments);
        }
        Boolean updateWorkOrder;
        String workOrderStatus;
        for(Id wo : workOrderAllAppointments.keySet()) {
            updateWorkOrder = true;
            List<ServiceAppointment> saAppointments = workOrderAllAppointments.get(wo);
            if(!saAppointments.isEmpty()) {
                workOrderStatus = WO_STATUS_NEW;
                for(ServiceAppointment sa : workOrderAllAppointments.get(wo)) {
                    if(sa.Status != SA_STATUS_AWAITING_NEW) {
                        updateWorkOrder = false;
                        break;
                    }
                }
                if(updateWorkOrder) {
                    if(!workOrderUpdateMap.containsKey(wo)) {
                        workOrderUpdateMap.put(wo, new WorkOrder(Id = wo));
                    } 
                    WorkOrder tempWO = workOrderUpdateMap.get(wo);
                    tempWO.Status = workOrderStatus;
                    workOrderUpdateMap.put(wo, tempWO);
                }
            }
        }
        try {
            if(!workOrderUpdateMap.isEmpty()) {
                update workOrderUpdateMap.values();
            }
        } catch(Exception ex) {
            Database.rollBack(sp);
            throw new AuraException(ex.getMessage());
        }
    }
    /*** 
     * Method Name:     getClaimScheduledAppointments
     * Author:          Stephen Moss
     * Created Date:    13/08/2018
     * Description:     Get the Service Appointment details for the 
     *                  passed in Service Appointment Id where the SA
     *                  is at a stage of "Scheduled" or greater
     *                  in the lifecycle
     ***/
    @AuraEnabled
    public static List<srvTradeWrapper> getClaimScheduledAppointments(Id claimId) {
        System.debug('Nikhil claimId '+claimId);
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
            
            // old criteria - WHERE (ParentRecordId IN :woIdSet) AND (Status != 'None')
            // Commenting it for including the logic of Tier 2 Trades
       /*     List<ServiceAppointment> saList = [SELECT Id, Status, Subject, ParentRecordId, AppointmentNumber,
                                                      WorkType.Name, SchedStartTime, SchedEndTime,
                                                      EarliestStartTime, DueDate,
                                                      Service_Resource__r.Name
                                               FROM ServiceAppointment
                                               WHERE (ParentRecordId IN :woIdSet)
                                               ORDER BY SchedStartTime]; */
            
            List<ServiceAppointment> saList = [SELECT Id, Status, Subject, ParentRecordId, AppointmentNumber,
                                                      WorkType.Name, SchedStartTime, SchedEndTime,
                                                      EarliestStartTime, DueDate,Committed_Start_Date__c,Committed_End_Date__c,  
                                                      Service_Resource__r.Name, Tier_2_Trade_Account__r.Name, Service_Resource__r.IsCapacityBased,
                                                      Service_Resource__r.RelatedRecord.CompanyName,
                                                      Service_Resource__r.RelatedRecord.Contact.Account.Name
                                               FROM ServiceAppointment
                                               WHERE (ParentRecordId IN :woIdSet) AND (Status != 'New')
                                               ORDER BY SchedStartTime];
            String mapKey;
            // Build the return payload
            Map<String, List<srvApptWrapper>> companyNameSAMap = new Map<String, List<srvApptWrapper>>();
            List<srvTradeWrapper> returnSAList = new List<srvTradeWrapper>();
            System.debug('Nikhil saList '+saList);
            if (!saList.isEmpty()) {
                for (ServiceAppointment s : saList) {

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
                    saWrapper.assignedToNameTier2 = s.Tier_2_Trade_Account__r.Name;
                    saWrapper.committedStartDate = s.Committed_Start_Date__c;
                    saWrapper.committedEndDate   = s.Committed_End_Date__c;
                    saWrapper.capacityBased      = s.Service_Resource__r.IsCapacityBased;
                    System.debug('s.Service_Resource__r.RelatedRecord.CompanyName '+s.Service_Resource__r.RelatedRecord.CompanyName);
                    System.debug('s.Service_Resource__r.RelatedRecord.Contact.Account.Name '+s.Service_Resource__r.RelatedRecord.Contact.Account.Name);
                    System.debug('s.Tier_2_Trade_Account__r.Name '+s.Tier_2_Trade_Account__r.Name);
                    if(s.Service_Resource__r.RelatedRecord.Contact.Account.Name != null) {
                        mapKey = s.Service_Resource__r.RelatedRecord.Contact.Account.Name; 
                    } else if(s.Tier_2_Trade_Account__r.Name != null) {
                        mapKey = s.Tier_2_Trade_Account__r.Name;
                    } else if(s.Service_Resource__r.RelatedRecord.CompanyName != null) {
                        mapKey = s.Service_Resource__r.RelatedRecord.CompanyName;
                    } 
                    mapKey += (mapKey + ',' + s.workType.Name);
                    System.debug('Nikhil mapKey '+mapKey);
                    if(mapKey != null) {
                        if(!companyNameSAMap.containsKey(mapKey)) {
                            companyNameSAMap.put(mapKey, new List<srvApptWrapper>());
                        }
                        System.Debug(LoggingLevel.DEBUG, '***saWrapper = ' + saWrapper);
                        // check if we already have a map entry for Work Type
                        List<srvApptWrapper> sw = companyNameSAMap.get(mapKey);
                        sw.add(saWrapper);
                        companyNameSAMap.put(mapKey, sw);
                    }
                }
                
                
            }
            // now build wrapper return payload
            Set<String> keyList = companyNameSAMap.keySet();
            for (String key : keyList) {
                srvTradeWrapper tempWrapper = new srvTradeWrapper();
                List<String> values = key.split(',');
                if(values.size() > 0) {
                    tempWrapper.accName = values[0];
                }
                if(values.size() > 1) {
                    tempWrapper.workTypeName = values[1];
                }

                List<srvApptWrapper> tempList = companyNameSAMap.get(key);
                tempWrapper.srvApptList = tempList;
                returnSAList.add(tempWrapper);
            } 
            
            
            System.Debug(LoggingLevel.DEBUG, '***Return List = ' + returnSAList);
            return returnSAList;
        } else {
            // no Work Orders for Claim
            return null;    
        }
    }
    
    
    /*** 
     * Class Name:      srvTradeWrapper
     * Author:          Stephen Moss
     * Created Date:    09/08/2018
     * Description:     Wrapper Class for Service Appointment return list
     ***/
    private class srvTradeWrapper {
        
        // default no argument constructor
        private srvTradeWrapper() {
            srvApptList = new List<srvApptWrapper>();
        }
        
        // Wrapper Class Properties
        @AuraEnabled
        String accName { get; set; }
        @AuraEnabled 
        String workTypeName { get; set; }
        @AuraEnabled
        List<srvApptWrapper> srvApptList {get; set;}
                
    }

    
    
    
    /*** 
     * Class Name:      srvApptWrapper
     * Author:          Stephen Moss
     * Created Date:    09/08/2018
     * Description:     Wrapper Class for Service Appointment
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
        @AuraEnabled
        String workTypeName { get; set; }
        @AuraEnabled
        String assignedToName { get; set; }
        @AuraEnabled
        String assignedToNameTier2 { get; set; } // For Tier 2 Trade
        @AuraEnabled
        DateTime committedStartDate { get; set; } // For Tier 2 Trade
        @AuraEnabled
        DateTime committedEndDate { get; set; } // For Tier 2 Trade
        @AuraEnabled
        DateTime schedStart { get; set; }
        @AuraEnabled
        DateTime schedFinish { get; set; }
        @AuraEnabled
        DateTime earliestStart { get; set; }
        @AuraEnabled
        DateTime dueDate { get; set; }
        @AuraEnabled
        Boolean capacityBased { get; set; }
        
                
    }

}