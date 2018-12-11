/***************************************************************** 
Purpose: Retreives Trade Items                                                        
--------                                                            
VERSION        AUTHOR         DATE           DETAIL       Description 
1.0            Vasu          22/03/2018      Created      Home Repair Claim System  
*******************************************************************/
@RestResource(urlMapping = '/homerepair/api/v1/tradeitems/*')
global with sharing class RESTTradeItemsAPI {
    /***************************************************************** 
    Purpose: Get method to retrieve Trad Type corresponding Trade Items
    Parameters:None
    Returns: List of Trade Items 
    Throws [Exceptions]: Rest exception                                                          
    History                                                             
    --------                                                            
    VERSION        AUTHOR         DATE           DETAIL   Description 
    1.0            Vasu          22/03/2018     Created  Home Repair Claim system 
    *******************************************************************/
    @HttpGet
    global static RESTTradeItemsResponseHandler GET() {

        // Initialise request context to get request parameters
        // and response handler to return results
        RestRequest req = RestContext.request;
        RESTTradeItemsResponseHandler response = new RESTTradeItemsResponseHandler();

        System.Debug(LoggingLevel.DEBUG, '***Request Context = ' + req);

        Map < string, List < RESTTradeItemWrapper >> workTypeMap = new Map < string, List < RESTTradeItemWrapper >> ();

        //Query Trade Types
        List < WorkType > workTypeList = [select id, name, (SELECT Id,Name, Unit_Cost__c, Product2.QuantityUnitOfMeasure FROM Products__r) from worktype];

        // List of Trade Items to return from API
        List < RESTTradeItemsWrapper > tradeItemsWrapperList = new List < RESTTradeItemsWrapper > ();

        //Add respective Trade Items for each Trade Type into wrapper
        if (workTypeList.size() > 0) {
            for (WorkType wt: workTypeList) {
                List < RESTTradeItemWrapper > TradeItems = new List < RESTTradeItemWrapper > ();
                if (wt.Products__r.size() > 0) {
                    for (Product2 pro: wt.Products__r) {
                        TradeItems.add(new RESTTradeItemWrapper(pro));
                    }
                    RESTTradeItemsWrapper tlw = new RESTTradeItemsWrapper(wt, TradeItems);
                    tradeItemsWrapperList.add(tlw);
                } else {
                    RESTTradeItemsWrapper tlw = new RESTTradeItemsWrapper(wt, TradeItems);
                    tradeItemsWrapperList.add(tlw);
                }
            }
            RestContext.response.addHeader('Content-Type', 'application/json');
            response.Status = 'OK';
            response.Message = 'Success';
            response.Data = tradeItemsWrapperList;
        } else {
            // no Trade Types Found
            response.Status = 'Error';
            response.ErrorCode = 'NO_RECORDS_FOUND';
            response.Message = 'No Trade Types found';
        }
        return response;

    }
}