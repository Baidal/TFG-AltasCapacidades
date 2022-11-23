<template>
    <router-link :to="{name: 'Cuestionario', params: {id: cuestionario.id}}" class="w-full h-56 flex justify-center text-center p-2">
        <div class="rounded-lg shadow-lg w-full mx-1 flex flex-col items-center hover:shadow-xl cursor-pointer">
            <ClipboardListIcon class="h-22 text-gray-800"/>
            <h1 class="font-semibold mb-4">{{cuestionario.nombre}}</h1>
        </div>
    </router-link>
</template>

<script>
import {ClipboardListIcon} from '@heroicons/vue/outline'

export default {
    name: 'TarjetaListadoCuestionario',
    components: {
        ClipboardListIcon,
    },
    props: {
        cuestionario: {},
    }
}
</script>