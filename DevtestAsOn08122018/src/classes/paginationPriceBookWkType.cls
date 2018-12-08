public with sharing class paginationPriceBookWkType {
     @AuraEnabled
     public list<pricebookentry> pbe;
      
     @AuraEnabled
     public integer offst;
      
     @AuraEnabled
     public integer total;
      
     @AuraEnabled
     public boolean hasprev;
      
     @AuraEnabled
     public boolean hasnext;
 
     private static integer pagesize=9;
     private static integer offset;
      
     @AuraEnabled
     public static paginationPriceBookWkType getpbe(boolean next,boolean prev,decimal off,string searchKeyWord){
        offset = (integer)off;
        system.debug('offset ' + offset);
        String searchKey = '%' + searchKeyWord + '%';
        system.debug('##searchKey ' + searchKey);
        integer listlength;
        
        list<pricebookentry> li = new list<pricebookentry>();         
             listlength = [Select count() from pricebookentry where name LIKE: searchKey];
         
        if(!schema.sobjecttype.PricebookEntry.isaccessible()){
            li = new list<pricebookentry>();
        }else{
         if(next==false && prev==false){
         system.debug('Query ' + [select id, Name, ProductCode from PricebookEntry where Name LIKE: searchKey LIMIT :pagesize OFFSET :offset]);
         li = [select id, Name, ProductCode from PricebookEntry where Name LIKE: searchKey LIMIT :pagesize OFFSET :offset];
         }else if(next==true && (offset+pagesize)<=listlength){
              offset=offset+pagesize;
             system.debug('Next Offset ' + offset);
          li = [select id, Name, ProductCode from PricebookEntry where Name LIKE: searchKey LIMIT :pagesize OFFSET :offset];
         }else if(prev==true && offset>0){
          offset=offset-pagesize;
          li = [select id, Name, ProductCode from PricebookEntry where Name LIKE: searchKey LIMIT :pagesize OFFSET :offset];
         }
         }
        paginationPriceBookWkType pg = new paginationPriceBookWkType();
        pg.pbe = li;
        pg.offst = offset;
        pg.hasprev = hasprev(offset);   
            pg.hasnext = hasnxt(offset,listlength,pagesize);
             
            return pg;
         }
          
         private static boolean hasprev(integer off){
            if(off>0)
                return false;
            return true; 
        }
        private static boolean hasnxt(integer off,integer li,integer ps){
        system.debug('off ' + off);
        if(off+ps<li)
            return false;
        return true;
    } 
    
    
    @AuraEnabled 
    public static List <Pricebook2> fetchCostsValues(String PricebookEntryId){
        List <Pricebook2> returnList = new List <Pricebook2> ();
        try {   
            List<PricebookEntry> pricebookEntryList = [Select ID, Product2Id, Pricebook2Id, ProductCode
                                                       FROM PricebookEntry 
                                                       WHERE Id =: PricebookEntryId
                                                      ];
          
          //Enable again while displaying in actual page
          /*  List<WorkOrder> woList = [Select ID, Risk_State__c
                                      FROM WorkOrder 
                                      WHERE Id =: woRecId
                                     ];*/
            
            returnList = [Select ID, Name, Labour_Price__c, Material_Price__c, Labour_TIME_mins__c,State__c
                            FROM Pricebook2 
                            WHERE Id =: pricebookEntryList[0].Pricebook2Id AND
                            State__c ='VIC' AND
                            //State__c =: woList[0].Risk_State__c AND
                            IsActive = true
                            ];
            
           // string priceBookSrch = pricebookEntryList[0].ProductCode + '-' + woList[0].Risk_State__c;
             string priceBookSrch = pricebookEntryList[0].ProductCode + '-' + 'VIC';
            system.debug('priceBookSrch ' + priceBookSrch);
            returnList = [Select ID, Name, Labour_Price__c, Material_Price__c, Labour_TIME_mins__c,State__c
                          FROM Pricebook2 
                          WHERE Name Like:priceBookSrch AND
                          IsActive = true
                         ];
            
        }// try ends
        
        catch (System.QueryException se) {
        }
        finally {}
        return returnList;
    } 
    

}