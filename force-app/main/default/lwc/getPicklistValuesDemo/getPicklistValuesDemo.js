import { LightningElement, wire } from 'lwc';
import { getObjectInfo, getPicklistValues } from 'lightning/uiObjectInfoApi';
import INDUSTRY_FIELD from '@salesforce/schema/Account.Industry';
import ACCOUNT_OBJECT from '@salesforce/schema/Account';
import TYPE_FIELD from '@salesforce/schema/Account.Type';
export default class GetPicklistValuesDemo extends LightningElement {

    selectedType = '';
    selectedIndustry = '';
    industryOptions =[];
    typeOptions = [];
    
    @wire(getObjectInfo, {objectApiName: ACCOUNT_OBJECT})
    objectInfo

    @wire(getPicklistValues, { recordTypeId: '$objectInfo.data.defaultRecordTypeId', fieldApiName: INDUSTRY_FIELD})
    picklistValues({data,error}){
        if(data){
            console.log('picklist values --->',data);
            this.industryOptions = [...this.generatePicklist(data)]
        }

        if(error){
            console.log(error);
        }

    }

    /*Second picklist for type */
    @wire(getPicklistValues, { recordTypeId: '$objectInfo.data.defaultRecordTypeId', fieldApiName: TYPE_FIELD})
    typepicklistValues({data,error}){
        if(data){
            console.log(data);
            this.typeOptions = [...this.generatePicklist(data)]
        }

        if(error){
            console.log(error);
        }

    }

    handleTypeChange(event) {
        this.selectedType = event.detail.value;
    }



    // get options() {
    //     return [
    //         { label: 'New', value: 'new' },
    //         { label: 'In Progress', value: 'inProgress' },
    //         { label: 'Finished', value: 'finished' },
    //     ];
    // }

    generatePicklist(data){

        return data.values.map(item=>({ label: item.label, value: item.value }))
    }
    handleChange(event) {
        this.selectedIndustry = event.detail.value;
    }

}