/************************************************************************************************************
Name: homeRepairSupCrMemoInvCreationService
=============================================================================================================
Purpose: Class having re-usable logic for invoice creation.
===============================================================================================================
History
-----------
VERSION    AUTHOR           DATE             DETAIL        DESCRIPTION
1.0        xx                xx                 xx       HomeRepair - Finance Module
*************************************************************************************************************/

public with sharing class homeRepairSupCrMemoInvCreationService {
    
/***************************************************************** 
Purpose: Method to create Invoice records from WorkOrder.                                                       
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
                                             Invoice_Type__c,Status, SupplierInvCheck__c,Total_Labour_Amount__c,Total_Material_Amount__c,Customer_Invoice_Ref__c
                                             FROM WorkOrder 
                                             WHERE Id =: workorderRecords.keySet()
                                            ];
            
            Map<String,AP_Invoice__c> invMap = new Map<String,AP_Invoice__c>();
            Map<String,AP_SOW__c> invLIMap = new Map<String,AP_SOW__c>();
             
            for(WorkOrder wo : workOrderList) {
                AP_Invoice__c InvToCreate = new AP_Invoice__c();
                InvToCreate.Work_Order__c = wo.Id;
                InvToCreate.Status__c = 'Submitted';
                InvToCreate.Invoice_Type__c = 'Supplier Credit Memo';             
                InvToCreate.Invoice_Description__c = wo.WorkOrderNumber + ' ' + '|' + ' ' + wo.Description;
                InvToCreate.Supplier_Invoice_Ref__c = wo.Customer_Invoice_Ref__c;
                InvToCreate.Generate_Invoice_Statement__c = true;
                InvToCreate.Labour_ex_GST__c = wo.Total_Labour_Amount__c * -1;
                InvToCreate.Material_ex_GST__c = wo.Total_Material_Amount__c * -1;
                
                invMap.put(wo.Id,InvToCreate);
         
            }
            if (invMap.size() > 0){
                insert invMap.Values();
            }

            //Create Invoice Line Items & associate to Invoice
            List<WorkOrderLineItem> workOrderLineItemList = [Select ID,WorkOrderId,Status,WorkTypeId,
                                                             Quantity,StartDate,Subtotal,TotalPrice,UnitPrice,Total_inc_GST__c,
                                                             LineItemNumber,Room__c,Product2Id,Work_Item_Description__c,GST__c,                                                        
                                                             Invoice_Type__c,Product_Description__c,UOM__c
                                                             FROM WorkOrderLineItem  
                                                             WHERE WorkOrderId =: workorderRecords.keySet()
                                                             AND Cash_Settled__c != true // AND Do_Not_Invoice__c != true (commented on intro of Do_Not_Invoice_AR__c)                                                        
                                                             AND Do_Not_Invoice_Prepay__c != true
                                                            ];
            
 
            for(WorkOrderLineItem woli : workOrderLineItemList) {
                AP_SOW__c InvLiItemToCreate = new AP_SOW__c();
                InvLiItemToCreate.Scope_Of_Work__c = woli.Product_Description__c;
                InvLiItemToCreate.Trade__c = woli.WorkTypeId;
                InvLiItemToCreate.Quantity__c = woli.Quantity;
                InvLiItemToCreate.UOM__c = woli.UOM__c;
                
                //getting the corresponding invoice
                AP_Invoice__c createdInvoice = invMap.get(woli.WorkOrderId);
                InvLiItemToCreate.AP_Invoice__c = createdInvoice.Id;
                invLIMap.put(woli.Id,InvLiItemToCreate);
                
            }
            if (invLIMap.size() > 0){
                insert invLIMap.Values();
            }
            
            //Update SupplierInvCheckFlag in WO to restrict creation of more than one supplier invoice
            List<WorkOrder> wotoUpdate = [select id, SupplierInvCheck__c from WorkOrder where Id =: workorderRecords.keySet()];
            if(wotoUpdate != null)
                { 
                    for (WorkOrder woSup : wotoUpdate)
                    {
                        woSup.RecordLocked__c = true; 
                        update wotoUpdate;                            
                    }
                }  
            
            
            
        }// try ends
        catch (System.QueryException se) {
        }
        finally {}
    } 
    
}