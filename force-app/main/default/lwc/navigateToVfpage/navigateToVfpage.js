import { LightningElement } from 'lwc';
import { NavigationMixin } from 'lightning/navigation';
export default class NavigateToVfpage extends NavigationMixin(LightningElement) {
    navigateToVfPage(){
        this[NavigationMixin.Navigate]({
            type: 'standard__webPage',
            attributes: {
                url: '/apex/lmsVisualForceDemo'
            }
        }).then(generatedURL=>{
            console.log('generated URL', generatedURL);
            window.open(generatedURL,'_blank');
        })
    }
}