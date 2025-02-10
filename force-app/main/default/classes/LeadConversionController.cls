/**
 * @description       : 
 * @author            : Rahul Mahato
 * @group             : 
 * @last modified on  : 02-05-2025
 * @last modified by  : Rahul Mahato
**/
public with sharing class LeadConversionController {

   static final String LEAD_ALREADY_CONVERTED = 'Lead Already Converted';
   static final String LEAD_CONVERSION_FAILED = 'Failed to Convert the Lead';
   static final String LEAD_CONVERSION_SUCCESS_STATUS = 'Success';
   static final String LEAD_CLOSED_STATUS = 'Closed - Converted';

   /**
   * @description Custom Apex method to convert Lead.
   * @author Rahul Mahato | 02-05-2025 
   * @param leadId 
   * @return string 
   **/
   @AuraEnabled
   public static string convertLead(Id leadId){
        try {
            Lead lead = [SELECT Id, IsConverted FROM Lead WHERE Id = :leadId WITH SYSTEM_MODE];
            if(lead.IsConverted){
                return LEAD_ALREADY_CONVERTED;
            }

            Database.LeadConvert leadConvert = new Database.LeadConvert();
            leadConvert.setLeadId(leadId);
            leadConvert.setConvertedStatus(LEAD_CLOSED_STATUS);

            // Perform the Lead Conversion
            Database.LeadConvertResult result = Database.convertLead(leadConvert);

            if(result.isSuccess()){
                return LEAD_CONVERSION_SUCCESS_STATUS;
            }
            else{
                return LEAD_CONVERSION_FAILED;
            }
        }
        catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }
}