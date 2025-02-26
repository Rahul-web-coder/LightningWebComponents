import { LightningElement, wire } from 'lwc';
import {getRecord} from 'lightning/uiRecordApi';
import Id from '@salesforce/user/Id';
import NAME_FIELD from '@salesforce/schema/User.Name';
import EMAIL_FIELD from '@salesforce/schema/User.Email';
const fields = [NAME_FIELD, EMAIL_FIELD];
export default class WireDemoUserDetail extends LightningElement {
    userID  = Id
    //005dL000004Ud1uQAC

    userDetails
    @wire(getRecord, {recordId:'$userID', fields})
    userDetailHandler({data, error}){
        if(data){
            this.userDetails = data.fields;
        }
        if(error){
            console.log(error)
        }
    }

   
    @wire(getRecord, {recordId:'$userID', fields})
    userDetailProperty
}