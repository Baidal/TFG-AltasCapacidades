<!-- PopUp genérico que permite importar el texto principal y el texto de sus dos botones.
    Emite dos eventos, eliminar y closeEliminar 
-->
<template>
    <div class="fixed top-0 left-0 w-screen h-screen bg-gray-200 opacity-90 z-20">
        <div class="absolute top-1/3 left-1/2 -mt-12 -ml-80 w-1/3 border-2 border-black rounded-md shadow-md opacity-100 p-2 bg-gray-300 text-center">
            <div class="absolute top-2 right-4 cursor-pointer"><XCircleIcon class="w-6 h-6" @click="$emit('closeEliminar')"/></div>
            <h1 class="font-bold mt-6">{{textoPrincipal}}</h1>
            <div class="flex space-x-3 justify-center mt-3">
                <AppButton :name="textoBotonIzq" @click="$emit('eliminar')"/>
                <AppButton :name="textoBotonDer" @click="$emit('closeEliminar')"/>
            </div>
        </div>
    </div>
</template>
 
<script>
import {XCircleIcon} from '@heroicons/vue/outline'
import AppButton from './AppButton.vue'
export default {
    name: 'Eliminar',
    components: { XCircleIcon, AppButton },
    props: {
        textoPrincipal: '',
        textoBotonIzq: '',
        textoBotonDer: ''
    }
}
</script>