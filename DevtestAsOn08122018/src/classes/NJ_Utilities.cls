/**
* Util class
* @author : Nikhil Jaitly
* @Created Date : 24/10/2018
* */
public with sharing class NJ_Utilities {
  /**
   * Get  pick list values of field from an object
   * @author : Nikhil Jaitly
   * @Param : obj - Object
   * @Param : fld - Field Name
   * @Created Date : 24/10/2018
   * */
   public static List<NJ_SelectOptionLightning> getPicklistValues(SObjectType sObjectType, String fld){
      List<NJ_SelectOptionLightning> options = new List<NJ_SelectOptionLightning>();
      Schema.DescribeSObjectResult objDescribe = sObjectType.getDescribe();
      Map<String, Schema.SObjectField> fieldMap = objDescribe.fields.getMap();
      List<Schema.PicklistEntry> values = fieldMap.get(fld).getDescribe().getPickListValues();
      for (Schema.PicklistEntry a : values) {
        options.add(new NJ_SelectOptionLightning(a.getLabel(), a.getValue()));
      }
      return options;
    }
}