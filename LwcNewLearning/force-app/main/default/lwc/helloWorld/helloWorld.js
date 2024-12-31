import { LightningElement, track } from 'lwc';

export default class HelloWorld extends LightningElement {
    //Data binding Property
    course = "Lwc"

    handleChange(event) {
        this.course = event.target.value;
    }

    //@track property to track changes in the input field
    @track
    address = {
        city: "Melbourne"
    }

    handleChangeAddress(event) {
        this.address.city = event.target.value;
    }

    //getter property
    users = ["John","Nikhil","neha"]
    num1 = 10
    num2 = 20

    get firstUser(){
        return this.users[0]
    }

    get multiply(){
        return this.num1 * this.num2
    }

}