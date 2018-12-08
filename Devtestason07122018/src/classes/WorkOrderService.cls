/************************************************************************************************************
Name: WorkOrderService
=============================================================================================================
Purpose: Class with re-usable methods which manages sharing access for WorkOrder.
===============================================================================================================
History
-----------
VERSION    AUTHOR           DATE             DETAIL       DESCRIPTION
1.0        Vasu         4/07/2018        Created       Home Repair Claim System  
*************************************************************************************************************/
public without sharing class WorkOrderService {

    public static void createServiceAppointment(List<WorkOrder> wList){
        List<ServiceAppointment> serviceAppointmentList=new List<ServiceAppointment>();
        Map<String,Integer> siteVisitCountMap=new Map<String,Integer>();
        Map<Integer,ServiceAppointment> workOrderLineItemMap=new Map<Integer,ServiceAppointment>();
        list<aggregateResult> aggResults = [SELECT MAX(Site_Visit_Number__c)visitCount,WorkOrderId from WorkOrderLineItem where WorkOrderId IN: wList group by WorkOrderId ];
        String WorkOrderId;
        Integer visitCount;
        for(Integer i=0;i<aggResults.size();i++){  
           WorkOrderId=String.valueOf(aggResults[i].get('WorkOrderId'));
           visitCount=Integer.valueOf(aggResults[i].get('visitCount'));
           siteVisitCountMap.put(WorkOrderId,visitCount);
           system.debug( 'Vasu' + aggResults[i].get('WorkOrderId')+'-----'+aggResults[i].get('visitCount'));
        }
        for(WorkOrder wo : [Select id,(Select id from ServiceAppointments),(Select Id,Site_Visit_Number__c,Service_Appointment__c
                                      from WorkOrderLineItems) from WorkOrder where id IN: wList]){
                                                   
            if(wo.WorkOrderLineItems.size() > 0){
                
                for(WorkOrderLineItem woli: wo.WorkOrderLineItems){
                    if (woli.Site_Visit_Number__c != null){
                        ServiceAppointment sa=new ServiceAppointment();
                        sa.Id=woli.Service_Appointment__c;
                        workOrderLineItemMap.put(Integer.valueOf(woli.Site_Visit_Number__c),sa);
                   }
                }
                if(wo.ServiceAppointments.size() == siteVisitCountMap.get(wo.Id)){                
                }else{
                    system.debug('wo :'+wo.ServiceAppointments.size());
                    if(wo.ServiceAppointments.size() == 0){
                        for(Integer i=0;i<siteVisitCountMap.get(wo.Id);i++){  
                            ServiceAppointment sa=HomeRepairUtil.createServiceAppointment(Wo.Id);                      
                            workOrderLineItemMap.put(i+1,sa);
                            serviceAppointmentList.add(sa);
                        }
                    }else{
                        if (siteVisitCountMap.containsKey(wo.Id)){
                           for(Integer i=0;i< (siteVisitCountMap.get(wo.Id)-wo.ServiceAppointments.size());i++){
                               ServiceAppointment sa=HomeRepairUtil.createServiceAppointment(wo.Id);                      
                               workOrderLineItemMap.put(wo.ServiceAppointments.size()+1,sa);
                               serviceAppointmentList.add(sa);
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
        for(WorkOrderLineItem wili : [Select Id,Site_Visit_Number__c,Service_Appointment__c
                              from WorkOrderLineItem where WorkOrderId IN : wList]){
              system.debug('workOrderLineItemMap :'+workOrderLineItemMap+'----'+wili.Id+'----'+wili.Site_Visit_Number__c);
              if (workOrderLineItemMap.containsKey(Integer.valueOf(wili.Site_Visit_Number__c))){                  
                   wili.Service_Appointment__c=workOrderLineItemMap.get(Integer.valueOf(wili.Site_Visit_Number__c)).Id;
                   workOrderLineItemList.add(wili);
               }
        }
        system.debug('workOrderLineItemList :'+workOrderLineItemList);
        if(!workOrderLineItemList.IsEmpty()){
            update workOrderLineItemList;
        } 
    }
 }