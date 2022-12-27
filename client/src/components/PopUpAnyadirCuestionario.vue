<template>
    <div class="fixed top-0 left-0 w-screen h-screen bg-gray-200 opacity-90 z-20">
        <div class="absolute top-1/3 left-1/2 -mt-12 -ml-80 w-1/3 border-2 border-black rounded-md shadow-md opacity-100 p-2 bg-gray-100 ">
            <div class="absolute top-2 right-4 cursor-pointer"><XCircleIcon class="w-6 h-6" @click="this.closePopUp"/></div>

            <div class="flex flex-col items-center">
                <p class="text-center font-bold text-lg">Nuevo cuestionario</p>
                <input class="mt-3 border-2 border-gray-800 rounded-md w-60" placeholder="Nombre..." v-model="this.nombreCuestionario"/>
                <app-button :name="'Nuevo cuestionario'" class="w-44 mt-4" @click="this.crearCuestionario"/>
                <ul class="w-52">
                    <li v-for="error in errores" :key="error" class="italic text-red-500 text-sm">{{error}}</li>
                </ul>
            </div>
        </div>
    </div>
</template>

<script>

import {XCircleIcon} from '@heroicons/vue/outline'
import AppButton from './AppButton.vue'

import {mapStores} from 'pinia'
import {useAuthStore} from '../stores/Auth'

export default {
    name: 'PopUpAnyadirCuestionario',
    data(){
        return {
            nombreCuestionario: '',
            errores: []
        }
    },
    components: {XCircleIcon, AppButton},
    computed: {
        ...mapStores(useAuthStore)
    },
    methods: {
        closePopUp(){
            this.$emit('closePopUp')
        },
        async crearCuestionario(){
            this.errores = []

            if(!this.nombreCuestionario)
                return this.errores.push('* El nombre debe ser introducido.')

            const app = await this.AuthStore.App
            if(!app)
                return this.$router.push({name: 'Login'})
                
            try{
                const cuestionario = await app.dao.cuestionarios.create({nombre: this.nombreCuestionario})
                this.$emit('cuestionarioAnyadido', cuestionario)
            }catch(_){
                this.errores.push('* Se ha producido un error al añadir el cuestionario.')
            }
        }
    }
}
</script>