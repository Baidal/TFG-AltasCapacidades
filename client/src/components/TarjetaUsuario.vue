<template>
    <div class="border-2 border-blue-800 w-1/4 p-2 flex flex-col relative space-y-1 rounded-md">
        <UserIcon class="w-10 h-10 mx-auto"/>
        <p class="truncate font-semibold">{{nombre}}</p>
        <p class="truncate font-bold">{{email}}</p>
        <p v-if="this.nuevoUsuario" class="text-gray-600 font-semibold text-sm italic">Nuevo usuario</p>
        <XCircleIcon class="w-8 h-8 mx-auto cursor-pointer" @click="$emit('deleteUser', id)"/>    
    </div>

</template>

<script>
    import {UserIcon} from '@heroicons/vue/solid'
    import {XCircleIcon} from '@heroicons/vue/outline'

    export default {
        name: 'TarjetaUsuario',
        props: {
            nombre: "",
            email: "",
            id: {
                type: Number
            },
            nuevoUsuario: false
        },
        components: {
            UserIcon,
            XCircleIcon
        }
    }
</script>