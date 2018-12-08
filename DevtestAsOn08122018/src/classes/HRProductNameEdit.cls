public class HRProductNameEdit {
    public static List<Product2> editNames(List<Product2> productNames){
        
    	system.debug('old names: ' + productNames);
        
        List<Product2> updatedNames = new List<Product2>();
        
        for(Product2 product : productNames){
            String Name = product.Name;
            String target = ' - N/A';
            String replacement = ' ';
            
            String newName = Name.replace(target, replacement);
            product.Name = newName;
            
            updatedNames.add(product);
        }
        
        system.debug('new names: ' + updatedNames);
        upsert productNames;
        return updatedNames;
    } 
}