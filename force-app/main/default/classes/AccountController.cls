/**
 * @description       : 
 * @author            : Rahul Mahato
 * @group             : 
 * @last modified on  : 02-26-2025
 * @last modified by  : Rahul Mahato
**/
public with sharing class AccountController {
    
    /**
    * @description : Apex Method to get Account List.
    * @author Rahul Mahato | 02-25-2025 
    * @return List<Account> 
    **/
    @AuraEnabled(cacheable=true)
    public static List<Account> getAccountList(){
        return [SELECT Id, Name, Type, Website, Industry, AnnualRevenue FROM Account WITH SYSTEM_MODE LIMIT 5 ];
    }

     /**
    * @description : Apex Method to get Account List Filter By Type.
    * @author Rahul Mahato | 02-25-2025 
    * @param accountType The type of accounts to filter by
    * @return List<Account> 
    **/
    @AuraEnabled(cacheable=true)
    public static List<Account> filterAccountListType(String accountType){
        return [SELECT Id, Name, Type, Website, Industry, AnnualRevenue FROM Account WHERE Type =: accountType WITH SYSTEM_MODE LIMIT 5 ];
    }


    /**
    * @description : Apex Method to get Account List Filter By key.
    * @author Rahul Mahato | 02-25-2025 
    * @param searchKey The type of accounts to filter by
    * @return List<Account> 
    **/
    @AuraEnabled(cacheable=true)
    public static List<Account> filterAccountListType(String searchKey){
        String key = '%' + searchKey + '%';
        return [SELECT Id, Name, Type, Website, Industry, AnnualRevenue FROM Account WHERE  NAME LIKE :key WITH SYSTEM_MODE LIMIT 5 ];
    }

}