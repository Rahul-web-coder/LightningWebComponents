/**
 * @description       : 
 * @author            : Rahul Mahato
 * @group             : 
 * @last modified on  : 01-23-2025
 * @last modified by  : Rahul Mahato
**/
public with sharing class LeadConversionController {
   @AuraEnabled
   public static string convertLead(Id leadId){
        try {
            Lead lead = [SELECT Id, IsConverted FROM Lead WHERE Id = :leadId];
            if(lead.IsConverted){
                return 'Lead Already Converted';
            }

            Database.LeadConvert leadConvert = new Database.LeadConvert();
            leadConvert.setLeadId(leadId);
            leadConvert.setConvertedStatus('Closed - Converted');

            // Perform the Lead Conversion
            Database.LeadConvertResult result = Database.convertLead(leadConvert);

            if(result.isSuccess()){
                return 'Success';
            }
            else{
                return 'Failed to Convert the Lead';
            }
        }
        catch (Exception e) {
            throw new AuraHandledException('Error during Lead Conversion-->'+e.getMessage());
        }
    }
}