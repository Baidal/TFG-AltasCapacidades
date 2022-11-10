<template>
    <div class="flex flex-col items-center mt-5 w-full">
        <!-- Header de esta vista-->
        <div class="flex border-b-2 rounded-sm border-gray-600 justify-between w-3/4 p-1">
            <!--Parte izquierda del principio-->
            <div class="flex space-x-6">
                <p class="text-lg mt-6 font-bold">Listado de expedientes</p>
                <router-link v-if="this.userIsPsicologo" :to="{name: 'CrearExpediente'}" class="mt-4"><app-button :name="'Nuevo expediente'"/></router-link>
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
            
            <router-link :to="{name: 'CrearExpediente'}" class="text-gray-500 flex flex-col items-center justify-center my-2" v-if="!loadingData && userIsPsicologo">
                <PlusIcon class="w-1/3 h-1/3"/>
                <p>Nuevo expediente</p>
            </router-link>
        </div>
    </div>
</template>

<script>
import {mapStores} from 'pinia'
import {useAuthStore} from '../stores/Auth.js'

import {PlusIcon, SearchIcon} from '@heroicons/vue/outline'
import MoonLoader from 'vue-spinner/src/MoonLoader.vue'

import AppButton from '../components/AppButton.vue'
import TarjetaExpediente from '../components/TarjetaExpediente.vue'
import InputBuscar from '../components/InputBuscar.vue'

import utils from '../services/utils'

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
    computed: {
        ...mapStores(useAuthStore),
        loggedIn(){
            return this.AuthStore.userIsLoggedIn
        },
        userIsPsicologo(){
            return utils.userIsPsicologo(this.AuthStore.getUser.id)
        }
    },
    methods: {
        async cargarExpedientes(){
            this.loadingData = true
            this.expedientes = []
            
            if(!this.loggedIn)
                return this.$router.push({name: 'Login'})

            const app = await this.AuthStore.App
            if(!app)
                this.$router.push({name: 'Login'})

            const usuario_expediente = await app.dao.usuario_expediente.read({}, {filter: {usuario_id: this.AuthStore.getUser.id, usuario_eliminado: 0}})    
            
            for(const usuarioExpediente of usuario_expediente){
                const expediente = await app.dao.expediente.read(usuarioExpediente.expediente_id)
                this.expedientes.push(expediente)
            }

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

<style scoped>
    .grid-container{
        grid-template-columns: repeat(auto-fill, minmax(220px, 1fr));
    }
</style>