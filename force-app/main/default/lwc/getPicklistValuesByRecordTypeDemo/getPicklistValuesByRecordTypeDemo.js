import { LightningElement, wire} from 'lwc';
import { getObjectInfo, getPicklistValuesByRecordType } from 'lightning/uiObjectInfoApi';
import ACCOUNT_OBJECT from '@salesforce/schema/Account';
export default class GetPicklistValuesByRecordTypeDemo extends LightningElement {

        selectedRating = '';
        selectedIndustry = '';
        ratingOptions = [];
        industryOptions = [];

        @wire(getObjectInfo, {objectApiName: ACCOUNT_OBJECT})
        getAccountInfo
    
        @wire(getPicklistValuesByRecordType, { objectApiName: ACCOUNT_OBJECT, recordTypeId: '$getAccountInfo.data.defaultRecordTypeId' })
        getAccountPicklistValues({data,error}) {
            if(data){
                console.log('picklist',data);
                this.ratingOptions = this.getPicklistValuesGenerator(data.picklistFieldValues.Rating)
                this.industryOptions = this.getPicklistValuesGenerator(data.picklistFieldValues.Industry)
            }
            if(error){
                 console.error(error);
            }
        }

        getPicklistValuesGenerator(data){
            return data.values.map(item=>({label: item.label, value: item.value}))
        }

        handleChange(event){
            const {name,value} = event.target
            console.log(name + '==>' + value)

            if(name === 'Rating'){
                this.selectedRating = event.target.value;
            }

            if(name === 'Industry'){
                this.selectedIndustry = event.target.value;
            }
        }
}
