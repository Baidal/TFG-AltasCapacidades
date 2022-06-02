<template>
    <div class="border-2 border-black w-1/4 rounded-md">
        <ClipboardListIcon class="w-10 h-10 mx-auto"/>
        <p class="font-bold">{{nombre}}</p>
    </div>
</template>

<script>
    import {ClipboardListIcon} from '@heroicons/vue/outline'

    export default {
        name: 'TarjetaCuestionario',
        props: {
            nombre: ''
        },
        components: {
            ClipboardListIcon
        }
    }
</script>