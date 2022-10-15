const appClient = require('../../../dao/app_client')

let App = null
let userId = -1
let token = ''

export default async function initializeAppObject(email, password, token){
    if(App === null){
        App = appClient.appClient()
        await App.getConfig("http://localhost:8080")
        
        try{
            let response = null
            
            if(token)
                response= await App.login({token})
            else{
                response = await App.login({email, password})
                token = response.token
            }

            userId = response.userId
            
            return {App, userId, token}
        }catch(err){
            console.log("ERROR: ", err)
            App = null
            userId = -1
            return {App, userId, token: null}
        }
    }

    return {App, userId}
    
}

