import { LightningElement } from 'lwc';
import {NavigationMixin} from 'lightning/navigation';
import {encodeDefaultFieldValues} from 'lightning/pageReferenceUtils';

export default class NavigateToObjectPage extends NavigationMixin(LightningElement) {
    navigateToRecord(){
        this[NavigationMixin.Navigate]({
            type:'standard__objectPage',
            attributes:{
                objectApiName: 'Contact',
                actionName: 'new'
            }
        })
    }

    navigateToRecordwithDefault(){

        const defaultValue = encodeDefaultFieldValues({
            FirstName : 'Rahul',
            LastName : 'Hero',
            LeadSource : 'Web'
        })

        this[NavigationMixin.Navigate]({
            type:'standard__objectPage',
            attributes:{
                objectApiName: 'Contact',
                actionName: 'new'
            },

            state :{
                defaultFieldValues : defaultValue
            }
        })
    }


    navigateToRecordListView(){
         this[NavigationMixin.Navigate]({
            type:'standard__objectPage',
            attributes:{
                objectApiName: 'Contact',
                actionName: 'list'
            },
            state:{
                filterName: 'Recent'
            }
        })
    }

    navigateToRecordFilesView(){
          this[NavigationMixin.Navigate]({
            type:'standard__objectPage',
            attributes:{
                objectApiName: 'ContentDocument',
                actionName: 'home'
            }
        })
    }
}