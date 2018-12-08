/***************************************************************** 
Purpose: Generates assessment report by calling Conga api                                                       
--------                                                            
VERSION        AUTHOR         DATE           DETAIL       Description 
1.0            Vasu          12/05/2018      Created      Home Repair Claim System  
*******************************************************************/   
@RestResource(urlMapping = '/homerepair/api/v1/congaassessmentreport/*')
global with sharing class RESTCongaComposerAssessmentReportAPI {
     /***************************************************************** 
    Purpose: Get method to Generate PDF Via Conga Composser
    Parameters: claimId (CaseId)
    Returns: RESTCongaAttachmentResponseHandler 
    Throws [Exceptions]: Rest exception                                                          
    History                                                             
    --------                                                            
    VERSION        AUTHOR         DATE           DETAIL   Description 
    1.0            Vasu          12/05/2018     Created  Home Repair Claim system 
    *******************************************************************/
    @HttpGet
    global static RESTCongaAttachmentResponseHandler GET() {
        system.debug('Entering GET');
        // Initialise request context to get request parameters
        // and response handler to return results
        Set<String> contentDocumentIds=new Set<String>();
        RestRequest reqParam = RestContext.request;
        RESTCongaAttachmentResponseHandler response = new RESTCongaAttachmentResponseHandler();
        //get claim Id 
        String claimId = reqParam.params.get('claimId');
        //Read Claim 
        Case claim = new Case();
        claim = [Select id,Assessment_Report_Created__c from case where id = :claimId];
        System.Debug(LoggingLevel.DEBUG, '***Request Context = ' + reqParam);
        String sessId = UserInfo.getSessionId();
        String servUrl = Url.getSalesforceBaseUrl().toExternalForm()+'/services/Soap/u/29.0/'+UserInfo.getOrganizationId();
        String url2;
        General_Settings__c genSetting= General_Settings__c.getInstance(UserInfo.getUserId());
        
        if(genSetting.Value__c == 'DevTest'){
            system.debug('environment: ' + genSetting.Value__c);
            url2 = 'https://composer.congamerge.com/composer8/index.html?'+                
                       'sessionId='+sessId+'&serverUrl='+EncodingUtil.urlEncode(servUrl, 'UTF-8')+
                       '&defaultpdf=1&ds7=3&fp0=1&solmgr=1'+
                       '&OFN='+'AssementReport'+'-'+claimId+
                       '&SC0=0&SC1=SalesforceFile'+
                       '&Id='+claimId+
                       '&QueryId=[Heights]a0x5D000000IFL1,[Decline]a0x5D000000IFLV,[Policy]a0x5D000000IFLa,[WOAssess]a0x5D000000HshQ,'+
                       '[WOlines]a0x5D000000HrN9,[Accomm]a0x5D000000IFHs,[Asbestos]a0x5D000000IFHO,[RepairLink]a0x5D000000IFLG,'+
                       '[Cause]a0x5D000000IFLQ,[Risks]a0x5D000000IF8v,[Cash]a0x5D000000ITVd,[WOSR]a0x5D000000V9ip,[ClaimWO]a0x5D000000HrNE,&TemplateId=a195D000004aJXD'+
                       '&APIMode=1&targetorigin='+EncodingUtil.urlEncode(Url.getSalesforceBaseUrl().toExternalForm(), 'UTF-8');
        }else if(genSetting.Value__c == 'uat'){
            system.debug('environment: ' + genSetting.Value__c);
            url2 = 'https://composer.congamerge.com/composer8/index.html?'+                
                       'sessionId='+sessId+'&serverUrl='+EncodingUtil.urlEncode(servUrl, 'UTF-8')+
                       '&defaultpdf=1&ds7=3&fp0=1&solmgr=1'+
                       '&OFN='+'AssementReport'+'-'+claimId+
                       '&SC0=0&SC1=SalesforceFile'+
                       '&Id='+claimId+
                       '&QueryId=[WOlines]a0rN0000003HtsI,[WOAssess]a0rN0000003HtsK,[Accomm]a0rN0000003HtsL,'+
                       '[Asbestos]a0rN0000003HtsO,[Decline]a0rN0000003HtsP,[Policy]a0rN0000003HtsQ,[Cause]a0rN0000003HtsV,'+
                       '[Risks]a0rN0000003HtsW,[RepairLink]a0rN0000003HtsX,[ClaimWO]a0rN0000003HtsY,[Heights]a0rN0000003HtsM,'+
                       '[Cash]a0rN0000003HuBW,[WOSR]a0rN0000003QEta&TemplateId=a0zN00000022bAg'+
                       '&APIMode=1&targetorigin='+EncodingUtil.urlEncode(Url.getSalesforceBaseUrl().toExternalForm(), 'UTF-8');
        }else{
            url2 = 'https://composer.congamerge.com/composer8/index.html?'+                
                       'sessionId='+sessId+'&serverUrl='+EncodingUtil.urlEncode(servUrl, 'UTF-8')+
                       '&defaultpdf=1&ds7=3&fp0=1&solmgr=1'+
                       '&OFN='+'AssementReport'+'-'+claimId+
                        '&SC0=0&SC1=SalesforceFile'+
                       '&Id='+claimId+'&QueryId=[Heights]a0rN0000003HtsM,[Decline]a0rN0000003HtsP,[Policy]a0rN0000003HtsQ,[WOAssess]a0rN0000003HtsK,[TradeType]a0rN0000003HtsH,[WOlines]a0rN0000003HtsI,[ClaimWO]a0rN0000003HtsY,[Accomm]a0rN0000003HtsL,[Asbestos]a0rN0000003HtsO,[RepairLink]a0rN0000003HtsX,[Cause]a0rN0000003HtsV,[Risks]a0rN0000003HtsW,[Cash]a0rN0000003HuBW,&TemplateId=a195D000004aJXD'+
                       '&APIMode=1&targetorigin='+EncodingUtil.urlEncode(Url.getSalesforceBaseUrl().toExternalForm(), 'UTF-8');
        }
            
        system.debug('congaURL: '+url2);
        Http http = new Http();
        HttpRequest req = new HttpRequest();
        req.setEndpoint(url2);
        req.setMethod('GET');
        req.setTimeout(60000);
    
        // Send the request, and return a response
        HttpResponse res = http.send(req);
    
        system.debug('Repsonse status '+res.getStatus());
        system.debug('Response status code'+ res.getStatusCode());
        System.debug('Repsonse body '+res.getBody());
        RESTCongaAttachmentWrapper rcaw;
        // validate the request parameters
        try {
            ContentVersion cv=[select id , contentDocumentId,VersionData from ContentVersion where id=:res.getBody() limit 1]; 
            rcaw=new RESTCongaAttachmentWrapper(cv);
            contentDocumentIds.add(cv.contentDocumentId);
            if (claim.Assessment_Report_Created__c == false){
                 response.Message = HomeRepairUtil.deleteContentVersion(contentDocumentIds);
            }
        } catch (RESTCustomException re) {
            response.Status = 'Error';
            response.ErrorCode = 'DML_ERROR';
            response.Message ='Assessment Report not generated. Please contact HomeRepair customer support team'; 
            return response;
        }
        system.debug('Exit ContentVersion Document : '+ rcaw);
        response.Status = 'OK';
        response.Message = 'Success';   
        response.Data = rcaw;
        return response;
    }
}