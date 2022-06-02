<template>
    <div class="border-2 border-black w-1/4 p-2 flex flex-col space-y-1">
        <UserIcon class="w-10 h-10 mx-auto"/>
        <p class="truncate font-semibold">{{nombre}}</p>
        <p class="truncate font-bold">{{email}}</p>
    </div>

</template>

<script>
    import {UserIcon} from '@heroicons/vue/solid'

    export default {
        name: 'TarjetaUsuario',
        props: {
            nombre: "",
            email: ""
        },
        components: {
            UserIcon
        }
    }
</script>