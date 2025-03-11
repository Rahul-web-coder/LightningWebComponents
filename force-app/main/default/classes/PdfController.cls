/**
 * @description       : 
 * @author            : Rahul Mahato
 * @group             : 
 * @last modified on  : 03-10-2025
 * @last modified by  : Rahul Mahato
**/
public with sharing class PdfController {
    @AuraEnabled
    public static Attachment generatePDF(id recordId, String htmlData){
        Pagereference page = page.renderAsPDF;
        page.getParameters().put('pdfText', htmlData);

        Contact contact = new Contact(Id=recordId);
        Attachment objAttachment = new Attachment();
        objAttachment.Name='Invoice.pdf';
        objAttachment.ParentId = contact.Id;
        objAttachment.Body = page.getContentAsPDF();
        objAttachment.IsPrivate = false;
        insert objAttachment;
        return objAttachment;
    }
}