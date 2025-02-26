import { LightningElement } from 'lwc';
import filterAccountListType from '@salesforce/apex/AccountController.filterAccountListType';
export default class ApexImperativeWithParamsDemo extends LightningElement {
    searchKey = '';
    accounts
    timer
    searchHandler(event){
        window.clearTimeout(this.timer)
        this.searchKey = event.target.value;
        this.timer = setTimeout(()=>{
            this.callApex()
        }, 1000)
    }

    callApex(){
        filterAccountListType({searchKey: this.searchKey}).then(result=>{
            this.accounts = result
        }).catch(error=>{
            console.error(error)
        })
    }
}