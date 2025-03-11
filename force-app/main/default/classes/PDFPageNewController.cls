/**
 * @description       : 
 * @author            : Rahul Mahato
 * @group             : 
 * @last modified on  : 03-10-2025
 * @last modified by  : Rahul Mahato
**/
public with sharing class PDFPageNewController {
    public String pdfText{get;set;}
    public PDFPageNewController(){
        pdfText = String.escapeSingleQuotes(
            ApexPages.currentPage().getParameters().get('pdfText')
        );
    }
}