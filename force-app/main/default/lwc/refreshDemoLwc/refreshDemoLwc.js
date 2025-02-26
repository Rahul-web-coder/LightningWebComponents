import { LightningElement, wire } from 'lwc';
import getContactList from '@salesforce/apex/RefreshContactController.getContactList'

export default class RefreshDemoLwc extends LightningElement {
    @wire(getContactList)
    contact;

    get isContactAvailable(){
        console.log(JSON.stringify(this.contact))
        return this.contact && this.contact.data.length ? 'Yes' : 'No'
    }
}