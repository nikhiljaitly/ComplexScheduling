/************************************************************************************************************
Name: homeRepairCMFeeInvoiceCreationService
=============================================================================================================
Purpose: Class having re-usable logic for CM Fees invoice creation.
===============================================================================================================
History
-----------
VERSION    AUTHOR           DATE             DETAIL        DESCRIPTION
1.0        xx                xx                 xx       HomeRepair - Finance Module
*************************************************************************************************************/

public with sharing class homeRepairCMFeeInvoiceCreationService {
    
/***************************************************************** 
Purpose: Method to create CM Fees Invoice records from Assessor WorkOrder.                                                       
Parameters: Map of Work Order Number & Status.
Returns: none
Throws [Exceptions]: None                                                          
History                                                             
--------                                                            
VERSION    AUTHOR           DATE             DETAIL        DESCRIPTION
1.0        xx                xx                 xx       HomeRepair - Finance Module  
*******************************************************************/
public static void createInvoiceRecord(Map<ID,String> workorderRecords) {
        system.debug('WorkOrder KeySet' + workorderRecords.keySet());       
        List<WorkOrder_Invoice__c> workOrderInvoicesToInsert = new List <WorkOrder_Invoice__c>();
        List<WorkOrder_Invoice__c> workOrderInvoicesToInsertCust = new List <WorkOrder_Invoice__c>();
        try {
            List<WorkOrder> workOrderList = [Select ID,WorkOrderNumber,CaseId,Claim_Job__c,WorkTypeId,Job_Type__c,RCTI__c,
                                             Description,LineItemCount,Do_Not_Invoice_AP__c,Work_Type_Name__c,Internal_Resource__c,
                                             Invoice_Type__c,Status, SupplierInvCheck__c
                                             FROM WorkOrder 
                                             WHERE Id =: workorderRecords.keySet()
                                            ];
            
                boolean rcti,SupplierInvFlag,DoNotInvoiceAPflag,intResourceFlag;
                Integer LineItemCount;
                string WorkTypeId,WorkTypeName,invoiceType,WkOrdrstatus,wkOrderId;
                
                    for (WorkOrder r : workOrderList)
                        {
                            rcti = r.RCTI__c;
                            LineItemCount = r.LineItemCount;
                            DoNotInvoiceAPflag = r.Do_Not_Invoice_AP__c;
                            SupplierInvFlag = r.SupplierInvCheck__c;
                            WorkTypeId = r.WorkTypeId;
                            WorkTypeName = r.Work_Type_Name__c; 
                            intResourceFlag = r.Internal_Resource__c; 
                            invoiceType = r.Invoice_Type__c; 
                            WkOrdrstatus = r.Status;
                            wkOrderId = r.Id;
                        }
    
                Map<String,AR_Invoice__c> invMap = new Map<String,AR_Invoice__c>();
                Map<String,AR_SOW__c> invLIMap = new Map<String,AR_SOW__c>();                  
                Map<String,AR_Invoice__c> cmFeeInvMap = new Map<String,AR_Invoice__c>();                  
                
                for(WorkOrder wo : workOrderList) {                                       
                    AR_Invoice__c InvToCreate = new AR_Invoice__c();
                    InvToCreate.Claim_Job__c = wo.Claim_Job__c;
                    InvToCreate.Status__c = 'Submitted';
                    InvToCreate.Invoice_Type__c = 'CM Fees';                   
                    InvToCreate.Generate_Invoice_Statement__c = true;                      
                    cmFeeInvMap.put(wo.Id,InvToCreate);
                    
                }
                if (cmFeeInvMap.size() > 0){
                    insert cmFeeInvMap.Values();                      
                }
                    
                //Get CMFee Product Details,Create Invoice Line Item & Associate to Invoice
                List<Product2> cmFeesLineItem = [SELECT Full_Product_Name__c,IsActive,Name,ProductCode 
                                                 FROM Product2 where ProductCode = 'CMFEES' and IsActive = true
                                                ];          			
                
                for(Product2 cmfli : cmFeesLineItem) {
                    AR_SOW__c InvLiItemToCreate = new AR_SOW__c();
                    InvLiItemToCreate.Scope_Of_Work__c = cmfli.Full_Product_Name__c;                     
                    
                    //Get newly created CMFee InvoiceId and associated to Line Item
                    for(String cmFeeInvId : cmFeeInvMap.keySet()){
                        InvLiItemToCreate.AR_Invoice__c = cmFeeInvMap.get(cmFeeInvId).Id;
                        system.debug('createdInvoice ' + InvLiItemToCreate.AR_Invoice__c);
                    }             
                    invLIMap.put(cmfli.Id,InvLiItemToCreate);
          
                }
                if (invLIMap.size() > 0){
                    insert invLIMap.Values();
                }

            //Update CMFeeInvCheckFlag in WO to restrict creation of more than one supplier invoice            
            List<WorkOrder> wotoUpdate = [select id, CMFeeInvCheck__c from WorkOrder where Id =: workorderRecords.keySet()];
            if(wotoUpdate != null)
            { 
                for (WorkOrder woCmf : wotoUpdate)
                {
                    woCmf.CMFeeInvCheck__c = true;
                    update wotoUpdate;                            
                }
            }
			            
            
        }// try ends
        catch (System.QueryException se) {
        }
        finally {}
    }//createInvoiceRecord ends
}//homeRepairCMFeeInvoiceCreationService ends