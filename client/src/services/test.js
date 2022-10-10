const appClient = require('../../../dao/app_client')

var app = null

async function initializeAppObject(){
    if (app == null){
        app = appClient.appClient()
        await app.getConfig("http://localhost:8080")
        app.login({email: 'luis@gmail.com', password: '12345678'}).then(user => {
            console.log("login correcto")
            console.log(user)
        }).catch(err => 
            console.log("ERROR ", err)    
        )
        
    }
}

initializeAppObject()
//app.dao.usuario.create({email: 'dasdsd@gmail.com', password: '12345678', nombre: 'SDAS', apellidos: 'dsdas', 'dni': 'dsdasd', telefono: 'dsdasd', fecha_nacimiento: '2000-01-10', estado_id: 1, rol_id: 1})
