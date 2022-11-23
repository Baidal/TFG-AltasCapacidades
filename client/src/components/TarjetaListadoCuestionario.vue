<template>
    <div  class="w-full h-56 flex justify-center text-center p-2 relative">
        <div class="absolute top-4 right-4 cursor-pointer"><XCircleIcon class="w-8 h-8 z-10" @click="$emit('eliminarCuestionario', this.cuestionario.id)" v-if="mostrarEliminar"/></div>
        <div @click="this.$router.push({name: 'Cuestionario', params: {id: cuestionario?.id}})" class="rounded-lg shadow-lg w-full mx-1 flex flex-col items-center hover:shadow-xl cursor-pointer">
            <ClipboardListIcon class="h-22 text-gray-800"/>
            <h1 class="font-semibold mb-4">{{cuestionario.nombre}}</h1>
        </div>
    </div>
</template>

<script>
import {ClipboardListIcon, XCircleIcon} from '@heroicons/vue/outline'
// import {XCircleIcon} from '@heroicons/vue/solid'


export default {
    name: 'TarjetaListadoCuestionario',
    components: {
        ClipboardListIcon,
        XCircleIcon
    },
    props: {
        cuestionario: {},
        mostrarEliminar: false
    }
}
</script>