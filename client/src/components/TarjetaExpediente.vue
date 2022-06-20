<template>
    <div class="p-5">
        <div class="flex flex-col items-center shadow-lg border-b-2 rounded-md hover:shadow-2xl max-h-52 h-52">
            <ClipboardListIcon class="w-2/3 h-2/3 text-gray-700"/>
            <p class="font-bold mb-4 overflow-hidden text-center">{{nombre}}</p>
        </div>
    </div>

</template>

<script>
import {ClipboardListIcon} from '@heroicons/vue/outline'

export default {
    name: 'TarjetaExpediente',
    components: {
        ClipboardListIcon
    },
    props: {
        nombre: {
            type: String
        }
    }
}
</script>