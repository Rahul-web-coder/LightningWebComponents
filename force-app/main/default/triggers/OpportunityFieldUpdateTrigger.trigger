/**
 * @description       : 
 * @author            : Rahul Mahato
 * @group             : 
 * @last modified on  : 01-28-2025
 * @last modified by  : Rahul Mahato
**/
trigger OpportunityFieldUpdateTrigger on Opportunity (before update) {

    if (!PartnerTriggerHandler.isTriggerActive) {
        return; // Exit trigger if it is turned off
    }

    // Iterate through all Opportunities being updated
    for (Opportunity opp : Trigger.new) {
        Opportunity oldOpp = Trigger.oldMap.get(opp.Id);

        // Check if a field is updated (replace "Specific_Field__c" with your field)
        if (opp.StageName != oldOpp.StageName) {
            // Query related tasks to check for open tasks
            Integer taskCount = [
                SELECT COUNT()
                FROM Task
                WHERE WhatId = :opp.Id
                AND Status != 'Completed'
            ];

            // If the task count is greater than 0, throw an error
            if (taskCount > 0) {
                opp.addError('You cannot update this Opportunity because there are open tasks associated with it.');
            }
        }
    }
}
