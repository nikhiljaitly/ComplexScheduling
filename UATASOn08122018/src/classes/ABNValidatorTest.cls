@isTest
public class ABNValidatorTest {
    private final Static  String ABNTestWebServiceData = 'ABNCallback({"Abn":"51824753556","AbnStatus":"Active","AddressDate":"2012-01-01","AddressPostcode":"2000","AddressState":"NSW","BusinessName":[],"EntityName":"Test Comp","EntityTypeCode":"PRV","EntityTypeName":"Australian Private Company","Gst":"2012-01-01","Message":""})';
    public class RMCRequestMock implements HttpCalloutMock {
        String responseStr;
        Integer code = 200;
        public RMCRequestMock(String responseStr) {
            this.responseStr = responseStr;
        }
        public RMCRequestMock(String responseStr, Integer code) {
            this.responseStr = responseStr;
            this.code = code;
        }
        public HttpResponse respond(HttpRequest req) {
            HttpResponse res = new HttpResponse();
            res.setBody(responseStr);
            res.setStatusCode(code);
            return res;
        }
    }
    private static testmethod void testSearchABN(){
        HttpCalloutMock mock = new RMCRequestMock(ABNTestWebServiceData);
        Test.setMock(HttpCalloutMock.class, mock);
        System.assert(ABNValidator.searchABN('51 824 753 556')!= null);
        
    }

}