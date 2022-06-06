<template>
    <div class="border-2 border-green-800 w-1/4 rounded-md">
        <ClipboardListIcon class="w-10 h-10 mx-auto"/>
        <p class="font-bold">{{nombre}}</p>
        <XCircleIcon class="w-8 h-8 mx-auto cursor-pointer" @click="$emit('deleteCuestionario', id)" v-if="showRemoveButton"/>    
    </div>
</template>

<script>
    import {ClipboardListIcon, XCircleIcon} from '@heroicons/vue/outline'

    export default {
        name: 'TarjetaCuestionario',
        props: {
            nombre: '',
            id: Number,
            showRemoveButton: Boolean
        },
        components: {
            ClipboardListIcon,
            XCircleIcon
        }
    }
</script>