<template>
    <div class="border-2 border-black w-1/4 p-2 flex flex-col relative space-y-1">
        <UserIcon class="w-10 h-10 mx-auto"/>
        <p class="truncate font-semibold">{{nombre}}</p>
        <p class="truncate font-bold">{{email}}</p>
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
            }
        },
        components: {
            UserIcon,
            XCircleIcon
        }
    }
</script>