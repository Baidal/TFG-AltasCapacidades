import { appClient } from '../../dao/app_client.js'
import { stringify, parse } from 'flatted'




async function init(){
    let app = appClient()
    app = await app.getConfig("http://localhost:8080")

    const appString = stringify(app)
    console.log(appString)

    const appStringParsed = parse(appString)
    console.log(appStringParsed)

}

init()
