<template>
    <router-link :to="{name: 'Expediente', params: {id: this.id}}" class="p-5">
        <div class="flex flex-col items-center shadow-lg border-b-2 rounded-md hover:shadow-2xl max-h-52 h-52">
            <IdentificationIcon class="w-2/3 h-2/3 text-gray-700"/>
            <p class="font-bold mb-4 overflow-hidden text-center">{{nombre}}</p>
        </div>
    </router-link>
</template>

<script>
import {ClipboardListIcon, IdentificationIcon} from '@heroicons/vue/outline'

export default {
    name: 'TarjetaExpediente',
    components: {
        ClipboardListIcon,
        IdentificationIcon
    },
    props: {
        nombre: {
            type: String
        },
        id: Number
    }
}
</script>