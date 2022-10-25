<template>
    <div class="flex flex-col mt-10">
        <p class="font-bold text-5xl">Resultados individuales</p>
        <div class="grid grid-cols-6 w-full mt-6">
            <div class="border-2 border-black rounded-md m-4 h-32 flex flex-col items-center justify-center" v-for="usuario in usuariosExpediente" :key="usuario.id">
                <p class="font-bold">{{usuario.nombre}} - {{usuario.rol.rol}}</p>
                <p class="font-extrabold text-lg">{{getAptitud}}% aptitud</p>
            </div>
        </div>
    </div>
</template>

<script>

import {mapStores} from 'pinia'
import {useAuthStore} from '../../stores/Auth'

export default {
    name: 'Resultadosindividuales',
    data(){
        return {
            usuariosExpediente: []
        }
    },
    props: {
        idExpediente: ''
    },
    created(){
        this.cargarResultadosIndividuales()
    },
    computed: {
        ...mapStores(useAuthStore),
        getAptitud(){
            //TODO: Utilizar el sistema experto para que genere un resultado
            return Math.round(Math.random()*100)
        }
    },
    methods: {
        async cargarResultadosIndividuales(){
            const app = await this.AuthStore.App

            const usuario_expediente = await app.dao.usuario_expediente.read({}, {filter: {expediente_id: this.idExpediente}})

            for(const usuarioExpediente of usuario_expediente){
                let usuario = await app.dao.usuario.read(usuarioExpediente.usuario_id)

                const rol_usuario = await app.dao.rol.read(usuarioExpediente.rol_id)
                usuario.rol = rol_usuario

                this.usuariosExpediente.push(usuario)
            }
        }
    },

}
</script>

<style scoped>
    .grid-container{
        grid-template-columns: repeat(auto-fill, minmax(50px, 60px));
    }
</style>