<template>
    <div>
        <div class="flex flex-col mx-10 mt-5" v-if="this.expedienteEncontrado()">
            <!-- Zona superior de la vista-->
            <div class="flex mb-2">
                <!-- Icono de expediente y nombre de expediente -->
                <div class="flex flex-col text-center w-1/3">
                    <ClipboardListIcon class="h-32 text-indigo-400"/>
                    <p class="font-bold">{{expediente.nombre}}</p>
                </div>
                <div class="flex-1 ml-5 items-end">
                    <div class="flex flex-col space-y-2">
                        <p class="font-bold">{{expediente.nombre_niño}}</p>
                        <p class="text-sm font-semibold">10 años</p>
                        <p class="text-sm font-semibold">{{expediente.dni_niño}}</p>
                        <p class="text-sm text-gray-600 font-semibold">Expediente creado el {{expediente.create_time}}</p>
                        <AppButton :name="'Modificar expediente'" class="w-52"/>
                    </div>
                </div>
            </div>

            <!-- Raya que separa la zona superior de la inferior -->
            <div class="border border-gray-500 rounded-lg"></div>

            <!-- Zona inferior -->
            <div class="flex">
                <!-- Parte izquierda-->
                <div class="flex flex-col text-center w-1/3 space-y-3">
                    <!-- Bocadillo -->
                    <div class="mx-8 mt-8 border-2 border-gray-500 rounded-md shadow-lg p-4 text-center">
                        Usuarios relacionados con el expediente
                    </div>
                    <!-- Listado de usuarios relacionados con el expediente -->
                    <div class="mx-auto h-52 overflow-x-hidden overflow-y-auto space-y-3 w-3/4 flex items-center flex-col">
                        <div class="flex space-x-12 justify-between w-full" v-for="usuario in usuariosRelacionados" :key="usuario.id">
                            <UserIcon class="h-7 min-h-full"/>
                            <p class="font-semibold my-auto">{{usuario.nombre}}</p>
                            <XCircleIcon class="h-7 min-h-full cursor-pointer" v-on:click="eliminarRelacionExpedienteUsuario(usuario.id)"/>
                        </div>                     
                    </div>
                </div>
            </div>
        </div>
        <p class="font-bold text-center text-2xl mt-4" v-if="!this.expedienteEncontrado() && !this.cargandoDatos">Expediente no encontrado</p>
        <div class="mt-4 flex justify-center" v-if="this.cargandoDatos">
            <MoonLoader/>
        </div>
    </div>
    
</template>

<script>
import MoonLoader from 'vue-spinner/src/MoonLoader.vue'

import {ClipboardListIcon, XCircleIcon} from '@heroicons/vue/outline'
import {UserIcon} from '@heroicons/vue/solid'

import initializeAppObject from '../services/daoProvider'
import AppButton from '../components/AppButton.vue'

export default {
    name: 'Expediente',
    components: {
        ClipboardListIcon,
        AppButton,
        UserIcon,
        XCircleIcon,
        MoonLoader
    },
    props: {
        id: ''
    },
    data() {
        return {
            expediente: {},
            usuariosRelacionados: [],
            cargandoDatos: true
        }
    },
    async created(){
        this.cargandoDatos = true

        const expedienteEncontrado = await this.cargarExpediente()

        if (expedienteEncontrado){
            this.cargarUsuariosRelacionados()
        }

        this.cargandoDatos = false
    },
    methods: {
        async cargarExpediente(){
            if(this.id == '')
                return false
            
            const app = await initializeAppObject()
            const expedientes = await app.dao.expediente.read()

            this.expediente = expedientes.find(expedienteDB => expedienteDB.id == this.id) || {}
            
            return this.expedienteEncontrado()
        },
        expedienteEncontrado(){
            return Object.keys(this.expediente).length !== 0
        },
        async cargarUsuariosRelacionados(){
            const app = await initializeAppObject()
            let usuario_expediente = await app.dao.usuario_expediente.read()

            usuario_expediente = usuario_expediente.filter(row => row.expediente_id == this.expediente.id)

            usuario_expediente.forEach(async row => {
                let usuario = await app.dao.usuario.read(row.usuario_id)
                usuario.usuario_expediente_ID = row.id //Guardamos el id de la tabla que relaciona al usuario con el expediente para luego poder acceder a el sin necesidad de tener que recurrir a la BD de nuevo
                this.usuariosRelacionados.push(usuario)
            })
        },
        async eliminarRelacionExpedienteUsuario(usuarioId){
            const usuario = this.usuariosRelacionados.find(usuarioBuscar => usuarioBuscar.id == usuarioId)
            
            const app = await initializeAppObject()
            await app.dao.usuario_expediente.delete({id: usuario.usuario_expediente_ID})

            this.usuariosRelacionados = this.usuariosRelacionados.filter(usuario => usuario.id != usuarioId)
        }
    },

}
</script>

<style scoped>
    ::-webkit-scrollbar {
        width: 10px;
    }

    /* Track */
    ::-webkit-scrollbar-track {
        background: #f1f1f1; 
    }
    
    /* Handle */
    ::-webkit-scrollbar-thumb {
    background: #888; 
    }

    /* Handle on hover */
    ::-webkit-scrollbar-thumb:hover {
    background: #555; 
    }
</style>