/************************************************************************************************************
Name: WorkOrderLineItemService
=============================================================================================================
Purpose: Class with re-usable methods for WorkOrderLineItem trigger.
===============================================================================================================
History
-----------
VERSION    AUTHOR           DATE             DETAIL       DESCRIPTION
1.0        Vasu         10/10/2018        Created       Home Repair Claim System  
*************************************************************************************************************/
public without sharing class WorkOrderLineItemService {
    public static void createServiceAppointment(List<WorkOrderLineItem> workOrderLineItemsList){
        List<Id> workOrderIds= new List<Id>();
        for (WorkOrderLineItem wli : workOrderLineItemsList){
            workOrderIds.add(wli.WorkOrderId);
        }
        List<ServiceAppointment> serviceAppointmentList=new List<ServiceAppointment>();
        Map<String,Integer> siteVisitCountMap=new Map<String,Integer>();
        //Map<Integer,ServiceAppointment> workOrderLineItemMap=new Map<Integer,ServiceAppointment>();
        Map<String,ServiceAppointment> workOrderLineItemMap=new Map<String,ServiceAppointment>();
        Map<String,VisitNumberInfo> visitNoMap = new Map<String,VisitNumberInfo>();
        list<aggregateResult> aggResults = [SELECT MAX(Site_Visit_Number__c)visitCount,WorkOrderId from WorkOrderLineItem where WorkOrderId IN: workOrderIds group by WorkOrderId ];
        String WorkOrderId;
        Integer visitCount;
        for(Integer i=0;i<aggResults.size();i++){  
           WorkOrderId=String.valueOf(aggResults[i].get('WorkOrderId'));
           visitCount=Integer.valueOf(aggResults[i].get('visitCount'));
           siteVisitCountMap.put(WorkOrderId,visitCount);
           system.debug(aggResults[i].get('WorkOrderId')+'-----'+aggResults[i].get('visitCount'));
        }
        Decimal labourTime;
        String mapKey;
        VisitNumberInfo tempInfo;
        for(WorkOrder wo : [Select id, WorkType.Name,(Select id from ServiceAppointments),(Select Id,Site_Visit_Number__c,Service_Appointment__c, Labour_Time__c, Sort_Order__c
                                      from WorkOrderLineItems) from WorkOrder where id IN: workOrderIds]){
            
            //Sort_Order__c
            if(wo.WorkOrderLineItems.size() > 0){
                labourTime = 0;
                for(WorkOrderLineItem woli: wo.WorkOrderLineItems){
                    if (woli.Site_Visit_Number__c != null){
                        ServiceAppointment sa=new ServiceAppointment();
                        sa.Id=woli.Service_Appointment__c;
                        mapKey = String.valueOf(woli.Site_Visit_Number__c) + wo.Id;
                        workOrderLineItemMap.put(mapKey,sa);
                        if(!visitNoMap.containsKey(mapKey)) {
                          visitNoMap.put(mapKey, new VisitNumberInfo());
                        }
                        tempInfo = visitNoMap.get(mapKey);
                        if(woli.Labour_Time__c != null) {
                          tempInfo.totalDuration += woli.Labour_Time__c;
                        }
                        if(woli.Sort_Order__c != null) {
                          tempInfo.sortOrder = woli.Sort_Order__c;
                        }
                        visitNoMap.put(mapKey, tempInfo); 
                   }
                  
                }
                if(labourTime > 0) {
                  labourTime = labourTime / 60.0;
                  labourTime.setScale(2);
                }
                if(wo.ServiceAppointments.size() == siteVisitCountMap.get(wo.Id)){                
                }else{
                    system.debug('wo :'+wo.ServiceAppointments.size());
                    if(wo.ServiceAppointments.size() == 0){
                        for(Integer i=0;i<siteVisitCountMap.get(wo.Id);i++){  
                            ServiceAppointment sa=HomeRepairUtil.createServiceAppointment(Wo.Id);
                            mapKey = String.valueOf(i+1)+wo.Id;
                            if(visitNoMap.containsKey(mapKey)) {
                              sa.Duration = visitNoMap.get(mapKey).totalDuration / 60.0;   
                              sa.Sort_Order__c = visitNoMap.get(mapKey).sortOrder;
                            }
                            if(sa.Duration > 8) {
                              sa.FSL__IsMultiDay__c = true;
                            }     
                            sa.Work_Type_Name__c = wo.WorkType.Name;
                            workOrderLineItemMap.put(mapKey,sa);
                            serviceAppointmentList.add(sa);
                        }
                    }else{
                        if (siteVisitCountMap.containsKey(wo.Id)){
                           for(Integer i=0;i< (siteVisitCountMap.get(wo.Id)-wo.ServiceAppointments.size());i++){
                               ServiceAppointment sa=HomeRepairUtil.createServiceAppointment(wo.Id);  
                               mapKey = String.valueOf(wo.ServiceAppointments.size()+1)+wo.Id;
                               if(visitNoMap.containsKey(mapKey)) {
                                sa.Duration = visitNoMap.get(mapKey).totalDuration / 60.0;   
                                sa.Sort_Order__c = visitNoMap.get(mapKey).sortOrder;
                               }
                               if(sa.Duration > 8) {
                                sa.FSL__IsMultiDay__c = true;
                               }  
                               sa.Work_Type_Name__c = wo.WorkType.Name;
                               workOrderLineItemMap.put(mapKey,sa);
                               serviceAppointmentList.add(sa);
                               System.debug('SA to be creatd:'+sa);
                           }
                        }
                    }
                }
            }
        }
        system.debug('serviceAppointmentList : '+serviceAppointmentList);
        if(!serviceAppointmentList.IsEmpty()){
            try{
                insert serviceAppointmentList;                
            }catch(DMLException e) {
                system.debug('Error while upserting WorkOrderShare- ' + e.getMessage());
            }           
        }
        
        
        
        List<WorkOrderLineItem> workOrderLineItemList=new List<WorkOrderLineItem>();               
        for(WorkOrderLineItem wili : [Select Id,Site_Visit_Number__c,Service_Appointment__c,WorkOrderId
                              from WorkOrderLineItem where WorkOrderId IN : workOrderIds]){
              system.debug('workOrderLineItemMap :'+workOrderLineItemMap+'----'+wili.Id+'----'+wili.Site_Visit_Number__c);
              if (workOrderLineItemMap.containsKey(String.valueOf(wili.Site_Visit_Number__c)+wili.WorkOrderId)){                  
                   wili.Service_Appointment__c=workOrderLineItemMap.get(String.valueOf(wili.Site_Visit_Number__c)+wili.WorkOrderId).Id;
                   workOrderLineItemList.add(wili);
               }
        }
        system.debug('workOrderLineItemList :'+workOrderLineItemList);
        if(!workOrderLineItemList.IsEmpty()){
            update workOrderLineItemList;
        } 
    }

    public class VisitNumberInfo {
      Decimal totalDuration;
      Decimal sortOrder;
      public VisitNumberInfo() {
        totalDuration = 0;
      }
    }
 }