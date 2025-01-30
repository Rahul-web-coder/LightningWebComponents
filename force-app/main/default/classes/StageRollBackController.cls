/**
 * @description       : 
 * @author            : Rahul Mahato
 * @group             : 
 * @last modified on  : 01-30-2025
 * @last modified by  : Rahul Mahato
**/

public with sharing class StageRollBackController {
    
    public class RequestWrapper{
        @InvocableVariable
        public Id oppId;

        @InvocableVariable
        public String oppStage;

        @InvocableVariable
        public List<String> taskNameList;
    }

    /**
    * @description : Rollback method to call from flow Rollback Screen Flow.
    * @author Rahul Mahato | 01-30-2025 
    * @param requestList 
    * @return List<String> 
    **/
    @InvocableMethod(label = 'Stage RollBack' description = 'Stage Rollback')
    public static List<String> doRollBack(List<RequestWrapper> requestList){
        SavePoint savepoint = Database.setSavepoint();
        List<String> messageList = new List<String>();

        try{

            for(RequestWrapper reqObj : requestList){
                updateRecordFields(reqObj.oppId, reqObj.oppStage, reqObj.taskNameList);
                messageList.add('Success');
            }

            return messageList;

        }catch(Exception e){
            Database.rollback(savepoint);
            messageList.add('Failure');
            return messageList;
        }
    }

    public static void updateRecordFields(Id oppId, String oppStage, List<String> taskNameList){
        List<Id> taskidList = new List<Id>();
        List<Id> partnerIdList = new List<Id>();

        List<Task> taskList = [ SELECT Id, Subject, Status, Opportunity__c 
                                      FROM Task 
                                      WHERE Opportunity__c =:oppId 
                                      AND Subject IN :taskNameList
                                      AND Status !='Completed'];

        for(Task taskObj : taskList){
            taskidList.add(taskObj.Id);
        }  

        List<Partner__c> partnerList =  [SELECT ID, Opportunity__c, Role__c 
                                            FROM Partner__c
                                            WHERE Opportunity__c =:oppId 
                                            AND Role__c IN :taskNameList];

        for(Partner__c partnerObj : partnerList){
            partnerIdList.add(partnerObj.Id);
        }  
        
        // Delete the tasks using the collected task IDs
        if(!taskidList.isEmpty()) {
            try {
                delete [SELECT Id FROM Task WHERE Id IN :taskidList];
                System.debug('Tasks deleted successfully: ' + taskidList.size());
            } catch(Exception e) {
                System.debug('Error deleting tasks: ' + e.getMessage());
            }
        } else {
            System.debug('No tasks to delete.');
        }

        // Delete the Partner__c records using the collected partner IDs
        if(!partnerIdList.isEmpty()) {
            try {
                delete [SELECT Id FROM Partner__c WHERE Id IN :partnerIdList];
                System.debug('Partner records deleted successfully: ' + partnerIdList.size());
            } catch(Exception e) {
                System.debug('Error deleting Partner records: ' + e.getMessage());
            }
        } else {
            System.debug('No Partner records to delete.');
        }

        // Update the Opportunity StageName
        try {
            // Query the Opportunity record
            Opportunity opp = [SELECT Id, StageName FROM Opportunity WHERE Id = :oppId LIMIT 1];
            
            // Update the StageName field
            opp.StageName = oppStage;

            // Perform the update
            update opp;
            System.debug('Opportunity StageName updated successfully to: ' + oppStage);
        } catch (Exception e) {
            System.debug('Error updating Opportunity StageName: ' + e.getMessage());
        }
    }

    
}