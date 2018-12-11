public class ContentDocumentLinkHandler implements ITrigger {
   public ContentDocumentLinkHandler() {}
    
    public void bulkBefore() {
        system.debug('Entering bulkBefore ContentDocumentLinkHandler');
        List<ContentDocumentLink> contentDocumentLinkList=(List<ContentDocumentLink>) Trigger.New;
        for(ContentDocumentLink cont : contentDocumentLinkList){ 
            cont.Visibility = 'V';
            cont.Visibility = 'AllUsers'; 
        }
        system.debug('Exiting bulkBefore ContentDocumentLinkHandler');
    }
    public void bulkAfter() {
        
    }
    public void beforeInsert(SObject so) {
    } 
    public void afterInsert(SObject so) {
    } 
    public void beforeUpdate(SObject oldSo, SObject so) {

    }
    public void beforeUnDelete(SObject so) {} 
    
    public void afterUpdate(SObject oldSo, SObject so) {} 
    public void beforeDelete(SObject so){} 
    public void afterDelete(SObject so) {} 
    public void afterUnDelete(SObject so) {} 
    public void andFinally() {                        
    }               
}