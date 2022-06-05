<template>
    <div class="block text-center mt-2 space-y-2">
        <p class="text-lg font-bold">{{this.creandoExpediente ? "Nuevo expediente" : "Añadir formularios al expediente"}}</p>
        <PlusCircleIcon class="h-14 w-14 mx-auto text-green-800"/>
        <AppButton v-on:click="toggleFormularioNiño" :name="mostrarFormularioNiño ? 'Esconder datos' : 'Mostrar datos'"/>
        <!-- Formulario con los datos del niño -->
        <div v-if="this.mostrarFormularioNiño">
            <div class="w-2/5 border-4 border-black rounded-md mx-auto flex space-y-2 flex-col pl-4 pr-4 pb-4 pt-2 shadow-lg">
                <!-- Nombre y apellidos-->
                <p class="font-bold text-md mb-2">Datos del niño/a</p>
                <div class="flex space-x-2">
                    <input v-model="datosNiño.nombre" name="nombre" class="w-1/3 border-2 border-black rounded-md p-1" placeholder="Nombre..."/>
                    <input v-model="datosNiño.apellidos" name="apellidos" class="w-2/3 border-2 border-black rounded-md p-1" placeholder="Apellidos..."/>
                </div>
                <!-- Dni y Fecha nacimiento-->
                <div class="flex space-x-2">
                    <input v-model="datosNiño.dni" name="dni" class="w-1/4 border-2 border-black rounded-md p-1" placeholder="Dni..."/>
                    <input v-model="datosNiño.fechaNac" name="fechaNac" class="w-3/4 border-2 border-black rounded-md p-1" placeholder="Fecha nacimiento..."/>
                </div>
            </div>
        </div>
        <!-- Tarjetas que contienen los usuarios y los cuestionarios a asignar al expediente-->
        <div class="flex justify-center flex-wrap space-x-4">
            <TarjetaUsuariosCuestionarios :titulo="'Familiares'"/>
            <TarjetaUsuariosCuestionarios :titulo="'Colegio'"/>
        </div>
    </div>
</template>

<script>

import {PlusCircleIcon} from '@heroicons/vue/outline'
import TarjetaUsuariosCuestionarios from '../components/TarjetaUsuariosCuestionarios.vue'
import AppButton from '../components/AppButton.vue'

export default {
    name: 'AsignarCuestionariosExpediente',
    components: {
        PlusCircleIcon,
        TarjetaUsuariosCuestionarios,
        AppButton,
    },
    props: {
        creandoExpediente: Boolean
    },
    data(){
        return {
            mostrarFormularioNiño: true,
            datosNiño: {
                nombre: "",
                apellidos: "",
                dni: "",
                fechaNac: ""
            },
            /**
             * Categorías es un array de objetos con el siguiente prototipo:
             * {
             *  nombre: '',
             *  usuarios: [],
             *  cuestionarios: []
             * }
             */
            categorias: [{nombre: 'Familiares', usuarios: [], cuestionarios: []}, {nombre: 'Colegio', usuarios: [], cuestionarios: []}]
        }
    },
    methods: {
        toggleFormularioNiño(){
            this.mostrarFormularioNiño = !this.mostrarFormularioNiño
        }
    }
}
</script>
