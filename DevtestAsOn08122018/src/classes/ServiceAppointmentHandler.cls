/************************************************************************************************************
Name: ServiceAppointmentHandler
=============================================================================================================
Purpose: Class for ServiceAppointment Trigger as Handler.
===============================================================================================================
History
-----------
VERSION    AUTHOR           DATE             DETAIL       DESCRIPTION
1.0        Vasu         4/07/2018        Created       Home Repair Claim System  
*************************************************************************************************************/
public with sharing class ServiceAppointmentHandler implements ITrigger {
    private Map<Id, User> serviceAppointmentMap = new Map<Id, User>();
    private List<ServiceAppointment> ServiceAppointmentList = new List<ServiceAppointment>();
    Private ServiceAppointment saRec;
    public ServiceAppointmentHandler() {}
    public static Set<String> saStatus = new Set<String> { NJ_Constants.SA_STATUS_CONFIRMED, NJ_Constants.SA_STATUS_AWAITINGCONFIRMATION,
                                                            NJ_Constants.SA_STATUS_COMPLETED, NJ_Constants.SA_STATUS_CANCELLED,
                                                            NJ_Constants.SA_STATUS_CANNOTCOMPLETE
                                                          };
    public static Set<String> woStatus = new Set<String> { NJ_Constants.WO_STATUS_ASSIGNED, NJ_Constants.WO_STATUS_SCHEDULED,
                                                            NJ_Constants.WO_STATUS_ACCEPTED, NJ_Constants.WO_STATUS_REJECTED,
                                                            NJ_Constants.WO_STATUS_WORKCOMMENCED, NJ_Constants.WO_STATUS_WORKCOMPLETE,
                                                            NJ_Constants.WO_STATUS_CLOSED
                                                          };
    public void bulkBefore() {
    system.debug('Entering bulkBefore With Trigger.New');
       if(Trigger.IsInsert||Trigger.IsUpdate){
           for(Sobject saTemp : trigger.new){ 
                saRec = (ServiceAppointment)saTemp; 
                ServiceAppointmentList.add(saRec);
           }
        }
     system.debug('Exiting bulkBefore With Trigger.New');
    }
    public void bulkAfter() {
    system.debug('Entering bulkAfter With Trigger.New');
         if(Trigger.IsInsert||Trigger.IsUpdate){  
            Set <Id> setServiceResourceId = new Set<Id>();
             ServiceAppointmentList = new List<ServiceAppointment>();
            for(Sobject saTemp : trigger.new){ 
                saRec = (ServiceAppointment)saTemp;
                ServiceAppointmentList.add(saRec);
                If (saRec.Service_Resource__c != null){
                        system.debug('Service Resource Id: '+saRec.Service_Resource__c);
                        setServiceResourceId.add(saRec.Service_Resource__c);
                    }
            }
            
            Map<Id,User> mapServiceResourceUser = new Map<Id,User>();
            
            for( ServiceResource sr : [Select RelatedRecord.Id,RelatedRecord.AccountId,RelatedRecord.UserRole.Id,RelatedRecord.UserRole.PortalType from ServiceResource where id 
                                       in :setServiceResourceId] ){
                  mapServiceResourceUser.put(sr.id,sr.RelatedRecord);
             }
            
            system.debug('mapServiceResourceUser :'+mapServiceResourceUser);
            
            for(Sobject saTemp : trigger.new){ 
                saRec = (ServiceAppointment)saTemp;
                If (saRec.Service_Resource__c != null){
                        If (mapServiceResourceUser.containskey(saRec.Service_Resource__c)){
                            user u = mapServiceResourceUser.get(saRec.Service_Resource__c);
                            serviceAppointmentMap.put(saRec.ParentRecordId,u);
                        }
                    }
            }
            
        }
        if(Trigger.isUpdate) {
            Map<Id,SObject> oldAppointments = Trigger.oldMap;
            Map<Id,SObject> newAppointments = Trigger.newMap;
            ServiceAppointment oldApp, newApp;
            Set<Id> workOrders = new Set<Id>();
            for(Id sa : newAppointments.keySet()) {
                oldApp = (ServiceAppointment)oldAppointments.get(sa);
                newApp = (ServiceAppointment)newAppointments.get(sa);
                if(oldApp.Status != newApp.Status && saStatus.contains(newApp.Status) && saStatus.contains(newApp.Status)) {
                    workOrders.add(newApp.ParentRecordId);
                }
            }
            System.debug(workOrders);
            if(!workOrders.isEmpty()) {
                ServiceAppointmentHelper.updateWorkOrder(workOrders);
            }

        }   
        system.debug('Exiting bulkAfter With Trigger.New');
    }
    public void beforeInsert(SObject so) {
    } 
    public void afterInsert(SObject so) {
    } 
    public void beforeUpdate(SObject oldSo, SObject so) {
        
    }
    public void beforeUnDelete(SObject so) {} 
    
    public void afterUpdate(SObject oldSo, SObject so) {} 
    public void beforeDelete(SObject so){} 
    public void afterDelete(SObject so) {} 
    public void afterUnDelete(SObject so) {} 
    public void andFinally() {
        system.debug('Entering andFinally from ServiceAppointmentHandler');
        if(Trigger.IsBefore) {
            ServiceAppointmentService.assignFieldsServiceAppointment(ServiceAppointmentList);
        }else{
          /*  if (!serviceAppointmentMap.isEmpty()){
               ServiceAppointmentService.updateWorkOrderTradeUserDetails(serviceAppointmentMap);
            } */
            ServiceAppointmentService.upsertAllServiceAppointments(ServiceAppointmentList);
        } 
        system.debug('Exiting andFinally from ServiceAppointmentHandler');
    }               
}