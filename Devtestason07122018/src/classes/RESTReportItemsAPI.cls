/********************************************************
* Name: RestReportItemsAPI 
* Created By: Vasu Gorakati
* Date: 23th Feb 2017
* Description: Custom Apex Web Service for retrieving and 
*              managing Assessment Report Items and update 
*********************************************************/
@RestResource(urlMapping='/homerepair/api/v1/reportitems')
global class RESTReportItemsAPI {

private static List<RESTReportItemWrapper> reportItems;
private static Map<String,List<String>> selectItemValues;
private static Map<String,List<String>> declineReasonValues;
private static RESTReportItemResponseHandler reportAPIResponse; 
private static ServiceAppointment serveApp;
private static WorkOrder parentWO; 
//static initialisation code.
Static {
AssessmentItemConfig assConfig = AssessmentItemConfig.getInstance();
selectItemValues = assConfig.selectFieldToValues;
declineReasonValues = HomeRepairUtil.getDependentOptions('Case','Decline_Type__c','Decline_Reason_Details__c');
} 
/*********************************************
* GET Method to return a list of Assessment items
**********************************************/ 
@HttpGet
global static RESTReportItemResponseHandler GET() {

// Initialise request context to get request parameters
// and response handler to return results

RestRequest req = RestContext.request;
System.Debug(LoggingLevel.DEBUG, '***Request Context = ' + req);
RESTReportItemResponseHandler response = new RESTReportItemResponseHandler();

// validate the request parameters
try {
    validateWSGetInputAndBuildResponse(req);
} catch (RESTCustomException re) {
    return responseWithError('Error','INVALID_INPUT',re.getMessage());
}

//Get case details from the parent workorder.
 parentWO = [Select Id, Case.Id, Case.Description, Case.Insurance_Provider__r.Name,Case.Policy__r.Excess__c,
                      Case.Brand_logo__c,Case.Insurance_Provider__c,Case.Contact.Name, Case.Contact.Id, Case.Contact.Phone, Case.Contact.MobilePhone,Case.Status,
                      Case.Building_height__c, Case.Roof_type__c, Case.Insurable__c, Case.Cause__c, Case.Cause_Detail__c, Case.Contents_Damaged__c,
                      Case.Contents_Damaged_Comments__c, Case.Maintenance_Required__c, Case.Maintenance_Details__c, 
                      Case.Cash_Settlement__c, Case.Cash_Settlement_Reason__c, Case.Cash_Settlement_Comments__c, Case.Temporary_Accommodation_Required__c,
                      Case.Temporary_Accommodation_Reason__c, Case.Repair_OH_S__c, Case.Asbestos__c, Case.Safety_Repair_Working_Heights__c, Case.Potential_Risks_To_Trades__c,
                      Case.Potential_Risk_Comments__c,Case.Job_Readiness__c , Case.Claim_Proceeding__c, Case.Report_Type__c,Case.Awaiting_Report_Comments__c, Case.Decline_Type__c ,
                      Case.Decline_Reason_Details__c,Case.Full_Risk_Address__c,Case.Non_Fit_Reason__c, Case.Cancelled_Reason__c,
                      Case.Report_Item_Comments__c,Case.Other_Building_Height__c,Case.Insurance_Provider__r.Brand_Logo__c,Case.Insurance_Provider__r.PDS__c,
                      Case.Other_Roof_Type__c,Case.Important__c,Case.Policy__r.Name,Case.Policy__c,case.Additional_Comments__c,
                      Case.Policy__r.Policy_Location__Latitude__s,Case.Policy__r.Policy_Location__Longitude__s,Case.State1__c,
                      Case.Contents_Damaged_Restorer_Comments__c,Case.Contents_Damaged_Appoint_Restorer__c,
                      Case.Building_Restoration_Details__c,Case.Building_Restoration__c,Case.Building_Restoration_Type__c,
             		  Case.Building_Restoration_Appoint_Restorer__c,Case.Building_Restoration_Restorer_Comments__c,case.Customer_Onsite__c   
                      From WorkOrder
                      where Id = : serveApp.ParentRecordId Limit 1];

Map<string,List<RESTAttachmentWrapper>> attachmentMap=new Map<string,List<RESTAttachmentWrapper>>();
List<RESTAttachmentWrapper> attachmentWrapperList=new List<RESTAttachmentWrapper>();
Set<string> caseIds=new Set<string>();
caseIds.add(parentWO.Case.Id);
if(caseIds.size() > 0){
    attachmentMap=HomeRepairUtil.getContentDocuments(caseIds);            
    if(attachmentMap.containsKey(parentWO.Case.Id)){                            
        attachmentWrapperList.addAll(attachmentMap.get(parentWO.Case.Id));                             
    }
}
String brandLogo='';
if(parentWO.Case.Insurance_Provider__r.Brand_Logo__c != null && parentWO.Case.Insurance_Provider__r.Brand_Logo__c !=''){
    brandLogo=parentWO.Case.Insurance_Provider__r.Brand_Logo__c.substringAfter('.force.com');
}


RESTReportItemsList reportDetails = new RESTReportItemsList(selectItemValues,declineReasonValues,parentWO,attachmentWrapperList,serveApp,brandLogo);
// return found Inspections
response.Status = 'OK';
response.Message = 'Success';   
response.Data = reportDetails;
system.debug('Response');
System.debug('Serialised Response'+JSON.serialize(response));
return response;            

}

/*********************************************
* PATCH Method to update case record.
**********************************************/ 
@HttpPut
global static RESTReportItemResponseHandler PUT() {
// Initialise request context to get request parameters
// and response handler to return results
RestRequest req = RestContext.request;
RESTReportItemResponseHandler response = new RESTReportItemResponseHandler();

System.Debug(LoggingLevel.DEBUG, '***Request Context = ' + req);

// Payload cannot be null
if (req.requestBody == null) {
    return responseWithError('Error','PATCH_ERROR','HTTP PATCH Body cannot be null');
}

// parse Request Body and create a PODetails object
System.Debug(LoggingLevel.INFO, '***Request Body = ' + req.requestBody.toString());
RESTReportItemsList reportDetails = new RESTReportItemsList();
String JSONContent = req.requestBody.toString();
try {
    JSONParser parser = JSON.createParser(JSONContent);
    reportDetails = (RESTReportItemsList) parser.readValueAs(RESTReportItemsList.class);
} catch (Exception ex) {
    return responseWithError('Error','JSON_PARSING_ERROR','Error Parsing JSON Input: ' + ex.getMessage()); 
}

system.debug('reportDetails'+reportDetails);
Id caseId = (Id)reportDetails.claimDetails.Id;
Set<string> contentDocumentIds=new Set<string>();
List<ContentDocumentLink> contentLinkToBeCreated = new List<ContentDocumentLink>();

if(reportDetails.claimDetails != null && caseId.getSObjectType().getDescribe().getName() == 'Case'){
    try{
        update reportDetails.claimDetails;
        if(reportDetails.attachments.size() > 0){
            contentLinkToBeCreated.addAll(HomeRepairUtil.upsertContentAttachment(reportDetails.claimDetails.Id,reportDetails.attachments));
        }
        //insert content links
        if(!contentLinkToBeCreated.isEmpty()){
            try{
                insert contentLinkToBeCreated;
            }Catch(DMLException de){
                return responseWithError('Error','DML_ERROR',de.getMessage()); 
            }
        }
        
    }Catch(DMLException de){
        return responseWithError('Error','DML_ERROR',de.getMessage()); 
    }
}else{            
    responseWithError('Error','INVALID_CLAIM_DETAILS','Invalid Claim Record');
}
if (response.Status != 'Error'){
    response.Status = 'OK';
    response.Status = 'Success';
    response.Message = 'Claim updated Successfully'; 
}
return response;
}    
private static RESTReportItemResponseHandler responseWithError(String eStatus,String eErrorCode,String eMessage) {
RESTReportItemResponseHandler response = new RESTReportItemResponseHandler();
response.Status = eStatus;
response.ErrorCode = eErrorCode;
response.Message = eMessage; 
return response;        
}
/*******************************************************
* validate the input parameters for the GET Request
********************************************************/ 
private static void validateWSGetInputAndBuildResponse(RestRequest request) {

// make sure we have a valid service appointment id
Id appointmentId;
try {
    appointmentId = request.params.get('apptId');
}Catch (StringException se) {
    throw new RESTCustomException('Invalid Appointment Id');
}

if (appointmentId == null || appointmentId.getSObjectType().getDescribe().getName() != 'ServiceAppointment') {
    throw new RESTCustomException('You must supply a Service Appointment Id');
}

//Find the parent Id and parent type of SA.
try {
    serveApp = [SELECT ID, ParentRecordType, ParentRecordId, WorkTypeId,WorkType.Name,
                FSL__InternalSLRGeolocation__Latitude__s,FSL__InternalSLRGeolocation__Longitude__s
                FROM ServiceAppointment
                WHERE ID = : appointmentId LIMIT 1];
}Catch (StringException se) {
    system.debug('appointmentId: '+appointmentId);
    throw new RESTCustomException('No Service Appointment record found');
}

if(serveApp.ParentRecordType != 'WorkOrder') {
    throw new RESTCustomException('The Parent of SA should be a work order of type Assessment');    
}


//Query for the parent object.
if(serveApp.WorkType.Name != 'Assessment') {
    throw new RESTCustomException('The Parent of SA should be a work order of type Assessment');    
}

}

}