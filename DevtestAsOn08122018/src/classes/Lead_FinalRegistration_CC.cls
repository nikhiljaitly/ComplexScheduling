/************************************************************************************************************
Name:  Lead_FinalRegistration_CC
=============================================================================================================
Purpose: Retrieves and updates Lead details for Lead Final Registration for Trade
Called by: LeadFinalRegistration.cmp (Trade Portal component)
===============================================================================================================
History
-----------
VERSION    AUTHOR       DATE             DETAIL        DESCRIPTION
1.0        Vasu         09/02/2018      Created      Home Repairs Claims system
*************************************************************************************************************/
public class Lead_FinalRegistration_CC {
/***************************************************************** 
Purpose: Retrieves Lead details                                                    
Parameters: Lead Id
Returns: Returns Lead
Throws [Exceptions]: None                                                          
History                                                             
--------                                                            
VERSION        AUTHOR         DATE           DETAIL   Description 
1.0            Vasu           09/02/2018      Created      Home Repairs Claims system 
*******************************************************************/
    @AuraEnabled
    public static Lead getLead(Id leadId){
        system.debug('Entering  getLead: ' + 'Lead Id: ' + leadId );
        Lead selectLead = [SELECT Id, LastName, FirstName, Name, Title, Company, Street, City, State, 
                           PostalCode, Country, Phone, Email, Website, Description, Status, Industry, Rating, AnnualRevenue, 
                           Registered_Trading_Name__c, ABN__c, ABN_Status__c, Main_Business_Phone__c, 
                           Alternate_Phone__c, 
                           Registered_for_GST__c, ACN__c, Preferred_Business_Name__c, 
                           Business_Email_Address__c, Accounts_Email_Address__c, Business_Structure__c, When_did_your_business_commence_trading__c, Job_Related_First_Name__c, Job_Related_Position_in_Company__c, Job_Email__c, 
                           Job_Related_Phone__c, JR_Alernate_Phone__c, Accounts_First_Name__c, 
                           AC_Position_in_Company__c, Accounts_Phone__c, Accounts_Alt_Phone__c, 
                           Bank_Account_Name__c, BSB__c, Account_Number__c, Work_Cover_Insurance_Provider__c, 
                           Work_Cover_Insurance_State__c, Work_Cover_Amount__c, Work_Cover_Expiry__c, 
                           Public_Liability_Insurance_Provider__c, Public_Liability_Cover_Amount__c, 
                           Public_Liability_Expiry__c, Other_Insurance_Policies__c, 
                           Safe_Work_Method_Statement_Agreement__c, Any_previous_issues__c,Referred__c, 
                           Any_previous_complaints__c, Any_current_work_orders__c, Specify_the_areas_you_currently_work_in__c,
                           Any_previous_work__c, Specify_the_areas_previously_worked_in__c,
                           Postal_Street__c, Postal_Suburb__c, Postal_Postcode__c, Postal_State__c, 
                           Accounts_Last_Name__c, Job_Related_Last_Name__c,Additional_comments__c,
                           (Select Id, Trade_Type__c,License_Number__c, License_Expiry__c,Status__c from  Trade_Types__r) 
                           FROM Lead WHERE id = :leadId];
         system.debug('Exiting  getLead: ' + 'selectLead: ' + selectLead);
         return selectLead;
    }
 /***************************************************************** 
Purpose: Get Lead and Trade Compliances Attachments 
Returns: Returns message
Throws [Exceptions]: DML exception                                                        
History                                                             
--------                                                            
VERSION        AUTHOR         DATE           DETAIL   Description 
1.0            Alvin           01/09/2018     Created  Home Repairs Claims system
*******************************************************************/
 @AuraEnabled
    public static List<Attachment> getFiles(String leadId){
        List<Attachment> attachments = [Select Id,Name,Description, ParentId from attachment where parentId = :leadId ];
        return attachments;        
    }   
    
 /***************************************************************** 
Purpose: Update Lead details on final submit                                                   
Parameters: Lead details from final registration form
Returns: Returns message
Throws [Exceptions]: DML exception                                                        
History                                                             
--------                                                            
VERSION        AUTHOR         DATE           DETAIL   Description 
1.0            Vasu           09/02/2018     Created  Home Repairs Claims system
*******************************************************************/
    @AuraEnabled
    public static string updateFinalRegLead(Lead finalRegLead){
         system.debug('Entering  updateFinalRegLead: ' + 'finalRegLead: ' + finalRegLead );
        finalRegLead.Status='2nd Form Submitted';
        try{
             upsert finalRegLead;
        } catch(DMLException e) {
                system.debug('Error upserting lead- ' + e.getMessage());
            }
        system.debug('Exiting  updateFinalRegLead: ' + 'finalRegLead: ' + finalRegLead );
        return 'Update Successfully';        
    }
     /***************************************************************** 
Purpose: Delete Files                                                  
Parameters: Delete files uploaded by the trade portal visitor
Returns: Returns message
Throws [Exceptions]: DML exception                                                        
History                                                             
--------                                                            
VERSION        AUTHOR         DATE           DETAIL   Description 
1.0            Mathew        12/03/2018     Created  Home Repairs Trade Portal
*******************************************************************/
    @AuraEnabled
    public static string deleteFiles(Id fileId){
         system.debug('Entering  deleteFiles: ' + 'fileId: ' + fileId );
         attachment attachmentRecord = [Select Id,Name,Description from attachment where Id = :fileId Limit 1];

        try{
             if(attachmentRecord != NULL){
               delete attachmentRecord;
             }
        } catch(DMLException e) {
                system.debug('Error upserting lead- ' + e.getMessage());
            }
        system.debug('Exiting  deleteFiles: ' + 'attachmentRecord: ' + attachmentRecord.Id );
        return 'deleted success';        
    }
}