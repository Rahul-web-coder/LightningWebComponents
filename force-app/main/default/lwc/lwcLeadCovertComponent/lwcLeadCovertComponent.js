import { LightningElement, api, track } from 'lwc';
import convertLead from '@salesforce/apex/LeadConversionController.convertLead';

export default class LwcLeadCovertComponent extends LightningElement {
    @api recordId; 
    @track message;

    handleConvertLead(){
        convertLead({leadId: this.recordId}).then((result)=> {
            this.message = result;
        }).catch((error)=>{
            this.message = 'Error: ' + error.body.message;
        });
    }

    closeModal() {
        console.log('Inside Close Model');
          window.location.reload();
    }
}