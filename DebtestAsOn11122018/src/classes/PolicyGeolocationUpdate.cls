Global class PolicyGeolocationUpdate {
    @ InvocableMethod
        public static void updatePolicyGeolocation(List<String> policy) {
            policyGeolocationCallout(policy);         
            //return;
        }
    public static void policyGeolocationCallout(List<String> policy) {
        List<Policy__c> poList=[SELECT AddressLine1__c,AddressLine2__c,AddressLine3__c,Suburb__c,State__c,Postcode__c,Policy_Location__c FROM Policy__c WHERE id =: policy limit 1];
        if(poList.size() > 0){
            Policy__c po=poList[0];
            String address = '';
            if(po.AddressLine1__c != null)
                address += po.AddressLine1__c +', ';            
            if(po.AddressLine2__c != null)            
                address += po.AddressLine1__c +', ';
            if(po.AddressLine3__c != null)            
                address += po.AddressLine3__c +', ';            
            if(po.Suburb__c != null)            
                address += po.Suburb__c +', ';
            if(po.State__c != null)
                address += po.State__c+', '; 
            if(po.Postcode__c != null)
                address += po.Postcode__c ;
            
            address = EncodingUtil.urlEncode(address, 'UTF-8');
            //build callout
            Http h = new Http();            
            HttpRequest req = new HttpRequest();            
            req.setEndpoint('http://maps.googleapis.com/maps/api/geocode/json?address='+address+'&sensor=false');            
            req.setMethod('GET');            
            req.setTimeout(5000);
            try{
                HttpResponse res;
                String resBody='';  
                if(Test.isRunningTest()){
                    String str = '{' +
                    '   "results" : [' +
                    '      {' +
                    '         "geometry" : {' +
                    '            "location" : {' +
                    '               "lat" : 37.79410130,' +
                    '               "lng" : -122.39510960' +
                    '            }'+        
                    '          }' +
                    '      }' +
                    '   ],' +
                    '   "status" : "OK"' +
                    '}';
                    resBody=str;
                }else{
                    res = h.send(req);
                    resBody=res.getBody();
                }
                // parse coordinates from response                
                JSONParser parser = JSON.createParser(resBody);                
                double lat = null;                
                double lon = null;
                while (parser.nextToken() != null) {
                    if ((parser.getCurrentToken() == JSONToken.FIELD_NAME) && (parser.getText() == 'location')){
                        parser.nextToken(); // object start                        
                        while (parser.nextToken() != JSONToken.END_OBJECT){
                            String txt = parser.getText();
                            parser.nextToken();
                            if (txt == 'lat')
                                lat = parser.getDoubleValue();
                            else if (txt == 'lng')
                                lon = parser.getDoubleValue();
                            
                        }
                    }
                }
                // update coordinates if we get back                
                po.Policy_Location__Latitude__s= lat;
                po.Policy_Location__Longitude__s = lon;  
                system.debug('po :'+po );
                update po;                  
            }catch (Exception e) {
                system.debug(e);
                
            }
        }
    }  
}