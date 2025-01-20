import { LightningElement } from 'lwc';
import {loadStyle} from 'lightning/platformResourceLoader'
import fontawesome from '@salesforce/resourceUrl/fontawesome'
export default class MemoryGameLwc extends LightningElement {

    islibLoaded = false
    openCards=[]
    moves = 0
    totalTime = '00:00'
    timeref
    matchedCards=[]
    showCongratulations = false
    cards=[
        {id:1, listclass:"card", type:'diamond', icon:'fa fa-diamond'},
        {id:2, listclass:"card", type:'paper-plane-o', icon:'fa fa-paper-plane-o'},
        {id:3, listclass:"card", type:'anchor', icon:'fa fa-anchor'},
        {id:4, listclass:"card", type:'bolt', icon:'fa fa-bolt'},
        {id:5, listclass:"card", type:'cube', icon:'fa fa-cube'},
        {id:6, listclass:"card", type:'anchor', icon:'fa fa-anchor'},
        {id:7, listclass:"card", type:'leaf', icon:'fa fa-leaf'},
        {id:8, listclass:"card", type:'bicycle', icon:'fa fa-bicycle'},
        {id:9, listclass:"card", type:'diamond', icon:'fa fa-diamond'},
        {id:10, listclass:"card", type:'bomb', icon:'fa fa-bomb'},
        {id:11, listclass:"card", type:'leaf', icon:'fa fa-leaf'},
        {id:12, listclass:"card", type:'bomb', icon:'fa fa-bomb'},
        {id:13, listclass:"card", type:'bolt', icon:'fa fa-bolt'},
        {id:14, listclass:"card", type:'bicycle', icon:'fa fa-bicycle'},
        {id:15, listclass:"card", type:'paper-plane-o', icon:'fa fa-paper-plane-o'},
        {id:16, listclass:"card", type:'cube', icon:'fa fa-cube'},
    ]

    get gameRating(){
        let stars = this.moves < 12 ? [1,2,3] : this.moves >= 13 ? [1,2] : [1]
        console.log('stars --->' + stars)
        return this.matchedCards.length === 16 ? stars : []
    }


    displayCard(event){
        let currCard = event.target
        currCard.classList.add("open", "show", "disabled")
        this.openCards = this.openCards.concat(event.target)
        if(this.openCards.length === 2){
            this.moves = this.moves + 1
            if(this.moves === 1){
                this.timer();
            }
            if(this.openCards[0].type === this.openCards[1].type){
                this.matchedCards = this.matchedCards.concat(this.openCards[0], this.openCards[1])
                this.matched()
            } else{
                this.unmatched()
            }
        }
    }

    matched(){
        this.openCards[0].classList.add("match", "disabled")
        this.openCards[1].classList.add("match", "disabled")
        this.openCards[0].classList.remove("show", "open")
        this.openCards[1].classList.remove("show", "open")
        this.openCards = []
        if(this.matchedCards.length === 16){
            window.clearInterval(this.timeref)
            this.showCongratulations = true
        }
    }

    unmatched(){
        this.openCards[0].classList.add("unmatch")
        this.openCards[1].classList.add("unmatch")
        this.action('DISABLE')
        setTimeout(()=>{
            this.openCards[0].classList.remove("show", "open", "unmatch")
            this.openCards[1].classList.remove("show", "open", "unmatch")
            this.action('ENABLE')
            this.openCards = []
        },1100)
    }

    action(action){
        let cards = this.template.querySelectorAll('.card')
        Array.from(cards).forEach(item=>{
            if(action==='ENABLE'){
                let isMatch = item.classList.contains('match')
                if(!isMatch){
                    item.classList.remove('disabled')
                }
            }
            if(action ==='DISABLE'){
                item.classList.add('disabled')
            }
        })
    }

    timer(){
        let startTime = new Date()
        this.timeref = setInterval(()=> {
            let diff = new Date().getTime() - startTime.getTime()
            const d = Math.floor(diff / 1000)
            const m = Math.floor(d % 3600 / 60)
            const s = Math.floor(d % 3600 % 60)
            const mDisplay = m > 0 ? m + (m===1 ? " minute, " : " minutes, ") : ""
            const sDisplay = s > 0 ? s + (s===1 ? " second" : " seconds") : ""
            this.totalTime = mDisplay + sDisplay
        },1000)
    }


    shuffle(){
        this.showCongratulations = false
        this.openCards=[]
        this.moves = 0
        this.totalTime = '00:00'
        this.matchedCards=[]
        window.clearInterval(this.timeref)
        let elem = this.template.querySelectorAll('.card')
        Array.from(elem).forEach(item=>{
            item.classList.remove("show" ,"open", "match", "disabled")
        })

        /*shuffling and swapping*/

        let array = [...this.cards]
        let counter = array.length
        while(counter > 0){
            let index = Math.floor(Math.random()*counter)
            console.log('counter ---->'  + counter )
            console.log('index ---->'  + index )
            counter--

            let temp = array[counter]
            array[counter] = array[index]
            array[index] = temp
        }
        this.cards=[...array]

        console.log('cards --->' + JSON.stringify(this.cards))
    }



    renderedCallback(){
        if(this.islibLoaded){
            return
        }else{
             loadStyle(this, fontawesome+'/fontawesome/css/font-awesome.min.css').then(()=>{
                console.log("loaded successfully")
            }).catch(error=>{
                console.log(error)
            })
            this.islibLoaded = true
        }
    }
}