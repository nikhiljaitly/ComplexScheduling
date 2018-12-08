Global class AddClaimCommentForClaim{
      @ InvocableMethod
      public static void addClaimComment(List<String> vendorNoteId) {
        List<Vendor_Note__c> vendorNoteList = [SELECT Id,Claim__c,Text__c,Category__c FROM Vendor_Note__c WHERE id in :vendorNoteId];
         system.debug('vendorNoteList '+vendorNoteList);
         List<CaseComment> claimCommentList = new List<CaseComment>();
         for (Vendor_Note__c cc : vendorNoteList) {
            CaseComment newCom = new CaseComment();
            newCom.CommentBody = cc.Category__c+' --> '+cc.Text__c;
            newCom.IsPublished = TRUE;
            newCom.ParentId = cc.Claim__c; 
            claimCommentList.add(newCom);                 
         }
         system.debug('claimCommentList '+claimCommentList);
         if(claimCommentList.size() > 0){
             insert claimCommentList ;
         }         
     return;
  }
}