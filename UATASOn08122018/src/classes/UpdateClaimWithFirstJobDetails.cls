Global class UpdateClaimWithFirstJobDetails{
    @ InvocableMethod
        public static void UpdateClaimWithFirstJobDetails(List<String> cases) {
            List<Case> caseList = [SELECT Id,(Select id,Action_Type__c,Source_Internal_Reference_Id__c,
                                              Status__c from Claim_Jobs__r order by Job_Number__c), First_Job_Action_Type__c,
                                   First_Job_Internal_Reference_Id__c FROM Case WHERE Id in :cases];
            system.debug('caseList '+caseList);
            String openSourceInternalReferenceId;
            String openActionType;
            String closeActionType;
            String closeSourceInternalReferenceId;
            for (Case cs : caseList) {
                openSourceInternalReferenceId='';
                openActionType = ' ';
                closeActionType = ' ';
                closeSourceInternalReferenceId='';
                if(cs.Claim_Jobs__r.size() > 0){
                    for(Claim_Job__c cj : cs.Claim_Jobs__r){
                        if(cj.Status__c=='pending' || cj.Status__c=='submitted' || cj.Status__c=='acceptinwork'){
                            openSourceInternalReferenceId=cj.Source_Internal_Reference_Id__c;
                            openActionType = cj.Action_Type__c;
                            break;
                        }else{
                            if(closeSourceInternalReferenceId == ''){
                                closeSourceInternalReferenceId=cj.Source_Internal_Reference_Id__c;
                                closeActionType = cj.Action_Type__c;
                            }
                        }
                    }
                    if(openSourceInternalReferenceId==''){
                        cs.First_Job_Internal_Reference_Id__c=closeSourceInternalReferenceId;
                        cs.First_Job_Action_Type__c=closeActionType;
                        
                    }else{
                        cs.First_Job_Internal_Reference_Id__c=openSourceInternalReferenceId;
                        cs.First_Job_Action_Type__c=openActionType;
                    }
                    
                }   
            }
            system.debug('caseList '+caseList);
            if(caseList.size() > 0){
                update caseList ;
            }
            return;
        }
}