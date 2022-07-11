<template>
    <div class="mx-auto w-1/4 mt-10 border-l-2 border-indigo-600 rounded-md shadow-xl p-6 text-center flex flex-col items-center">
        <h1 class="font-bold text-lg">Iniciar sesión</h1>
        <input class="mt-3 border-2 border-gray-700 rounded-lg w-2/3" placeholder="Email..."/>
        <input class="mt-3 border-2 border-gray-700 rounded-lg w-2/3" placeholder="Contraseña..."/>
        <AppButton :name="'Inicia Sesión'" class="mt-3"/>
    </div>
</template>

<script>
import AppButton from '../components/AppButton.vue';
export default {
    name: "Login",
    components: { AppButton }
}
</script>