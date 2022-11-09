<template>
    <div class="fixed top-0 left-0 w-screen h-screen bg-gray-200 opacity-90 z-20">
        <div class="absolute top-1/3 left-1/2 -mt-12 -ml-80 w-1/3 border-2 border-black rounded-md shadow-md opacity-100 p-2 bg-gray-300">
            <div class="absolute top-2 right-4 cursor-pointer"><XCircleIcon class="w-6 h-6" @click="$emit('closeBuscarCuestionario')"/></div>
            <p class="font-bold text-base">Buscar cuestionario</p>

            <input class="border-2 border-black rounded-md shadow-md w-2/3" placeholder="Nombre..."/>

            <div class="mt-4 w-full mx-auto flex flex-wrap justify-center">
                <TarjetaCuestionario v-for="cuestionario in cuestionarios" 
                    :key="cuestionario.id" 
                    :nombre="cuestionario.nombre" 
                    :id="cuestionario.id"
                    :showRemoveButton="false"
                    :class="['mx-1', 'my-1', this.cuestionarioSeleccionado(cuestionario.id) ? 'bg-gray-400' : '', 'cursor-pointer']"
                    @click="anyadirCuestionarioASeleccionados(cuestionario)"
                    />
            </div>

            <AppButton :name="'Añadir cuestionarios'" class="mt-4" @click="$emit('anyadirCuestionarios', this.cuestionariosSeleccionados)"/>
        </div>
    </div>
</template>

<script>
import {XCircleIcon} from '@heroicons/vue/outline'
import TarjetaCuestionario from './TarjetaCuestionario.vue'
import AppButton from './AppButton.vue'

import {mapStores} from 'pinia'
import {useAuthStore} from '../stores/Auth.js'

export default {
    name:'PopUpBuscarCuestionario',
    components: {
        XCircleIcon,
        TarjetaCuestionario,
        AppButton
    },
    data(){
        return {
            cuestionarios: Array,
            cuestionariosSeleccionados: []
        }
    },
    async created(){
        //Inicializamos los cuestionarios
        var app = await this.AuthStore.App
        this.cuestionarios = await app.dao.cuestionarios.read()
    },
    computed: {
        ...mapStores(useAuthStore)
    },
    methods: {
        cuestionarioSeleccionado(id){
            return this.cuestionariosSeleccionados.findIndex(cuestionario => cuestionario.id == id) != -1
        },
        anyadirCuestionarioASeleccionados(nuevoCuestionario){
            //El cuestionario está seleccionado, lo deseleccionamos
            if (this.cuestionarioSeleccionado(nuevoCuestionario.id)){
                this.cuestionariosSeleccionados = this.cuestionariosSeleccionados.filter(cuestionario => cuestionario.id != nuevoCuestionario.id)
                return
            }

            //El cuestionario no está seleccionado, lo seleccionamos
            this.cuestionariosSeleccionados.push(nuevoCuestionario)
        }
    }
}
</script>