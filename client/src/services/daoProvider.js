const appClient = require('../../../dao/app_client')



export default async function initializeAppObject(email, password, token){
    let App = null  
    let userId = -1
    console.log(email, password, token)
    console.log("ESTAMOS EN APP ES DIFERENTE DE NULL")
    App = appClient.appClient()
    await App.getConfig("http://localhost:8080")
    
    try{
        let response = null
        console.log("INICIAMOS SESION")
        
        if(token)
            response= await App.login({token})
        else{
            console.log("INICIAMOS SESION CON LOS DATOS")
            response = await App.login({email, password})
            console.log(response)
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

