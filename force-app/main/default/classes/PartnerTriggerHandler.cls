/**
 * @description       : 
 * @author            : Rahul Mahato
 * @group             : 
 * @last modified on  : 01-24-2025
 * @last modified by  : Rahul Mahato
**/
public with sharing class PartnerTriggerHandler {
   @InvocableMethod
   public static void handlePartnerInsert(List<Partner__c> partners){

    System.debug('Partner Record ID ----> ' + partners);
    List<Task> taskToCreate = new List<Task>();
    List<Opportunity> opportunityToUpdate = new List<Opportunity>();

    for(Partner__c partner : partners){
            if(partner.Opportunity__c != null){

                Task task = new Task();
                task.WhatId = partner.Opportunity__c;
                task.Priority = 'High';
                task.Status = 'Not Started';
                Opportunity opp = new Opportunity();
                opp.Id = partner.Opportunity__c;

                if(partner.Role__c != null && partner.Role__c == 'To Do'){
                    task.Subject = 'To Do Task';
                    task.Description = 'A new Partner To Do Task'; 
                    opp.StageName = 'To Do';
                }
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
                
                taskToCreate.add(task);
                opportunityToUpdate.add(opp);
    
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
}