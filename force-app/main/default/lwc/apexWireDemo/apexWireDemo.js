import { LightningElement, wire } from 'lwc';
import getAccountList from '@salesforce/apex/AccountController.getAccountList';
export default class ApexWireDemo extends LightningElement {

    @wire(getAccountList)
    wiredAccounts

    accountList=[];

    @wire(getAccountList)
    accountHandler({data,error}){
        if(data){
            console.log(data);
            this.accountList = data.map(item=>{
                let newType = item.Type === 'Customer - Channel' ? 'Channel' :
                item.Type === 'Customer - Direct' ? 'Direct' : '-------------'
                return {...item, newType}
            })
        }
        if(error){
            console.error(error);
        }
    }
}