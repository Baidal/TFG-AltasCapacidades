<template>
    <div class="flex flex-col items-center mt-5 w-full">
        <!-- Header de esta vista-->
        <div class="flex border-b-2 rounded-sm border-gray-600 justify-between w-3/4 p-1">
            <!--Parte izquierda del principio-->
            <div class="flex space-x-6">
                <p class="text-lg mt-6 font-bold">Listado de expedientes</p>
                <router-link :to="{name: 'CrearExpediente'}" class="mt-4"><app-button :name="'Nuevo expediente'"/></router-link>
            </div>
            <!--Parte derecha del principio-->
            <div class="w-1/4 mt-4">
                <InputBuscar :placeHolder="'Buscar expediente...'" v-model="inputBuscarExpediente" class="w-full"/>
            </div>
        </div>
        <MoonLoader :loading="loadingData" class="mt-4"/>
        <!-- Listado de expedientes -->
        <div class="grid grid-rows-4 w-3/4 grid-container">
            <TarjetaExpediente :nombre="expediente.nombre" :id="expediente.id" class="cursor-pointer" v-for="expediente in expedientes" :key="expediente.id"/>
            
            <router-link :to="{name: 'CrearExpediente'}" class="text-gray-500 flex flex-col items-center justify-center my-2" v-if="!loadingData">
                <PlusIcon class="w-1/3 h-1/3"/>
                <p>Nuevo expediente</p>
            </router-link>
        </div>
    </div>
</template>

<script>
import initializeAppObject from '../services/daoProvider' 

import {PlusIcon, SearchIcon} from '@heroicons/vue/outline'
import MoonLoader from 'vue-spinner/src/MoonLoader.vue'

import AppButton from '../components/AppButton.vue'
import TarjetaExpediente from '../components/TarjetaExpediente.vue'
import InputBuscar from '../components/InputBuscar.vue'
undefined
undefined
export default {
    components: { AppButton, TarjetaExpediente, PlusIcon, MoonLoader, SearchIcon, InputBuscar },
    name: 'Expedientes',
    data() {
        return {
            expedientes: [],
            loadingData: true,
            inputBuscarExpediente: ''
        }
    },
    methods: {
        async cargarExpedientes(){
            this.loadingData = true
            this.expedientes = []

            const userLoggedId = 1
            
            const app = await initializeAppObject()

            const expedientesDB = await app.dao.expediente.read()

            //Buscamos los expedientes relacionados con el usuario
            const idExpedientes = await app.dao.usuario_expediente.read()
            
            //Recorremos los expedientes y nos quedamos con los que pertenezcan al usuario
            idExpedientes.forEach(row => {
                if(row.usuario_id == userLoggedId){
                    this.expedientes.push(expedientesDB.find(expedienteDB => expedienteDB.id == row.expediente_id))
                }
            })

            this.loadingData = false
        },
        filtrarExpedientes(nombre){
            this.expedientes = this.expedientes.filter(expediente => {
                var expedienteLowerCase = expediente.nombre.toLowerCase()
                nombre = nombre.toLowerCase()
                return expedienteLowerCase.includes(nombre)
            })
        }
    },
    async mounted() {
        this.cargarExpedientes()
    },
    watch: {
        inputBuscarExpediente(new_input, _){
            if(new_input.length == 0){
                this.cargarExpedientes()
                return
            }
            
            this.filtrarExpedientes(new_input)
        }
    }
}
</script>

<style>
    .grid-container{
        grid-template-columns: repeat(auto-fill, minmax(220px, 1fr));
    }
</style>