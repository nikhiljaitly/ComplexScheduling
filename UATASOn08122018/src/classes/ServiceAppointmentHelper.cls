/**
* Helper class for service appointment trigger
* @Author : Nikhil Jaitly
* @Created date : 20/11/2018
*/
public with sharing class ServiceAppointmentHelper {
    /**
* This method update work order based on certain status
* @param woIds - list of work order ids
*/
    @future
    public static void updateWorkOrder(Set<Id> woIds) {
        Map<Id,List<ServiceAppointment>> mapWoSA = new Map<Id,List<ServiceAppointment>>();
        List<ServiceAppointment> tempSA;
        System.debug('updateWorkOrder '+woIds);
        System.debug('mapWoSA '+mapWoSA);
        Set<String> woStatus = ServiceAppointmentHandler.woStatus;
        System.debug(woStatus);
        Map<Id, WorkOrder> workOrders = new Map<Id, WorkOrder>([SELECT Id, Status
                                                                FROM WorkOrder
                                                                WHERE Id IN :woIds
                                                                AND Status IN :woStatus
                                                               ]);
        System.debug('workOrders '+workOrders);
        for(ServiceAppointment sa : [SELECT Id, ParentRecordId, Service_Resource__r.RelatedRecordId,
                                     Service_Resource__r.Contact__r.AccountId, Tier_2_Trade_Account__c,
                                     Service_Resource__c, Status
                                     FROM ServiceAppointment
                                     WHERE ParentRecordId IN :workOrders.keySet()]) {
                                         System.debug('Nikhil '+sa);
                                         if(!mapWoSA.containsKey(sa.ParentRecordId)) {
                                             mapWoSA.put(sa.ParentRecordId, new List<ServiceAppointment>());
                                         }
                                         tempSA = mapWoSA.get(sa.ParentRecordId);
                                         tempSA.add(sa);
                                         mapWoSA.put(sa.ParentRecordId, tempSA);
                                     }
        System.debug('mapWoSA '+mapWoSA);
        Boolean updateWo;
        List<WorkOrder> workOrderUpdate = new List<WorkOrder>();
        for(Id wo : mapWoSA.keySet()) {
            tempSA = mapWoSA.get(wo);
            System.debug('Nik SA:'+tempSA);
            System.debug('mapWoSA:'+mapWoSA);
            updateWo = true;
            for(ServiceAppointment sa : tempSA) {
                if(!ServiceAppointmentHandler.saStatus.contains(sa.Status)) {
                    updateWo = false;
                    break;
                }
            }
            if(updateWo && !tempSA.isEmpty()) {
                ServiceAppointment firstSA = tempSA.get(0);
                workOrderUpdate.add(new WorkOrder(Id = firstSA.ParentRecordId,
                                                  Service_Resource_Company__c = firstSA.Service_Resource__c != null ? firstSA.Service_Resource__r.Contact__r.AccountId : firstSA.Tier_2_Trade_Account__c,
                                                  Service_resource__c = firstSA.Service_Resource__c,
                                                  Trade_User__c = firstSA.Service_Resource__c != null ? firstSA.Service_Resource__r.RelatedRecordId : null));
            } 
        }
        if(!workOrderUpdate.isEmpty()) {
            System.debug('Nikhil '+workOrderUpdate);
            update workOrderUpdate;
        }
        
    }
}