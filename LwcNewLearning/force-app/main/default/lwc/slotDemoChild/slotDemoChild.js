import { LightningElement } from 'lwc';

export default class SlotDemoChild extends LightningElement {
    handleFooterElem(){
        const footerElem = this.template.querySelector('.slds-card__footer');

        if(footerElem){
            footerElem.classList.remove('slds-hide');
        }
    }
}