/************************************************************************************************************
Name:  TradePortalServiceAppointments
=============================================================================================================
Purpose: Retrieves and Show ServiceAppointment from WorkOrder
Called by: TradePortalServiceAppointments.cmp (Trade Portal component)
===============================================================================================================
History
-----------
VERSION    AUTHOR       DATE             DETAIL        DESCRIPTION
1.0        Vasu         26/06/2018       Created      Home Repairs Claims system
*************************************************************************************************************/
public  without sharing class  TradePortalServiceAppointments {
/***************************************************************** 
Purpose: Retrieves ServiceAppointment Records                                                    
Parameters: WorkOrder Id
Returns: Returns List<ServiceAppointment>
Throws [Exceptions]: None                                                          
History                                                             
--------                                                            
VERSION        AUTHOR         DATE           DETAIL   Description 
1.0            Vasu           26/06/2018      Created      Home Repairs Claims system 
*******************************************************************/
  @AuraEnabled
  public static List<ServiceAppointment> getServiceAppointments(String parentId) {
        system.debug('Entering  getServiceAppointments: ' + 'WorkOrder Id: ' + parentId );
        Set<String> woIds=new Set<String>();
        WorkOrder wo=[SELECT Id, CaseId from WorkOrder where Id =: parentId limit 1];
        For (Case cs :[SELECT Id,(SELECT Id from WorkOrders where recordtype.name in ('Home Repair Trades','HomeRepair MakeSafe','HomeRepar Rectification')) from Case where Id =: wo.CaseId]){
            if(cs.WorkOrders.size() > 0){
                system.debug('WorkOrders: '+cs.WorkOrders);
                for(WorkOrder w:cs.WorkOrders){
                    if(w.Id != wo.Id){
                        woIds.add(w.Id);                    
                    }
                }                
            }            
        }
        system.debug('WorkOrder Ids: '+woIds);
        List<ServiceAppointment> ServiceAppointmentList=[SELECT Id,Contact.Phone, Contact.MobilePhone,Sort_Order__c,AppointmentNumber,WorkType.Name,SchedStartTime, Status, Service_Resource__c,Service_Resource__r.Name
                FROM ServiceAppointment WHERE ParentRecordId IN : woIds
                Order by Sort_Order__c];
        system.debug('Exiting  getServiceAppointments: ' + 'ServiceAppointments : ' + ServiceAppointmentList);
        return ServiceAppointmentList;
    }
    /*
    @AuraEnabled
    public static List<All_Service_Appointments__c> getAllServiceAppointments(String parentId) {
        system.debug('Entering  getAllServiceAppointments: ' + 'WorkOrder Id: ' + parentId );
        Set<String> woIds=new Set<String>();
        WorkOrder wo=[SELECT Id, CaseId from WorkOrder where Id =: parentId limit 1];
        For (Case cs :[SELECT Id,(SELECT Id from WorkOrders where recordtype.name in ('Home Repair Trades','HomeRepair MakeSafe','HomeRepar Rectification')) from Case where Id =: wo.CaseId]){
            if(cs.WorkOrders.size() > 0){
                system.debug('WorkOrders: '+cs.WorkOrders);
                for(WorkOrder w:cs.WorkOrders){
                    if(w.Id != wo.Id){
                        Id woId=w.Id;
                        woIds.add(woId);                    
                    }
                }                
            }            
        }
        system.debug('WorkOrder Ids: '+woIds);
        List<All_Service_Appointments__c> allServiceAppointmentList=new List<All_Service_Appointments__c>();
        allServiceAppointmentList=[SELECT Work_Type__c, Id, Schedule_StartDate__c, Status__c, Work_Order__c, Work_Order_Line_Item__c, Claim__c, Work_Order_Description__c, Work_Order_Line_Item_Desc__c, Service_Resource__c, Service_Resource__r.Name,Company_Name__c, Phone__c, Alt_Phone__c FROM All_Service_Appointments__c 
                                                         where Work_Order__c IN : woIds
                                  						];   //Amended for portal visibility by NJ on 20/11/2018
        system.debug('Exiting  getAllServiceAppointments: ' + 'ServiceAppointments : ' + allServiceAppointmentList);
        return allServiceAppointmentList;
    }*/
    @AuraEnabled
    public static List<ServiceAppointment> getAllServiceAppointments(String parentId) {
        system.debug('Entering  getAllServiceAppointments: ' + 'WorkOrder Id: ' + parentId );
        Set<String> woIds=new Set<String>();
        WorkOrder wo = [SELECT Id, CaseId 
                        FROM WorkOrder 
                        WHERE Id =: parentId 
                        LIMIT 1];
        List<ServiceAppointment> allServiceAppointmentsList = new List<ServiceAppointment>();
        if(wo != null && wo.CaseId != null) {
            Map<Id,ServiceAppointment> woServiceAppointments = new Map<Id, ServiceAppointment>( [ SELECT Id
                                                                                                  FROM ServiceAppointment
                                                                                                  WHERE ParentRecordId = :parentId]);
            allServiceAppointmentsList = [SELECT Id,AppointmentNumber, Account.Name, WorkType.Name, Service_Resource__c, Service_Resource__r.Contact__r.Name,
                                                 Service_Resource__r.Contact__r.MobilePhone, Service_Resource__r.Contact__r.Phone,
                                                 SchedStartTime, SchedEndTime, Tier_2_Trade_Account__r.Name, Tier_2_Trade_Account__c,
                                                 Tier_2_Trade_Account__r.Accounts_Email_Address__c, Tier_2_Trade_Account__r.Accounts_Phone__c,Service_resource__r.Contact__r.Account.Name
                                          FROM ServiceAppointment
                                          WHERE Claim__c = :wo.CaseId
                                          AND ID NOT IN :woServiceAppointments.keySet()
                                          AND Status IN ('Confirmed', 'Awaiting Confirmation', 'Completed', 'Cannot Complete', 'Cancelled')
                                          ];   
        }
        system.debug('Exiting  getAllServiceAppointments: ' + 'ServiceAppointments : ' + allServiceAppointmentsList);
        
        return allServiceAppointmentsList;
    }
}