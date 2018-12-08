/***************************************************************** 
Purpose: To manage Repair Items for Room                                                       
--------                                                            
VERSION        AUTHOR         DATE           DETAIL       Description 
1.0            Vasu          22/03/2018      Created      Home Repair Claim System  
*******************************************************************/
@RestResource(urlMapping='/homerepair/api/v1/roomrepairitems/*')
global with sharing class RESTRoomRepairItemsAPI{  
    /***************************************************************** 
Purpose: Get method to retrieve repair items for Room
Parameters:None
Returns: List of Room repair items 
Throws [Exceptions]: Rest exception                                                          
History                                                             
--------                                                            
VERSION        AUTHOR         DATE           DETAIL   Description 
1.0            Vasu          22/03/2018     Created   Home Repair Claim system 
*******************************************************************/
    @HttpGet
    global static RESTRepairItemsResponseHandler GET() {        
        // Initialise request context to get request parameters
        // and response handler to return results
        RestRequest request = RestContext.request;
        RESTRepairItemsResponseHandler response = new RESTRepairItemsResponseHandler();
        
        // validate the request parameters for get method
        try {
            validateWSGetInput(request,'GET');
        } catch (RESTCustomException re) {
            return responseWithError('Error','INVALID_INPUT',re.getMessage());
        }
        
        //get claim Id 
        String claimId = request.params.get('claimId');
        
        System.Debug(LoggingLevel.DEBUG, '***Request Context = ' + request);
        
        List<Room__c> roomList=new List<Room__c>();
        Map<string,Room__c> roomMap=new Map<string,Room__c>();
        
        for(Room__c rm : [select id,Claim__c from Room__c where Claim__c=:claimId]){
            roomMap.put(rm.Claim__c,rm);
        }
        
        List<WorkOrder> workOrderClaimList=new List<WorkOrder>();
        
        
        //,UnitPrice,TotalPrice,
        try {
            workOrderClaimList = [select id,CaseId,WorkTypeId,WorkType.Name,Sort_Order__c,TotalPrice,Total_Labour_Amount__c,Total_Material_Amount__c,(select id,WorkTypeId,WorkType.Name,Sort_Order__c,Site_Visit_Number__c,Room__c,Room__r.Name,PricebookEntryId,PricebookEntry.Name,Cash_Settled__c,Contents_Type__c,UOM__c,Quantity,Description,Labour_Cost__c,Material_Cost__c,Labour_Time__c from WorkOrderLineItems order by WorkType.Name,Room__r.Name) from WorkOrder where WorkOrder.RecordType.Name='Home Repair Trades' and CaseId=:claimId];
        } catch (System.QueryException se) {
            return responseWithError('Error','QUERY_ERROR',se.getMessage());
        }
        
        Map<string,RESTWorkOrderWrapper> workOrderWrapperMap=new Map<string,RESTWorkOrderWrapper>();
        Map<string,WorkOrder> workOrderMap=new Map<string,WorkOrder>();        
        Map<string,List<RESTWorkOrderLineItemWrapper>> workOrderlineWrapperMap=new Map<string,List<RESTWorkOrderLineItemWrapper>>();        
        Map<string,List<RESTAttachmentWrapper>> attachmentMap=new Map<string,List<RESTAttachmentWrapper>>();
        Set<string> roomIds=new Set<string>();
        
        system.debug('workOrderClaimList :'+workOrderClaimList);
        
        for(WorkOrder wo : workOrderClaimList){            
            if(wo.WorkOrderLineItems.size() > 0){
                List<RESTWorkOrderLineItemWrapper> workOrderLineItemList=new List<RESTWorkOrderLineItemWrapper>();  
                for(WorkOrderLineItem woil : wo.WorkOrderLineItems){
                    system.debug('Wo:'+woil.Room__r.Id+'--'+woil.WorkType.Name+'----'+woil.Room__r.Id);
                    if(workOrderlineWrapperMap.containsKey(woil.Room__r.Id+woil.WorkType.Name)) {
                        if(woil.Room__r.Id != null){
                            roomIds.add(woil.Room__r.Id);
                            system.debug('workOrderlineWrapperMapIn :'+workOrderlineWrapperMap.get(woil.Room__r.Id+woil.WorkType.Name));
                            List<RESTWorkOrderLineItemWrapper> workOrderLineItemListTemp= workOrderlineWrapperMap.get(woil.Room__r.Id+woil.WorkType.Name);
                            workOrderLineItemListTemp.add(new RESTWorkOrderLineItemWrapper(woil));
                            workOrderlineWrapperMap.put(woil.Room__r.Id+woil.WorkType.Name, workOrderLineItemListTemp);
                        }                        
                    }else{
                        workOrderlineWrapperMap.put(woil.Room__r.Id+wo.WorkType.Name, new List<RESTWorkOrderLineItemWrapper>{new RESTWorkOrderLineItemWrapper(woil)});
                    }
                    workOrderMap.put(wo.id,wo);
                }
            }
        }
        
        system.debug('workOrderWrapperMap :'+workOrderWrapperMap);
        system.debug('workOrderlineWrapperMap :'+ workOrderlineWrapperMap);
        
        if(roomIds.size() > 0){
            attachmentMap=HomeRepairUtil.getContentDocuments(roomIds);
        }
        system.debug('attachmentMap :' + attachmentMap);
        List<RESTClaimWrapper> claimWrapperList=new List<RESTClaimWrapper>();
        RESTClaimWrapper cw;   
        List<RESTRoomRepairItemListWrapper> roomRepairItemListWrapper =new List<RESTRoomRepairItemListWrapper>();     
        Case csRoom = new Case();
        
        for(Case cs : [select id,ContactId,CaseNumber,Description,Total_Price__c,Estimated_Cost_of_Cash_Settlement__c,Assessment_Report_Created__c from Case where id=:claimId]){
            csRoom=cs;
        }
        Set<string> roomWithWo=new Set<string>();
        
        for(Room__c rm :[select id,Name,Claim__c,Floor__c,height__c,length__c,width__c,wall__c,perimeter__c,(select id,WorkType.Name,WorkOrder.Id from Work_Order_Line_Items__r) from Room__c where Claim__c=:claimId]){
            List<RESTWorkOrderWrapper> workOrderList=new List<RESTWorkOrderWrapper>(); 
            List<RESTAttachmentWrapper> attachmentWrapperList=new List<RESTAttachmentWrapper>();    
            if(rm.Work_Order_Line_Items__r.size() > 0){                                     
                for(WorkOrderLineItem woil : rm.Work_Order_Line_Items__r){             
                    if(workOrderMap.containsKey(woil.WorkOrder.Id)){
                        WorkOrder wo=workOrderMap.get(woil.WorkOrder.Id);
                        if(workOrderlineWrapperMap.containsKey(rm.Id+wo.WorkType.Name)) {
                            if(!roomWithWo.Contains(rm.Id+wo.WorkType.Name)){
                                List<RESTWorkOrderLineItemWrapper> workOrderLineItemList=new List<RESTWorkOrderLineItemWrapper>();
                                workOrderLineItemList.addAll(workOrderlineWrapperMap.get(rm.Id+wo.WorkType.Name));
                                system.debug('workOrderLineItemList :' + workOrderLineItemList.size());
                                RESTWorkOrderWrapper workOrderWrapper=new RESTWorkOrderWrapper(wo,workOrderLineItemList);
                                workOrderList.add(workOrderWrapper);
                                roomWithWo.add(rm.Id+wo.WorkType.Name);
                                if(attachmentMap.containsKey(rm.Id)){                            
                                    attachmentWrapperList.addAll(attachmentMap.get(rm.Id));                             
                                }
                            }
                        }
                    }                                      
                } 
                roomRepairItemListWrapper.add(new RESTRoomRepairItemListWrapper(rm,workOrderList,attachmentWrapperList));
                
            }else{                
                roomRepairItemListWrapper.add(new RESTRoomRepairItemListWrapper(rm,workOrderList,attachmentWrapperList));
            }
        }
        cw=new RESTClaimWrapper(csRoom ,roomRepairItemListWrapper); 
        system.debug('roomRepairItemListWrapper Json ' + JSON.serialize(claimWrapperList));
        RestContext.response.addHeader('Content-Type', 'application/json');
        response.Status = 'OK';
        response.Message = 'Success';   
        response.Data = cw;
        return response;
    }
    
    @HttpPut
    global static RESTRepairItemsResponseHandler PUT() {
        
        // Initialise request context to get request parameters
        // and response handler to return results
        RestRequest request = RestContext.request; //the RestRequest for the Apex REST method
        RESTRepairItemsResponseHandler response = new RESTRepairItemsResponseHandler();
        
        // validate the request parameters for get method
        
        try {
            validateWSGetInput(request,'PUT');
        } catch (RESTCustomException re) {
            return responseWithError('Error','INVALID_INPUT',re.getMessage());
        }
        
        System.Debug('Room Repair Item Body: ' + request.requestBody.toString());
        
        RESTClaimWrapper claimWrapperItem= (RESTClaimWrapper) JSON.deserialize(request.requestBody.toString(),RESTClaimWrapper.class); 
        
        List<Room__c> roomList=new List<Room__c>();
        Set<String> roomIds=new Set<String>();
        Set<String> woliIds=new Set<String>();
        List<WorkOrder> workOrderList=new List<WorkOrder>();
        List<WorkOrderLineItem> workOrderLineItemList=new List<WorkOrderLineItem>();
        Map<string,Room__c> roomMap=new Map<string,Room__c>();
        Map<string,WorkOrder> workOrderMap=new Map<string,WorkOrder>();
        Map<string,string> claimJobMap=new Map<string,string>();
        Map<string,WorkOrder> workTypeMap=new Map<string,WorkOrder>();
        List<ContentDocumentLink> contentLinkToBeCreated = new List<ContentDocumentLink>();
        system.debug('claimWrapperItem '+claimWrapperItem);
        //get claim Id 
        String claimId = request.params.get('claimId');
        
        for(Case cs : [Select id ,(Select id from Claim_Jobs__r where Job_Type__c='doAndCharge' order by createdDate ASC limit 1) from Case where id=:claimId]){
            if(cs.Claim_Jobs__r.size() > 0){
                claimJobMap.put(cs.Id,cs.Claim_Jobs__r[0].Id);
            }
        }
        
        for(WorkOrder wo : [select id,WorkType.Name from WorkOrder where CaseId =:claimId]){
            if(!workTypeMap.containsKey(wo.workType.Name)){
                workTypeMap.put(wo.WorkType.Name,wo);
            }
        }
        Case claim = new Case();
        claim.id = claimWrapperItem.claimId;
        claim.Assessment_Report_Created__c = claimWrapperItem.assessmentReportCreated;
        //claim.Total_Price__c = claimWrapperItem.totalPrice;
        claim.Estimated_Cost_of_Cash_Settlement__c = claimWrapperItem.estimatedCostofCashSettlement;
        try{
            Upsert Claim;
        }Catch(DMLException de){
            return responseWithError('Error','DML_ERROR',de.getMessage());
        }
        for(RESTRoomRepairItemListWrapper rwil : claimWrapperItem.rooms){
            if(rwil.isDeleted){
                roomIds.add(rwil.roomId);
            }else{
                Room__c rm=new Room__c();            
                rm.Id=rwil.roomId; 
                rm.Name=rwil.name;                     
                rm.Height__c=rwil.height;
                rm.Length__c=rwil.length;
                rm.Width__c=rwil.width;
                if(rwil.roomId == null){
                    rm.Claim__c=rwil.claimId;
                }
                for(RESTWorkOrderWrapper wow : rwil.workOrders){
                    if(!workOrderMap.containsKey(wow.workTypeName)){
                        WorkOrder wo =new WorkOrder();
                        if(wow.workOrderId == null && workTypeMap.containsKey(wow.workTypeName)){
                            wo.Id = workTypeMap.get(wow.workTypeName).Id;
                        }else{
                            wo.id = wow.workOrderId; 
                        }
                        wo.WorkTypeId=wow.workTypeId;
                        wo.Sort_Order__c = wow.sortOrder;
                        wo.CaseId=rwil.claimId;
                        wo.ContactId = claimWrapperItem.contactId;
                        if(claimJobMap.containsKey(rwil.claimId)){
                            wo.Claim_Job__c=claimJobMap.get(rwil.claimId);
                        }
                        workOrderList.add(wo);
                        workOrderMap.put(wow.workTypeName,wo);
                    }                    
                }            
                roomMap.put(rm.Name,rm);
                roomList.add(rm);
            }
        }
        if(roomIds.size()>0){
            if(HomeRepairUtil.deleteRepairItems(roomIds,'Room__c') != 'success'){
                return responseWithError('Error','DML_ERROR',HomeRepairUtil.deleteRepairItems(roomIds,'Room__c'));
            } 
        }
        if(roomList.size() > 0){            
            try{
                upsert roomList;
                system.debug('roomList '+roomList);
            }Catch(DMLException de){
                system.debug('Room Error '+de.getMessage());
                return responseWithError('Error','DML_ERROR',de.getMessage());
            }
        }
        if(workOrderList.size() > 0){                                
            try{
                upsert workOrderList;
            }Catch(DMLException de){
                return responseWithError('Error','DML_ERROR',de.getMessage());
            }
        }
        system.debug('claimWrapperItem.rooms'+claimWrapperItem.rooms);
        set<string> productNameSet=new set<string>();
        for(RESTRoomRepairItemListWrapper rwil : claimWrapperItem.rooms){
            for(RESTWorkOrderWrapper wow : rwil.workOrders){
                for(RESTWorkOrderLineItemWrapper woliw : wow.workOrderLineItems ){ 
                    if(woliw.workOrderLineItemId == null ){                            
                        productNameSet.add(woliw.productName);
                    }
                }
            }
        }
        
        Map<string,String> pricebookEntryMap = new Map<string,string>();
        
        for(PricebookEntry pbe: [Select Product2Id,Product2.Name,UnitPrice From PricebookEntry Where Product2.Name IN : productNameSet and PriceBook2.isStandard=true]){
            pricebookEntryMap.put(pbe.Product2.Name,pbe.Id);
        }
        
        for(RESTRoomRepairItemListWrapper rwil : claimWrapperItem.rooms){
            for(RESTWorkOrderWrapper wow : rwil.workOrders){
                for(RESTWorkOrderLineItemWrapper woliw : wow.workOrderLineItems ){                    
                    if(woliw.isDeleted){
                        woliIds.add(woliw.workOrderLineItemId);
                    }else{
                        WorkOrderLineItem woli=new WorkOrderLineItem();
                        woli.PricebookEntryId=woliw.productId;
                        woli.Contents_Type__c = woliw.contentsType;
                        woli.Quantity=woliw.quantity;  
                        woli.Description=woliw.description;
                        woli.Work_Item_Description__c = woliw.workTypeName+woliw.productName;
                        woli.Cash_Settled__c = woliw.cashSettled;
                        woli.Site_Visit_Number__c=woliw.siteVisitNumber;
                        woli.Labour_Cost__c=woliw.labourCost;
                        woli.Material_Cost__c=woliw.materialCost;
                        woli.Labour_Time__c=woliw.labourTime;
                        woli.Sort_Order__c = woliw.sortOrder;
                        
                        if (woliw.cashSettled = false){
                            woli.RecordTypeId = Schema.SObjectType.WorkOrderLineItem.getRecordTypeInfosByName().get('Repair Items').getRecordTypeId();
                        }else{
                            woli.RecordTypeId = Schema.SObjectType.WorkOrderLineItem.getRecordTypeInfosByName().get('Cash Settlement').getRecordTypeId();
                        }
                        
                        if(woliw.workOrderLineItemId == null ){
                            woli.WorkOrderId = workOrderMap.get(woliw.workTypeName).Id;
                            if(pricebookEntryMap.containsKey(woliw.productName)){
                                woli.PricebookEntryId=pricebookEntryMap.get(woliw.productName);
                            }
                        }else{
                            woli.Id=woliw.workOrderLineItemId;
                        }
                        
                        if(woliw.workTypeId == null){
                            if(workOrderMap.containsKey(woliw.workTypeName)){
                                woli.WorkTypeId=workOrderMap.get(woliw.workTypeName).WorkTypeId;                                
                            }                                           
                        }else{
                            woli.workTypeId=woliw.workTypeId;
                        } 
                        
                        if(woliw.roomId == null){
                            if(roomMap.containsKey(woliw.roomName)){
                                woli.Room__c=roomMap.get(woliw.roomName).Id;
                            }
                        }else{
                            woli.Room__c=woliw.roomId;
                        }
                        workOrderLineItemList.add(woli); 
                    }                  
                }
            }
            if(woliIds.size()>0){
                if(HomeRepairUtil.deleteRepairItems(woliIds,'WorkOrderLineItem') != 'success'){
                    return responseWithError('Error','DML_ERROR',HomeRepairUtil.deleteRepairItems(woliIds,'WorkOrderLineItem'));
                }                
            }
            
            if(rwil.attachments.size() > 0){
                if(roomMap.containsKey(rwil.name)){
                    contentLinkToBeCreated.addAll(HomeRepairUtil.upsertContentAttachment(roomMap.get(rwil.name).Id,rwil.attachments));
                }else{
                    contentLinkToBeCreated.addAll(HomeRepairUtil.upsertContentAttachment(rwil.roomId,rwil.attachments));
                }
            }
        }
        
        system.debug('workOrderLineItemList :' + workOrderLineItemList);
        if(workOrderLineItemList.size() > 0){
            try{
                
                
                upsert workOrderLineItemList;
                system.debug('workOrderLineItemList :' + workOrderLineItemList);
            }Catch(DMLException de){
                return responseWithError('Error','DML_ERROR',de.getMessage());
            }
        }
        //system.debug('contentLinkToBeCreated :' + contentLinkToBeCreated);
        //insert content links
        if(!contentLinkToBeCreated.isEmpty()){
            try{
                insert contentLinkToBeCreated;
                system.debug('contentLinkToBeCreated :' + contentLinkToBeCreated);
            }Catch(DMLException de){
                return responseWithError('Error','DML_ERROR',de.getMessage());
            }
        }
        if(response.Status != 'Error'){
            response.Status = 'OK';
            response.Message = 'Success';
        }
        return response;
    }
    private static RESTRepairItemsResponseHandler responseWithError(String eStatus,String eErrorCode,String eMessage) {
        RESTRepairItemsResponseHandler response = new RESTRepairItemsResponseHandler();
        response.Status = eStatus;
        response.ErrorCode = eErrorCode;
        response.Message = eMessage; 
        return response;        
    }
    /*******************************************************
* validate the input parameters for the GET Request
********************************************************/ 
    private static void validateWSGetInput(RestRequest request, String method) {
        //validate GET method parameters
        if (method == 'GET'){
            // make sure we have a valid calims id
            String claimId = request.params.get('claimId');
            if (claimId == null) {
                throw new RESTCustomException('You must supply a claimId');
            }     
        }
        //validate POST method parameters
        if (method == 'PUT'){
            // make sure we have a valid calims id
            String roomDetails= request.requestBody.toString();
            //make sure that we have a valid Room JSON
            if (roomDetails == null) {
                throw new RESTCustomException('You must supply a Valid JSON');
            }
        }
    }
}