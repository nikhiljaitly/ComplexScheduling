/************************************************************************************************************
Name: homeRepairSupplierInvCreationService
=============================================================================================================
Purpose: Class having re-usable logic for invoice creation.
===============================================================================================================
History
-----------
VERSION    AUTHOR           DATE             DETAIL        DESCRIPTION
1.0        xx                xx                 xx       HomeRepair - Finance Module
*************************************************************************************************************/

public with sharing class homeRepairSupplierInvCreationService {
    
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
        try {
            List<WorkOrder> workOrderList = [Select ID,WorkOrderNumber,CaseId,Claim_Job__c,WorkTypeId,Job_Type__c,RCTI__c,
                                             Description,LineItemCount,Do_Not_Invoice_AP__c,Work_Type_Name__c,Internal_Resource__c,
                                             Invoice_Type__c,Status, SupplierInvCheck__c,Total_Labour_Amount__c,Total_Material_Amount__c,
                                             Total_Prepayment_Adjustment_Amount__c,Customer_Invoice_Ref__c,Total_Labour_Amount_GST_Free__c,
                                             Total_Material_Amount_GST_Free__c
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
                WorkTypeId = r.WorkTypeId; //Required
                WorkTypeName = r.Work_Type_Name__c; 
                intResourceFlag = r.Internal_Resource__c; 
                invoiceType = r.Invoice_Type__c; 
                WkOrdrstatus = r.Status;
                wkOrderId = r.Id;
            }
 
            Map<String,AP_Invoice__c> invMap = new Map<String,AP_Invoice__c>();                 
            
            Map<AP_Invoice__c,List<string>> invMapCustomer = new Map<AP_Invoice__c,List<string>>();
            Map<Id,List<WorkOrderLineItem>> workOrderLineItemMap = new Map<Id,List<WorkOrderLineItem>>();
            
            Map<String,String> workOrderIdToCaseIdMap  = new Map<String,String>();
            Map<String,String> workOrderIdToJobTypeMap  = new Map<String,String>();
            Map<String,String> workOrderIdToWorkTypeMap  = new Map<String,String>();
           
            for(WorkOrder wo : workOrderList) {
                AP_Invoice__c InvToCreate = new AP_Invoice__c();
                InvToCreate.Work_Order__c = wo.Id;
                InvToCreate.Status__c = 'Submitted';
                InvToCreate.Invoice_Type__c = 'Supplier';             
                InvToCreate.Invoice_Description__c = wo.WorkOrderNumber + ' ' + '|' + ' ' + wo.Description;              
                InvToCreate.Generate_Invoice_Statement__c = true;
                InvToCreate.Labour_ex_GST__c = wo.Total_Labour_Amount__c;
                InvToCreate.Material_ex_GST__c = wo.Total_Material_Amount__c;
                InvToCreate.Prepayment_Amount__c = wo.Total_Prepayment_Adjustment_Amount__c;
                InvToCreate.Oracle_Process_Status__c = 'Pending';
                InvToCreate.Supplier_Invoice_Ref__c = wo.Customer_Invoice_Ref__c;
                InvToCreate.Labour_GST_Free__c = wo.Total_Labour_Amount_GST_Free__c;
                InvToCreate.Material_GST_Free__c = wo.Total_Material_Amount_GST_Free__c;
                invMap.put(wo.Id,InvToCreate);
                workOrderIdToCaseIdMap.put(wo.Id,wo.CaseId);
                workOrderIdToJobTypeMap.put(wo.Id,wo.Job_Type__c);
                workOrderIdToWorkTypeMap.put(wo.Id,wo.WorkTypeId);
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
                                                             AND Do_Not_Invoice_Prepay_AP__c != true
                                                            ];
            
            Map<String,AP_SOW__c> invLIMap = new Map<String,AP_SOW__c>();
            
            for(WorkOrderLineItem woli : workOrderLineItemList) {
                AP_SOW__c InvLiItemToCreate = new AP_SOW__c();
                    if(woli.Product_Description__c == 'Prepayment'){
                        InvLiItemToCreate.Scope_Of_Work__c = woli.Work_Item_Description__c;
                        InvLiItemToCreate.Prepayment_Amount__c = woli.TotalPrice;
                    } else{
                        InvLiItemToCreate.Scope_Of_Work__c = woli.Product_Description__c;
                    }
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
                    woSup.SupplierInvCheck__c = true;
                    woSup.RecordLocked__c = true;
                    update wotoUpdate;                            
                }
            }  
            
            //   }//WorkOrderList Size Ends       
        }// try ends
        catch (System.QueryException se) {
        }
        finally {}
    } 
    
}