/**
* A trim down version of sf domain model
**/
public virtual with sharing class SObjectDomain {

  /**
   * Provides access to the data represented by this domain class
   **/
  public List<SObject> records { get; private set;}

  /**
   * Derived from the records provided during construction, provides the native describe for the standard or custom object
   **/
  public Schema.DescribeSObjectResult sObjectDescribe {get; private set;}

  /**
   * Constructs the domain class with the data on which to apply the behaviour implemented within
   **/
  public SObjectDomain(List<SObject> sObjectList)
  {
      System.debug('Why tasks'+ sObjectList);
    // Ensure the domain class has its own copy of the data
    records = sObjectList.clone(); 
    try{
    // Capture SObjectType describe for this domain class
    sObjectDescribe = records.getSObjectType().getDescribe();
    } catch(Exception ex){
        
    }
  }
  
  public virtual List<String> getIds(){
    return (List<String>) getFieldValues('Id');
    }
  public virtual List<Object> getFieldValues(String fieldName) {
      List<Object> values = new List<String>();
        for(SObject record: records) {
            values.add(record.get(fieldName));
        }
        return values;
  }
  
  public List<SObject> filterRecords(Set<String> ids){
      List<SObject> filteredRecords = new List<SObject>();
        for(SObject record: records){
            if(ids.contains(record.Id)){
                filteredRecords.add(record);
            }
        }
        return filteredRecords;
    }

}