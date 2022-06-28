<template>
    <div class="fixed top-0 left-0 w-screen h-screen bg-gray-200 opacity-90 z-20">
        <div class="absolute top-1/3 left-1/2 -mt-12 -ml-80 w-1/3 border-2 border-black rounded-md shadow-md opacity-100 p-2 bg-gray-300 text-center">
            <div class="absolute top-2 right-4 cursor-pointer"><XCircleIcon class="w-6 h-6" @click="$emit('closeModificarExpediente')"/></div>
            <h1 class="font-bold">Modificar expediente</h1>
            <!-- Nombre expediente -->
            <div class="flex flex-col items-center">
                <div class="w-2/3 text-left"><label for="nombre" class="text-sm font-bold pl-1">Nombre del expediente</label></div>
                <input class="w-2/3 border-2 border-gray-800 rounded-md font-semibold" name="nombre" placeholder="Nuevo nombre..." v-model="expedienteAModificar.nombre"/>
            </div>
            <!-- Nombre niño -->
            <div class="flex flex-col items-center mt-2">
                <div class="w-2/3 text-left"><label for="nombre_niño" class="text-sm font-bold pl-1">Nombre del niño</label></div>
                <input class="w-2/3 border-2 border-gray-800 rounded-md font-semibold" name="nombre_niño" placeholder="Nuevo nombre..." v-model="expedienteAModificar.nombre_niño"/>
            </div>

            <!-- Apellidos niño -->
            <div class="flex flex-col items-center mt-2">
                <div class="w-2/3 text-left"><label for="apellidos_niño" class="text-sm font-bold pl-1">Apellidos del niño</label></div>
                <input class="w-2/3 border-2 border-gray-800 rounded-md font-semibold" name="apellidos_niño" placeholder="Nuevo nombre..." v-model="expedienteAModificar.apellidos_niño"/>
            </div>

            <!-- Dni niño -->
            <div class="flex flex-col items-center mt-2">
                <div class="w-2/3 text-left"><label for="dni_niño" class="text-sm font-bold pl-1">DNI del niño</label></div>
                <input class="w-2/3 border-2 border-gray-800 rounded-md font-semibold" name="dni_niño" placeholder="Nuevo nombre..." v-model="expedienteAModificar.dni_niño"/>
            </div>

            <!-- Fecha nacimiento niño -->
            <div class="flex flex-col items-center mt-2">
                <div class="w-2/3 text-left"><label for="nacimiento_niño" class="text-sm font-bold pl-1">Fecha de nacimiento del niño</label></div>
                <input class="w-2/3 border-2 border-gray-800 rounded-md font-semibold" name="nacimiento_niño" placeholder="Nuevo nombre..." v-model="expedienteAModificar.fechanacimiento_niño" type="date"/>
            </div>

            <AppButton :name="'Modificar expediente'" class="mt-3" @click="$emit('modificarExpediente', expedienteAModificar)"/>

        </div>
    </div>
</template>

<script>
import {XCircleIcon} from '@heroicons/vue/outline'
import utils from '../services/utils'
import AppButton from './AppButton.vue'

export default {
    name: 'ModificarExpediente',
    components: { XCircleIcon, AppButton },
    props: {
        expediente: {}
    },
    data(){
        return {
            expedienteAModificar: {}
        }
    },
    created(){
        this.expedienteAModificar = Object.assign({}, this.expediente)
        
        this.expedienteAModificar.fechanacimiento_niño = utils.formatearFechaAEstandar(this.expedienteAModificar.fechanacimiento_niño)
        
    }
}
</script>