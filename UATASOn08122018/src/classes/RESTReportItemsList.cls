/********************************************************
* Name: RESTReportItemsList
* Created By: Mathew Jose
* Date: 23rd Feb 2018
* Description: REST API Wrapper Class for case details & Report Items
*              
*********************************************************/ 

global class RESTReportItemsList {
// properties
public String WorkOrderId;
public String ContactName;
public String ContactId;
public String Phone;
public String Mobile;
public String Address; 
public String State;
public String BrandName;
Public String brandLogo;
Public String PDS;
public String Important;
Public Decimal Excess;
Public String PolicyNumber;
Public Decimal Latitude;
Public Decimal Longitude;
public Case claimDetails;  
public Map<String,List<String>> selectOptions;
public Map<String,List<String>> declineReasonOptions;
public List<RESTAttachmentWrapper> attachments;
public RESTReportItemsList() {

}
public RESTReportItemsList(Map<String,List<String>> fieldToPicklistValues, Map<String,List<String>> declineReasonValues,WorkOrder parentWorkOrder,List<RESTAttachmentWrapper> attachments, ServiceAppointment serveApp,String brandLogo) {
    this.WorkOrderId = parentWorkOrder.Id;
    this.ContactName = parentWorkOrder.Case.Contact.Name;
    this.ContactId = parentWorkOrder.Case.Contact.Id;
    this.Mobile = parentWorkOrder.Case.Contact.MobilePhone; 
    this.excess = parentWorkOrder.Case.Policy__r.Excess__c;
    this.PolicyNumber=parentWorkOrder.Case.Policy__r.Name;
    this.brandLogo = brandLogo;
    this.PDS = parentWorkOrder.Case.Insurance_Provider__r.PDS__c;
    this.BrandName = parentWorkOrder.Case.Insurance_Provider__r.Name;
    this.Important = parentWorkOrder.Case.Important__c;
    this.Latitude=serveApp.FSL__InternalSLRGeolocation__Latitude__s;
    this.Longitude=serveApp.FSL__InternalSLRGeolocation__Longitude__s;
    this.claimDetails = new Case();        
    this.Phone=parentWorkOrder.Case.Contact.Phone;
    this.Address=parentWorkOrder.Case.Full_Risk_Address__c;
    this.State=parentWorkOrder.Case.State1__c;
    claimDetails.Id = parentWorkOrder.Case.Id;
    claimDetails.Description = parentWorkOrder.Case.Description;
    claimDetails.Status = parentWorkOrder.Case.Status;
    claimDetails.Building_height__c = parentWorkOrder.Case.Building_height__c;
    claimDetails.Roof_type__c = parentWorkOrder.Case.Roof_type__c;
    claimDetails.Insurable__c = parentWorkOrder.Case.Insurable__c;
    claimDetails.Cause__c = parentWorkOrder.Case.Cause__c;
    claimDetails.Cause_Detail__c = parentWorkOrder.Case.Cause_Detail__c;
    claimDetails.Contents_Damaged__c = parentWorkOrder.Case.Contents_Damaged__c; 
    claimDetails.Contents_Damaged_Comments__c = parentWorkOrder.Case.Contents_Damaged_Comments__c;
    claimDetails.Maintenance_Required__c = parentWorkOrder.Case.Maintenance_Required__c;
    claimDetails.Maintenance_Details__c = parentWorkOrder.Case.Maintenance_Details__c;
    claimDetails.Cash_Settlement__c = parentWorkOrder.Case.Cash_Settlement__c;
    claimDetails.Cash_Settlement_Reason__c = parentWorkOrder.Case.Cash_Settlement_Reason__c;
    claimDetails.Cash_Settlement_Comments__c = parentWorkOrder.Case.Cash_Settlement_Comments__c;
    claimDetails.Temporary_Accommodation_Required__c = parentWorkOrder.Case.Temporary_Accommodation_Required__c;
    claimDetails.Temporary_Accommodation_Reason__c = parentWorkOrder.Case.Temporary_Accommodation_Reason__c;
    claimDetails.Repair_OH_S__c = parentWorkOrder.Case.Repair_OH_S__c;
    claimDetails.Asbestos__c = parentWorkOrder.Case.Asbestos__c;
    claimDetails.Safety_Repair_Working_Heights__c = parentWorkOrder.Case.Safety_Repair_Working_Heights__c;
    claimDetails.Potential_Risks_To_Trades__c = parentWorkOrder.Case.Potential_Risks_To_Trades__c;
    claimDetails.Potential_Risk_Comments__c = parentWorkOrder.Case.Potential_Risk_Comments__c;
    claimDetails.Job_Readiness__c = parentWorkOrder.Case.Job_Readiness__c;
    claimDetails.Claim_Proceeding__c = parentWorkOrder.Case.Claim_Proceeding__c;  
    claimDetails.Report_Type__c = parentWorkOrder.Case.Report_Type__c;
    claimDetails.Awaiting_Report_Comments__c = parentWorkOrder.Case.Awaiting_Report_Comments__c;
    claimDetails.Decline_Type__c = parentWorkOrder.Case.Decline_Type__c;
    claimDetails.Decline_Reason_Details__c = parentWorkOrder.Case.Decline_Reason_Details__c;
    claimDetails.Non_Fit_Reason__c = parentWorkOrder.Case.Non_Fit_Reason__c; 
    claimDetails.Cancelled_Reason__c = parentWorkOrder.Case.Cancelled_Reason__c;
    claimDetails.Report_Item_Comments__c = parentWorkOrder.Case.Report_Item_Comments__c;        
    claimDetails.Other_Building_Height__c = parentWorkOrder.Case.Other_Building_Height__c;
    claimDetails.Other_Roof_Type__c = parentWorkOrder.Case.Other_Roof_Type__c;
    claimDetails.Policy__c = parentWorkOrder.Case.Policy__c;
    claimDetails.Additional_Comments__c=parentWorkOrder.Case.Additional_Comments__c;
    claimDetails.Contents_Damaged_Appoint_Restorer__c = parentWorkOrder.Case.Contents_Damaged_Appoint_Restorer__c;
    claimDetails.Contents_Damaged_Restorer_Comments__c =parentWorkOrder.Case.Contents_Damaged_Restorer_Comments__c;
    claimDetails.Building_Restoration_Details__c=parentWorkOrder.Case.Building_Restoration_Details__c;
    claimDetails.Building_Restoration__c = parentWorkOrder.Case.Building_Restoration__c;
    claimDetails.Building_Restoration_Type__c = parentWorkOrder.Case.Building_Restoration_Type__c;
    claimDetails.Building_Restoration_Appoint_Restorer__c = parentWorkOrder.Case.Building_Restoration_Appoint_Restorer__c;
    claimDetails.Building_Restoration_Restorer_Comments__c = parentWorkOrder.Case.Building_Restoration_Restorer_Comments__c;
    claimDetails.Customer_Onsite__c  = parentWorkOrder.Case.Customer_Onsite__c;
    this.selectOptions = fieldToPicklistValues;
    this.declineReasonOptions = declineReasonValues;
    this.attachments = attachments;
}
}