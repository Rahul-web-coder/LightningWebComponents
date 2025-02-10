/**
 * @description       : 
 * @author            : Rahul Mahato
 * @group             : 
 * @last modified on  : 02-05-2025
 * @last modified by  : Rahul Mahato
**/
public with sharing class PartnerTriggerHandler {

    static final String TO_DO_STAGE = 'To Do';
    static final String READY_TO_MOVE_STAGE = 'Ready To Move';
    static final String DONE_STAGE = 'Done';
    static final String IN_PROGRESS_STAGE = 'In Progress';
    static final String YOU_CANNOT_UPDATE_OPPORTUNITY = 'You cannot update this Opportunity because there are open tasks associated with it.';
    static final String COMPLETED_STATUS = 'Completed';
    static final String OPEN_STATUS = 'Open';
    static final String NO_PERMISSION_CREATE_TASK = 'You do not have permission to create a Task.';
    static final String NO_PERMISSION_UPDATE_OPPORTUNITY = 'You do not have permission to update the Opportunity.';
    static final String NOT_STARTED_STATUS = 'Not Started';
    static final String HIGH_PRIORITY = 'High';
    
   /**
   * @description 
   * @author Rahul Mahato | 02-05-2025 
   * @param partners 
   **/
   @InvocableMethod
   public static void handlePartnerInsert(List<Partner__c> partners){

    try{
            Id oppID; 
            List<Task> taskToCreate = new List<Task>();
            List<Opportunity> opportunityToUpdate = new List<Opportunity>();
            Opportunity opp = new Opportunity();

            for(Partner__c partner : partners){
                    if(partner.Opportunity__c != null){

                        oppID =  partner.Opportunity__c;
                        
                        getTaskCount(oppId);

                        Task task = new Task();

                        task = createTask(oppId, partner, opp);

                        opportunityToUpdate.add(opp);
                        
                        if(partner.Role__c != null && partner.Role__c != TO_DO_STAGE){
                           taskToCreate.add(task);
                        }
            
                    }
                }

                checkTaskToCreate(taskToCreate);

                checkOpportunityToUpdate(opportunityToUpdate);

        }catch(Exception e){
               throw new MyException(e.getMessage());
        }
    }

    /**
    * @description 
    * @author Rahul Mahato | 02-05-2025 
    * @param oppId
    **/
    public static void getTaskCount(Id oppId){
        Integer taskCount = [SELECT COUNT() FROM Task WHERE WhatId = :oppID AND Status != :COMPLETED_STATUS WITH SYSTEM_MODE];
        if(taskCount > 0){
            throw new MyException(YOU_CANNOT_UPDATE_OPPORTUNITY);
        }
    }
   
    /**
    * @description 
    * @author Rahul Mahato | 02-05-2025 
    * @param oppId 
    * @param partner 
    * @param opp 
    * @return Task 
    **/
    public static Task createTask(Id oppId, Partner__c partner, Opportunity opp){
        Task task = new Task();
        task.WhatId = oppId;
        task.Priority = HIGH_PRIORITY;
        task.Status = NOT_STARTED_STATUS;
        task.Opportunity__c = oppId;
        opp.Id = oppId;

        if(partner.Role__c != null && partner.Role__c == IN_PROGRESS_STAGE){
            task.Subject = IN_PROGRESS_STAGE;
            task.Description = IN_PROGRESS_STAGE;
            opp.StageName = IN_PROGRESS_STAGE;
        }
        if(partner.Role__c != null && partner.Role__c == READY_TO_MOVE_STAGE){
            task.Subject = READY_TO_MOVE_STAGE;
            task.Description = READY_TO_MOVE_STAGE;
            opp.StageName = READY_TO_MOVE_STAGE;
        }

        if(partner.Role__c != null && partner.Role__c == DONE_STAGE){
            task.Subject = DONE_STAGE;
            task.Description = DONE_STAGE;
            opp.StageName = DONE_STAGE;
        }

        return task;
    }

    /**
    * @description 
    * @author Rahul Mahato | 02-05-2025 
    * @param taskToCreate 
    **/
    public static void checkTaskToCreate(List<Task> taskToCreate){

        if(!taskToCreate.isEmpty()){
            try{
                if (Schema.sObjectType.Task.isCreateable()) {
                    insert taskToCreate;
                } else {
                    throw new MyException(NO_PERMISSION_CREATE_TASK);
                }
            }catch(Exception e){
                throw new MyException(e.getMessage());
            }
        }
    }

    /**
    * @description 
    * @author Rahul Mahato | 02-05-2025 
    * @param opportunityToUpdate 
    **/
    public static void checkOpportunityToUpdate(List<Opportunity> opportunityToUpdate){

        if(!opportunityToUpdate.isEmpty()){
            try{
                if (Schema.sObjectType.Opportunity.isUpdateable()) {
                    update opportunityToUpdate;
                } else {
                    throw new MyException(NO_PERMISSION_UPDATE_OPPORTUNITY);
                }

            }catch(Exception e){
                throw new MyException(e.getMessage());
            }
        }
    }
}