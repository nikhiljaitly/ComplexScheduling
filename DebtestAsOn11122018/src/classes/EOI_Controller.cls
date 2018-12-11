public without sharing class EOI_Controller {

    @AuraEnabled
    public static String getAbnCalloutResponseContents(String abnVal) {
        string includeHistoricalDetails = 'Y';
        string authenticationGuid = '38168094-5abb-4b4a-a5e7-cc2911ae53d0';
        string url = 'http://abr.business.gov.au/json/AbnDetails.aspx?'+
                     'abn='+abnVal+'&guid='+authenticationGuid+'&callback=ABNCallback';



        // Instantiate a new http object
        Http h = new Http();
 
        // Instantiate a new HTTP request, specify the method (GET) as well as the endpoint
        HttpRequest req = new HttpRequest();
        req.setEndpoint(url);
        req.setMethod('GET');
 
        // Send the request, and return a response
        HttpResponse res = h.send(req);
        System.debug('response:--> ' + res.getBody());
        System.debug(res);
        string payLoadResponse = res.getBody();
        payLoadResponse = payLoadResponse.remove('ABNCallback(');
        payLoadResponse = payLoadResponse.removeEnd(')');
        system.debug('payLoadResponse'+payLoadResponse);
        ABNCallback abc = (ABNCallback) System.JSON.deserialize(payLoadResponse, ABNCallback.class);
        return JSON.serialize(abc);
        //return abc;
 
        // Deserialize the JSON string into collections of primitive data types.
        
        /*Map < String, Object > resultsMap = (Map < String, Object > ) JSON.deserializeUntyped(payLoadResponse);
        system.debug('resultsMap-->' + resultsMap);
        return resultsMap;*/
    }
    @AuraEnabled
    public static String getLeadInitialForm() {
        String LEAD_INITIAL_FORM = 'Lead Initial Form';
        Wizard_Setting__mdt setting 
            = WizardSettingService.getWizardSettingByName(LEAD_INITIAL_FORM);
        return JSON.serialize(setting);
    }
    
    @AuraEnabled
    public static String getOptions(String entryStr) {
        return JSON.serialize(FieldUtils.fillOptions(entryStr));
    }
    
    @AuraEnabled
    public static String getCacheTable() {
        return TradeTypeController.getOptions();
    }
    
     @AuraEnabled
     public static List < String > getselectOptions(sObject objObject, string fld) {
      system.debug('objObject --->' + objObject);
      system.debug('fld --->' + fld);
      List < String > allOpts = new list < String > ();
      // Get the object type of the SObject.
      Schema.sObjectType objType = objObject.getSObjectType();
     
      // Describe the SObject using its object type.
      Schema.DescribeSObjectResult objDescribe = objType.getDescribe();
     
      // Get a map of fields for the SObject
      map < String, Schema.SObjectField > fieldMap = objDescribe.fields.getMap();
     
      // Get the list of picklist values for this field.
      list < Schema.PicklistEntry > values =
       fieldMap.get(fld).getDescribe().getPickListValues();
      
         
         
         
      // Add these values to the selectoption list.
      for (Schema.PicklistEntry a: values) {
          if(a.isActive()){
              allOpts.add(a.getValue());
          }       
      }
      system.debug('allOpts ---->' + allOpts);
      allOpts.sort();
      return allOpts;
     }
    @AuraEnabled
    public static String createLeadAndTradeCompliances(String leadDetail, String tradeCompliances) {
        ResponseHandler res = new ResponseHandler();
        Lead leadRecToInsert = (Lead) JSON.deserialize(leadDetail, Lead.class);
        List<Lead> leadExist =[Select id from Lead where ABN__c =: leadRecToInsert.ABN__c or Email =: leadRecToInsert.Email];
        if(leadExist.size() > 0){
            res.Status = 'isExist';
            res.LeadId = null;
            return JSON.serialize(res);
        }
        List<Trade_Type__c> compliances 
            = (List<Trade_Type__c>) JSON.deserialize(tradeCompliances, 
                List<Trade_Type__c>.class);
        
        
        
        
        leadRecToInsert.LeadSource = 'Trade Portal';
        leadRecToInsert.Type__c = 'Trade Company';
        AssignmentRule AR = new AssignmentRule();
        AR = [SELECT Id FROM AssignmentRule WHERE SobjectType = 'Lead' AND Active = True LIMIT 1];
        Database.DMLOptions dmlOpts = new Database.DMLOptions();
        dmlOpts.assignmentRuleHeader.assignmentRuleId= AR.id;   
        dmlOpts.EmailHeader.triggerUserEmail = true;
        leadRecToInsert.setOptions(dmlOpts);
        insert leadRecToInsert;
        if(compliances.size() > 0){
            Set<String> workTypeSet=new Set<String>();
            for(Trade_Type__c compliance: compliances) {
                workTypeSet.add(compliance.Trade_Type__c);
            }
            system.debug('workTypeSet:'+workTypeSet);
            Map<String,String> workTypeMap=new Map<String,String>();
            for(WorkType wt : [Select Id,Name from Worktype where Name IN: workTypeSet]){
                workTypeMap.put(wt.Name,wt.Id);
            }
            for(Trade_Type__c compliance: compliances) {
                if(workTypeMap.containsKey(compliance.Trade_Type__c)){
                    compliance.Work_Type__c = workTypeMap.get(compliance.Trade_Type__c);
                }
                compliance.Lead__c = leadRecToInsert.Id;
                compliance.Status__c = 'Pending';
            }
            system.debug('compliances:'+compliances);
            //insert compliances;
            upsert compliances;
        }
        res.Status = 'Success';
        res.LeadId = leadRecToInsert.Id;
        return JSON.serialize(res);  
    }
    
    @AuraEnabled
    public static String createLeadAndTradeTypes(String leadFirstPartDetail, String tradeTypeList){
        system.debug('leadFirstPartDetail'+leadFirstPartDetail);
        system.debug('tradeTypeList'+tradeTypeList);
        responseHandler res = new responseHandler();
        LeadFirstPartClass leadRec = (LeadFirstPartClass)JSON.deserialize(leadFirstPartDetail,LeadFirstPartClass.Class);
        
        List<Lead> leadExist =[Select id from Lead where ABN__c =: leadRec.abn or Email =: leadRec.Email];
        
        if(leadExist.size() > 0){
            res.Status = 'isExist';
            res.LeadId = null;
            return JSON.serialize(res);
        }else{
            List<TradeTypeClass>tradeTypesList = new List<TradeTypeClass>();
            tradeTypesList = (List<TradeTypeClass>)JSON.deserialize(tradeTypeList,List<TradeTypeClass>.Class);
            System.Debug('leadData123'+leadRec);
            System.Debug('tradeTypeListData123'+tradeTypesList);
            AssignmentRule AR = new AssignmentRule();
            AR = [SELECT Id FROM AssignmentRule WHERE SobjectType = 'Lead' AND Active = True LIMIT 1];
            //Creating the DMLOptions for "Assign using active assignment rules" checkbox
            Database.DMLOptions dmlOpts = new Database.DMLOptions();
            dmlOpts.assignmentRuleHeader.assignmentRuleId= AR.id;   
            dmlOpts.EmailHeader.triggerUserEmail = true;
          Lead leadRecToInsert;
            if(leadRec != null) {
            //create lead with available fields.
            leadRecToInsert = new Lead(
                FirstName = leadRec.FirstName,
                LastName =  leadRec.LastName,
                Title =  leadRec.Position,
                Email =  leadRec.Email,
                Phone =  leadRec.Phone,
                Main_Business_Phone__c =  leadRec.BusinessPhone,
                Alternate_Phone__c = leadRec.AlternatePhone,
                ABN__c = leadRec.abn,
                Company = leadRec.EntityName,
                ABN_Status__c = leadRec.AbnStatus,
                Registered_for_GST__c = leadRec.RegisteredForGst,
                PostalCode = leadRec.AddressPostcode,
                State = leadRec.AddressState,
                Street = leadRec.addStreet,
                City = leadRec.addCity,
                Preferred_Business_Name__c = leadRec.PrefTradeName,
                ACN__c = leadRec.ACN,
                When_did_your_business_commence_trading__c = leadRec.commenceDate,
                Description = leadRec.AddComments,
                Postal_Postcode__c = leadRec.postalZip,
                Postal_State__c = leadRec.postalState,
                Postal_Street__c = leadRec.postalStreet,
                Postal_Suburb__c = leadRec.postalCity,
                Business_Structure__c = leadRec.businessStructure,
                LeadSource = 'Trade Portal',
                Type__c = 'Trade Company'
                );
                leadRecToInsert.setOptions(dmlOpts);
            try{
                insert leadRecToInsert;
                List<Trade_Type__c>tradeTypeListToInsert = new List<Trade_Type__c>();
                system.debug('before TT Create'+tradeTypesList);
                if(!tradeTypesList.IsEmpty()){
                    system.debug('Entered TT Create');
                    for(TradeTypeClass tt : tradeTypesList){
                        Trade_Type__c tradeTypeRec = new Trade_Type__c();
                        if(tt.tradeTypeVal != ''){
                         tradeTypeRec.Trade_Type__c = tt.tradeTypeVal;
                        }                                                                                           
                        tradeTypeRec.License_Number__c = tt.licenceNo;
                        if(tt.licenceExpiry != ''){
                            tradeTypeRec.License_Expiry__c = date.valueOf(tt.licenceExpiry);    
                        }
                                                
                        tradeTypeRec.Lead__c = leadRecToInsert.Id;
                        tradeTypeListToInsert.add(tradeTypeRec);

                    }
                }
                if(!tradeTypeListToInsert.IsEmpty()){
                    insert tradeTypeListToInsert;               
                }
                res.Status = 'Success';
                res.LeadId = leadRecToInsert.Id;
                //return res;
                return JSON.serialize(res);                     
            }Catch(Exception e){
                system.debug('Exception Message'+e.getMessage());
                res.Status = 'FAILED';
                res.LeadId = null;
                return JSON.serialize(res);
                //return res;
                //return 'FAILED';
            }

        }else {return null;}
        }
        
        
           
        

        //return res;
        //return 'Success';
 

    }       

    @AuraEnabled
    public static Id saveChunk(Id parentId, String fileName, String base64Data, String contentType, String fileId, string fileDescription) {
        // check if fileId id ''(Always blank in first chunk), then call the saveTheFile method,
        //  which is save the check data and return the attachemnt Id after insert, 
        //  next time (in else) we are call the appentTOFile() method
        //   for update the attachment with reamins chunks   
        if (fileId == '') {
            fileId = saveTheFile(parentId, fileName, base64Data, contentType, fileDescription);
        } else {
            appendToFile(fileId, base64Data);
        }
 
        return Id.valueOf(fileId);
    }
 
    public static Id saveTheFile(Id parentId, String fileName, String base64Data, String contentType, string fileDescription) {
        base64Data = EncodingUtil.urlDecode(base64Data, 'UTF-8');
 
        Attachment oAttachment = new Attachment();
        oAttachment.parentId = parentId;
 
        oAttachment.Body = EncodingUtil.base64Decode(base64Data);
        oAttachment.Name = fileName;
        oAttachment.ContentType = contentType;
        oAttachment.Description = fileDescription;
 
        insert oAttachment;
 
        return oAttachment.Id;
    }
 
    private static void appendToFile(Id fileId, String base64Data) {
        base64Data = EncodingUtil.urlDecode(base64Data, 'UTF-8');
 
        Attachment a = [
            SELECT Id, Body
            FROM Attachment
            WHERE Id =: fileId
        ];
 
        String existingBody = EncodingUtil.base64Encode(a.Body);
 
        a.Body = EncodingUtil.base64Decode(existingBody + base64Data);
 
        update a;
    }
    public class ABNCallback{
        public string Abn;
        public string AbnStatus;
        public string AddressDate;
        public string AddressPostcode;
        public string AddressState;
        public List<String>BusinessName;
        public string EntityName;
        public string EntityTypeCode;
        public string EntityTypeName;
        public string Gst;
        public string Message;

    }

    public class LeadFirstPartClass{
        //More to add as we go.
        public string FirstName;
        public string LastName;
        public string Position;
        public string Email;
        public string Phone;
        public string AlternatePhone;
        public string BusinessPhone;
        public string abn;
        public string AbnStatus;
        public string EntityName;
        public string RegisteredForGst;
        public string AddressPostcode;
        public string AddressState;
        public string addStreet;
        public string addCity;
        public string PrefTradeName;
        public string ACN;

        public string postalStreet;
        public string postalCity;
        public string postalZip;
        public string postalState;
        public string AddComments;
        public string businessEmail;
        public string accountsEmail;
        public string businessStructure;
        public Date commenceDate;

    }

    public class TradeTypeClass{
        //More to add as we go.
        public String index;
        public string tradeTypeVal;
        public List<String> qldAreaValue;
        public List<String> nswAreaValue;
        public List<String> vicAreaValue;
        public List<String> otherAreaValue; 

        public String Brisbane;
        public String GoldCoast;
        public String Sunshine;

        public String Central;
        public String Newcastle;
        public String Sydney;
        public String Wollongong;

        public String Geelong;
        public String Melbourne;
        public String RegionalVic;

        public String NT;
        public String TAS;
        public String WA;
        public String SA;

        public string makeSafe;
        public string makeSafeType;
        public String allDayRate;
        public String businessHoursRate;
        public String afterBusinessRate;
        public string licenceType;
        public string licenceNo;
        public string licenceExpiry;
        public String fullyQualifiedRate;
        public String labourerRate;
        public String afterHourRate;
        public String callOutRate;
        public String reportRate;
        public String otherRate;

    }

    public class responseHandler{
        public String status;
        public String LeadId;
    }

    public class LeadDetail {
        public LeadFirstPartClass leadRec;
        public List<TradeTypeClass> tradeTypeRecs;
    }       

}