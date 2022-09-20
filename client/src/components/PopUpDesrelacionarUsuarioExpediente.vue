<template>
    <div class="fixed top-0 left-0 w-screen h-screen bg-gray-200 opacity-90 z-20">
        <div class="absolute top-1/3 left-1/2 -mt-12 -ml-80 w-1/3 border-2 border-black rounded-md shadow-md opacity-100 p-2 bg-gray-300 text-center">
            <div class="absolute top-2 right-4 cursor-pointer"><XCircleIcon class="w-6 h-6" @click="$emit('closeDesrelacionar')"/></div>

            <div class="w-2/3 mx-auto text-center">
                <h1 class="text-2xl font-semibold">Seguro que quieres eliminar la relación?</h1>
                <p class="text-md text-left mt-2 italic font-semibold">Si eliminas la relación entre el expediente y el usuario este no podrá volver a acceder a él hasta que no vuelva a ser relacionado.
                    Además, el usuario eliminado no podrá realizar los cuestionarios que tenga asignados en el expediente.
                </p>
            </div>
            <div class="flex justify-center space-x-3">
                <AppButton :name="'Mejor no'" @click="$emit('closeDesrelacionar')"/>
                <AppButton :name="'Eliminar relación'" @click="$emit('desrelacionarUsuario', usuarioId)"/>
            </div>
        </div>
    </div>
</template>

<script>
    import {XCircleIcon} from '@heroicons/vue/outline'
import AppButton from './AppButton.vue';
    

    export default {
        name: 'PopUpDesrelacionarUsuarioExpediente',
        components: {
            XCircleIcon,
            AppButton
        },
        props: {
            usuarioId: ''
        }
    }
</script>