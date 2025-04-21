import { LightningElement, api } from 'lwc';

/* Static Resource */
import CAR_HUB_PLACEHOLDER from '@salesforce/resourceUrl/placeholder'

export default class Placeholder extends LightningElement {
    @api message

    placeholderURL = CAR_HUB_PLACEHOLDER
}