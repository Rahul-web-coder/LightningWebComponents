/**
 * @description       : 
 * @author            : Rahul Mahato
 * @group             : 
 * @last modified on  : 04-22-2025
 * @last modified by  : Rahul Mahato
**/
public with sharing class CarController {
    
    /**
    * @description 
    * @author Rahul Mahato | 04-16-2025 
    * @return List<Car__c> 
    **/
    public class Filters {
        /**
        * @description Get Set variable
        * @author Rahul Mahato | 04-16-2025 
        * @return searchKey
        **/
        @AuraEnabled
        public String searchKey {get;set;}

        /**
        * @description Get Set variable
        * @author Rahul Mahato | 04-16-2025 
        * @return maxPrice
        **/
        @AuraEnabled
        public Decimal maxPrice {get;set;}

        /**
        * @description Get Set variable
        * @author Rahul Mahato | 04-16-2025 
        * @return categories
        **/
        @AuraEnabled
        public String[] categories {get;set;}

        /**
        * @description Get Set variable
        * @author Rahul Mahato | 04-16-2025 
        * @return makeType
        **/
        @AuraEnabled
        public String[] makeType {get;set;}
    }
    
    
    
    /**
    * @description 
    * @author Rahul Mahato | 04-16-2025 
    * @param filters 
    * @return List<Car__c> 
    **/
    @AuraEnabled(Cacheable=true)
    public static List<Car__c> getCars(Filters filters){
        String key;
        String whereClause ='';
        Decimal maxPrice;
        String[] categories = new List<String>{};
        String[] makeType = new List<String>{};
        String[] criteria = new List<String>{};
        if(filters !=null){
            maxPrice = filters.maxPrice;
            categories = filters.categories;
            makeType = filters.makeType;
            if(!String.isEmpty(filters.searchKey)){
                key = '%'+ filters.searchKey + '%';
                criteria.add('Name LIKE :key');
            }
            if(filters.maxPrice >= 0){
                criteria.add('MSRP__c <= :maxPrice');
            }
            if(filters.categories != null){
                criteria.add('Category__c IN :categories');
            }
            if(filters.makeType != null){
                criteria.add('Make__c IN :makeType');
            }
            if(criteria.size()>0){
                whereClause =  'WHERE ' + String.join(criteria, ' AND ');
            }
        }
        String query = 'SELECT Id, Name, MSRP__c, Description__c, Category__c, Picture_URL__c FROM Car__c ' + whereClause + ' WITH SECURITY_ENFORCED ORDER BY Name';
        return Database.query(query);
    }


    /**
    * @description 
    * @author Rahul Mahato | 04-17-2025 
    * @param carId 
    * @param makeType 
    * @return Car__c[] 
    **/
    @AuraEnabled
    public static Car__c[] getSimilarCars(Id carId, String[] makeType){
        return [SELECT Id, Name, MSRP__c, Description__c, Category__c, Picture_URL__c, Make__c FROM Car__c WHERE Make__c IN :makeType AND Id != :carId WITH SYSTEM_MODE];
    }
}
