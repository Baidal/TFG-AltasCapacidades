const appClient = require('../../../dao/app_client')



var app = null

export default async function initializeAppObject(){
    if (app == null){
        console.log("inicializamos el objeto dao")
        app = appClient.appClient()
        await app.getConfig("http://localhost:8080")
        await app.login({})
        return app
    }else {
        console.log("el objeto dao ya está inicializado")
        return app
    } 
}

