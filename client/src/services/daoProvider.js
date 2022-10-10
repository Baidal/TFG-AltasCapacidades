const appClient = require('../../../dao/app_client')

let App = null
let userId = -1

export default async function initializeAppObject(email, password){
    if(App === null){
        App = appClient.appClient()
        await App.getConfig("http://localhost:8080")
        
        try{
            userId = await App.login({email, password})
            return {App, userId}
        }catch(err){
            App = null
            userId = -1
            return {App: null, userId: -1}
        }
    }

    return {App, userId}
    
}

