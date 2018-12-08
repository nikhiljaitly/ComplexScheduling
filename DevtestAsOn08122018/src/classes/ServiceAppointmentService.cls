/************************************************************************************************************
Name:ServiceAppointmentService
=============================================================================================================
Purpose: Service Appointment Service which is called by triiger class. 
It assigns fields to service appointment and updates workorder with Trade use details
===============================================================================================================
History
-----------
VERSION    AUTHOR           DATE             DETAIL       DESCRIPTION
1.0        Vasu         4/07/2018        Created       Home Repair Claim System  
*************************************************************************************************************/

public with Sharing class ServiceAppointmentService {    
    public static void assignFieldsServiceAppointment(List<ServiceAppointment> serviceAppointmentList){
        system.debug('Entering assignFieldsServiceAppointment method with ServiceAppointment : '+serviceAppointmentList);
        Set<String> woIds = new Set<String>();
        Map<String,WorkOrder> workOrderMap = new Map<String,WorkOrder>();
        Map<String,WorkOrderLineItem> workOrderLineItemMap = new Map<String,WorkOrderLineItem>();
        
        For(ServiceAppointment sa:serviceAppointmentList){
            woIds.add(sa.ParentRecordId);
        }
        
        List<All_Service_Appointments__c> allServiceAppointmentsList=new List<All_Service_Appointments__c>();
        
        for(WorkOrder wo : [Select Id,CaseId,Work_Type_Name__c,Sort_Order__c,WorkOrderNumber,Description from workOrder where Id IN : woIds]){
            workOrderMap.put(wo.Id,wo);
        }
        For (ServiceAppointment sa:ServiceAppointmentList){
            if(workOrderMap.containsKey(sa.ParentRecordId)) {                                      
                sa.Claim__c=workOrderMap.get(sa.ParentRecordId).CaseId; 
                sa.Work_Type_Name__c=workOrderMap.get(sa.ParentRecordId).Work_Type_Name__c;
            }
        }
        system.debug('Exiting assignFieldsServiceAppointment method');
    }
    
    public static void upsertAllServiceAppointments(List<ServiceAppointment> serviceAppointmentList){
        system.debug('Entering upsertAllServiceAppointments : '+serviceAppointmentList);
        Set<String> woIds = new Set<String>();
        Map<String,WorkOrder> workOrderMap = new Map<String,WorkOrder>();
        Map<String,WorkOrderLineItem> workOrderLineItemMap = new Map<String,WorkOrderLineItem>();
        
        For(ServiceAppointment sa:serviceAppointmentList){
            woIds.add(sa.ParentRecordId);
        }
        
        List<All_Service_Appointments__c> allServiceAppointmentsList=new List<All_Service_Appointments__c>();
        
        for(WorkOrder wo : [Select Id,CaseId,Work_Type_Name__c,Trade_User__c,Sort_Order__c,WorkOrderNumber,Description from workOrder where Id IN : woIds]){
            workOrderMap.put(wo.Id,wo);
        }
        for(WorkOrderLineItem wili : [Select Id,LineItemNumber,Description from WorkOrderLineItem where WorkOrderId IN : woIds]){
            workOrderLineItemMap.put(wili.Id,wili);
        }
        
        
        For(ServiceAppointment sa : serviceAppointmentList){
            All_Service_Appointments__c asa = new All_Service_Appointments__c();
            asa.Schedule_StartDate__c=sa.SchedStartTime;
            asa.Schedule_EndDate__c=sa.SchedEndTime;
            
            If(workOrderMap.containsKey(sa.ParentRecordId)) {
                asa.Claim__c = workOrderMap.get(sa.ParentRecordId).CaseId;
                asa.Work_Type__c = workOrderMap.get(sa.ParentRecordId).Work_Type_Name__c;
                asa.Work_Order__c=workOrderMap.get(sa.ParentRecordId).Id;
                asa.Work_Order_Description__c=workOrderMap.get(sa.ParentRecordId).Description;
                asa.Service_Resource__c=workOrderMap.get(sa.ParentRecordId).Trade_User__c;
            }
            
            If(workOrderLineItemMap.containsKey(sa.ParentRecordId)) {
                asa.Claim__c=sa.Claim__c;
                asa.Work_Order_Line_Item__c=workOrderLineItemMap.get(sa.ParentRecordId).LineItemNumber;
                asa.Work_Order_Line_Item_Desc__c=workOrderLineItemMap.get(sa.ParentRecordId).Description;
            }
            
            asa.External_ID__c=sa.ParentRecordId+''+sa.Id;
            allServiceAppointmentsList.add(asa);           
        }
        
        List<Database.upsertResult> asaResults = Database.upsert(allServiceAppointmentsList, 
                                                                 All_Service_Appointments__c.External_ID__c, false);
        system.debug('Exiting upsertAllServiceAppointments method');
    }
    
	  public static void updateWorkOrderTradeUserDetails(Map<Id,User> serviceAppointmentMap){
        system.debug('Entering updateWorkOrderTradeUserDetails: '+ 'serviceAppointmentMap: ' + serviceAppointmentMap);
        List<WorkOrder> workOrderList = new List<WorkOrder>();
        workOrderList = [select Id,CaseId,Trade_User__c,AccountId from WorkOrder where id in :serviceAppointmentMap.keySet()];
        
        if (!workOrderList.IsEmpty()){
            User u;  
            // Update work order details with service resource company and Trade user
            for(WorkOrder wo : workOrderList){
                if (serviceAppointmentMap.ContainsKey(wo.Id))
                    u = serviceAppointmentMap.get(wo.Id);
                wo.Trade_User__c = u.id;
                System.debug('Service Resource Company'+u.AccountId);
                wo.Service_Resource_Company__c = u.accountId;
            }
            Update workOrderList;
        }
        system.debug('Exiting updateWorkOrderTradeUserDetails: '+workOrderList);
    } 
}