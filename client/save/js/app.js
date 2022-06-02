import * as Vue from "../lib/vue/vue.esm-browser.js";

var app = appClient(); // crea la app del cliente. Tiene un objeto 'dao' con todas las entidades definidas en 'schemas'

app.getConfig(location.origin).then(() => {
    app.login({}).then(() => {
        var vueApp = Vue
            .createApp({
                data: function () {
                    return {
                        llave: "",
                        llaves: [],
                    }
                },

                methods: {
                    cargar() {
                        console.log(app)
                        app.dao.llave_invitacion.read().then(llaves => { // lee un conjunto (array) de entidades
                            this.llaves = llaves;
                            console.log(llaves)
                        });
                    },
                    anyadir() {
                        app.dao.fruta.create({ nombre: this.nombreFruta, precio: 0 }).then(nuevaFruta => { // crea una entidad
                            console.log("Nueva fruta creada con id:", nuevaFruta.id);
                            llaves.push(nuevaFruta);
                            //this.cargar();
                        });
                    },
                    eliminar(frutaId){
                        llaves = llaves.filter(llave => llave.id === frutaId)
                    }
                },

                created() {
                    this.cargar();
                }
            })
        vueApp.mount("#app");
    });
});
