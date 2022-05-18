import * as Vue from "../lib/vue/vue.esm-browser.js";

var app = appClient(); // crea la app del cliente. Tiene un objeto 'dao' con todas las entidades definidas en 'schemas'

app.getConfig(location.origin).then(() => {
    app.login({}).then(() => {
        var vueApp = Vue
            .createApp({
                data: function () {
                    return {
                        nombreFruta: "",
                        frutas: [],
                    }
                },

                methods: {
                    cargar() {
                        app.dao.fruta.read().then(frutas => { // lee un conjunto (array) de entidades
                            this.frutas = frutas;
                        });
                    },

                    anyadir() {
                        app.dao.fruta.create({ nombre: this.nombreFruta, precio: 0 }).then(nuevaFruta => { // crea una entidad
                            console.log("Nueva fruta creada con id:", nuevaFruta.id);
                            this.cargar();
                        });
                    },

                    eliminar(frutaId) {
                        app.dao.fruta.delete({id:frutaId}).then(() => { // elimina una entidad
                            console.log("Fruta borrada");
                            this.cargar();
                        });
                    },

                    cambiarPrecio(frutaId, precio) {
                        app.dao.fruta.update({id: frutaId}, {precio: precio}).then(()=> { // actualiza una entidad
                            console.log("Precio actualizado");
                            this.cargar();
                        });
                    }
                },

                created() {
                    this.cargar();
                }
            })
        vueApp.mount("#app");
    });
});
