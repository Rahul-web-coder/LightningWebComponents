import { LightningElement } from 'lwc';
import getAccountList from '@salesforce/apex/AccountController.getAccountList';

export default class ApexImperativeDemo extends LightningElement {

    accounts
    handleClick(){
        getAccountList().then(data=>{
            console.log(data);
            this.accounts = data;
        }).catch(error=>{
            console.error(error)
        })
    }
}