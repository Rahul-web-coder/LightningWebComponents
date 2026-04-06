/**
 * @description       : 
 * @author            : Rahul Mahato
 * @group             : 
 * @last modified on  : 02-05-2025
 * @last modified by  : Rahul Mahato
**/

public with sharing class StageRollBackController {

    static final String STAGE_ROLLBACK = 'Stage Rollback';
    static final String STAGE_ROLLBACK_SUCCESS_STATUS = 'Success';
    static final String STAGE_ROLLBACK_FAILED_STATUS = 'Failure';
    static final String INSUFFICIENT_PRIVILEGES_TO_UPDATE_OPPORTUNITY = 'Insufficient permissions to update Opportunity StageName';
    static final String INSUFFICIENT_PRIVILEGES_TO_UPDATE_TASK = 'Insufficient permissions to update Task';
    static final String IN_PROGRESS_STAGE = 'In Progress';

    /**
    * @description : Request Wrapper StageRollbackController.
    * @author Rahul Mahato | 01-30-2025 
    **/
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
                messageList.add(STAGE_ROLLBACK_SUCCESS_STATUS);
            }

            return messageList;

        }catch(Exception e){
            Database.rollback(savepoint);
            messageList.add(STAGE_ROLLBACK_FAILED_STATUS);
            return messageList;
        }
    }

    /**
    * @description : Update task and Opportunity Stage.  
    * @author Rahul Mahato | 02-05-2025 
    * @param oppId 
    * @param oppStage 
    * @param taskNameList 
    **/
    public static void updateRecordFields(Id oppId, String oppStage, List<String> taskNameList){
        List<Task> taskidList = new List<Task>();

        // Query the Opportunity record
        Opportunity opp = [SELECT Id, StageName FROM Opportunity WHERE Id = :oppId WITH SYSTEM_MODE LIMIT 1];
            
        // Update the StageName field
        opp.StageName = oppStage;

        // Perform the update
        if (Schema.sObjectType.Opportunity.fields.StageName.isUpdateable()) {
            Database.update(opp);
        } else {
            throw new MyException(INSUFFICIENT_PRIVILEGES_TO_UPDATE_OPPORTUNITY);
        }

        List<Task> taskList = [ SELECT Id, Subject, Status, Opportunity__c 
                                      FROM Task 
                                      WHERE Opportunity__c =:oppId 
                                      AND Subject IN :taskNameList WITH SYSTEM_MODE];

        for(Task taskObj : taskList){
            taskObj.Status = IN_PROGRESS_STAGE;
            taskidList.add(taskObj);
        }  
        
        // Update the tasks using the collected task IDs
        if(!taskidList.isEmpty()) {
            try {

                if (Schema.sObjectType.Task.isUpdateable()) {
                    Database.update(taskidList);
                } else {
                    throw new MyException(INSUFFICIENT_PRIVILEGES_TO_UPDATE_TASK);
                }
            } catch(Exception e) {
                // Handle the exception appropriately, e.g., log it or rethrow it
                throw new System.DmlException(e.getMessage());
            }
        }
    } 

    
}
