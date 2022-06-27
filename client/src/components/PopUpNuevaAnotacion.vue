<template>
    <div class="fixed top-0 left-0 w-screen h-screen bg-gray-200 opacity-90 z-20">
        <div class="absolute top-1/3 left-1/2 -mt-12 -ml-64 w-1/3 border-2 border-black rounded-md shadow-md opacity-100 p-2 bg-gray-300 text-center">
            <div class="absolute top-2 right-4 cursor-pointer"><XCircleIcon class="w-6 h-6" @click="$emit('closeNuevaAnotacion')"/></div>
            <p class="font-bold">Nueva anotación</p>
            <div class="flex flex-col items-center">
                <div class="w-2/3 text-left"><label for="titulo" class="text-sm font-bold pl-1">Título</label></div>
                <input class="w-2/3 border-2 border-gray-800 rounded-md" name="titulo" placeholder="Nuevo título..." v-model="titulo"/>
            </div>

            <div class="flex flex-col items-center">
                <div class="w-2/3 text-left"><label for="titulo" class="text-sm font-bold pl-1">Anotación</label></div>
                <textarea class="w-2/3 border-2 border-gray-800 rounded-md h-40" name="titulo" placeholder="Nueva anotación..." v-model="anotacion"></textarea>  
            </div>
            <p class="text-red-600 font-bold">{{errores}}</p>
            <AppButton class="mt-3" :name="'Añadir anotación'" @click="nuevaAnotacion"/>
        </div>
    </div>
</template>

<script>
import {XCircleIcon} from '@heroicons/vue/solid'
import AppButton from './AppButton.vue'

export default {
    name: 'NuevaAnotacion',
    components: { XCircleIcon, AppButton },
    data(){
        return {
            titulo: '',
            anotacion: '',
            errores: ''
        }
    },
    methods: {
        nuevaAnotacion(){
            this.errores = ''

            if(this.titulo.length == 0 || this.anotacion.length == 0){
                this.errores = 'El título y la anotación no pueden estar vacíos'
                return
            }

            this.$emit('nuevaAnotacion', this.titulo, this.anotacion)
        }
    }
}
</script>