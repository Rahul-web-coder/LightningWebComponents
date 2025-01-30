/**
 * @description       : 
 * @author            : Rahul Mahato
 * @group             : 
 * @last modified on  : 01-28-2025
 * @last modified by  : Rahul Mahato
**/
public with sharing class PartnerTriggerHandler {
    public static Boolean isTriggerActive = true;

   @InvocableMethod
   public static void handlePartnerInsert(List<Partner__c> partners){

    try{
            System.debug('Partner Record ID ----> ' + partners);
            PartnerTriggerHandler.isTriggerActive = false;
            Id oppID; 
            List<Task> taskToCreate = new List<Task>();
            List<Opportunity> opportunityToUpdate = new List<Opportunity>();
            Opportunity opp = new Opportunity();

            for(Partner__c partner : partners){
                    if(partner.Opportunity__c != null){

                        oppID =  partner.Opportunity__c;
                        Integer taskCount = [SELECT COUNT() FROM Task WHERE WhatId = :oppID AND Status != 'Completed'];
                        if(taskCount > 0){
                                throw new MyException('You cannot update this Opportunity because there are open tasks associated with it.');
                        }

                        Task task = new Task();
                        task.WhatId = partner.Opportunity__c;
                        task.Priority = 'High';
                        task.Status = 'Not Started';
                        task.Opportunity__c = partner.Opportunity__c;
                        opp.Id = partner.Opportunity__c;

                        if(partner.Role__c != null && partner.Role__c == 'In Progress'){
                            task.Subject = 'In Progress Task';
                            task.Description = 'A new Partner In Progress Task'; 
                            opp.StageName = 'In Progress';
                        }
                        if(partner.Role__c != null && partner.Role__c == 'Ready To Move'){
                            task.Subject = 'Ready To Move Task';
                            task.Description = 'A new Partner Ready To Move Task'; 
                            opp.StageName = 'Ready To Move';
                        }

                        if(partner.Role__c != null && partner.Role__c == 'Done'){
                            task.Subject = 'Done Task';
                            task.Description = 'A new Partner Done Task'; 
                            opp.StageName = 'Done';
                        }
                        opportunityToUpdate.add(opp);
                        
                        if(partner.Role__c != null && partner.Role__c != 'To Do'){
                           taskToCreate.add(task);
                        }
            
                    }
                }

                if(!taskToCreate.isEmpty()){
                    try{
                        insert taskToCreate;
                    }catch(Exception e){
                        System.debug('Error While Inseting Task: '+ e.getMessage());
                    }
                }

                if(!opportunityToUpdate.isEmpty()){
                    try{
                        update opportunityToUpdate;

                    }catch(Exception e){
                        System.debug('Error While Inseting Task: '+ e.getMessage());
                    }
                }

        }
        finally{
            PartnerTriggerHandler.isTriggerActive = true;
        }
    }
}