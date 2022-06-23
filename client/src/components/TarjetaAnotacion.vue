<template>
    <div class="w-full border-2 border-gray-700 bg-gray-300 p-4 text-left rounded-md">
        <div class="flex flex-col">
            <p class="font-bold">Título 1</p>
            <p class="">Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.</p>
            
            <div class="mt-4 flex space-x-3">
                <AppButton class="" :name="'Modificar Anotación'"/>
                <p class="text-gray-500 my-auto italic text-sm font-semibold">Creada el 07/05/2022 - Modificada el 07/05/2022</p>
            </div>
        </div>
    </div>
</template>

<script>
import AppButton from '../components/AppButton.vue'

export default {
    name: 'Anotacion',
    components: {
        AppButton
    },
    props: {
        titulo: '',
        anotacion: '',
        creadaEn: '',
        modificadaEn: ''
    }
}
</script>