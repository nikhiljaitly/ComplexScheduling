public with sharing class ABNValidator {
    @AuraEnabled
    public static String searchABN(String abn) {
        string includeHistoricalDetails = 'Y';
        string authenticationGuid = '38168094-5abb-4b4a-a5e7-cc2911ae53d0';
        //build the URL
        /*String url = 'http://abr.business.gov.au/ABRXMLSearch/AbrXmlSearch.asmx/SearchByABNv201408?'+
                     'searchString='+abn+'&includeHistoricalDetails='+includeHistoricalDetails+
                     '&authenticationGuid='+authenticationGuid; */
        string url = 'http://abr.business.gov.au/json/AbnDetails.aspx?'+
                     'abn='+abn+'&guid='+authenticationGuid+'&callback=ABNCallback';



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
}