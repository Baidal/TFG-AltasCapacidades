<template>
    <router-link class="border-2 border-black flex flex-col m-2 rounded-md cursor-pointer hover:shadow-xl" :to="{name: 'Cuestionario', params: {id: cuestionario?.cuestionario.id}}">
        <ClipboardListIcon class="h-28"/>
        <p class="text-center text-gray-800 font-bold">{{cuestionario?.cuestionario.nombre}}</p>
        <div class="flex space-x-1 justify-center">
            <CheckIcon v-if="cuestionarioCompletado" class="h-4 my-auto"/>
            <p v-if="cuestionarioCompletado">Realizado</p>
            
            <XIcon v-if="!cuestionarioCompletado" class="h-4 my-auto"/>
            <p v-if="!cuestionarioCompletado">No realizado</p>
        </div>
    </router-link>
</template>

<script>
import {ClipboardListIcon, CheckIcon, XIcon} from '@heroicons/vue/outline'

export default {
    name: 'TarjetaCuestionario',
    components: {
        ClipboardListIcon,
        CheckIcon,
        XIcon
    },
    props: {
        cuestionario: Object
    },
    computed: {
        cuestionarioCompletado(){
            return this.cuestionario?.completado
        }
    }
}
</script>