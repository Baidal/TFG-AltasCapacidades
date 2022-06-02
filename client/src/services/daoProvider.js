const appClient = require('../../../dao/app_client')

var app = null

export default async function initializeAppObject(){
    if (app == null){
        app = appClient.appClient()
        await app.getConfig("http://localhost:8080")
        await app.login({})
        return app
    }else {
        return app
    } 
}

