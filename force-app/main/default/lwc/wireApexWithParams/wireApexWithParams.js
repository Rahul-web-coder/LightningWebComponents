import { LightningElement, wire } from 'lwc';
import filterAccountListType from '@salesforce/apex/AccountController.filterAccountListType';

export default class WireApexWithParams extends LightningElement {

    selectedType = '';
    @wire(filterAccountListType, {accountType: '$selectedType'})
    filteredAccounts

    get typeOptions(){
        return [
            {label:"Customer - Channel", value:"Customer - Channel"},
            {label:"Customer - Direct",value:"Customer - Direct"}
        ]
    }

    typeHandleChange(event){
        this.selectedType = event.detail.value;
    }
}