<template>
    <div class="flex justify-between bg-indigo-500 header-color p-4 w-full">
        <!-- Nombre de la app -->
        <div>
            <h2 class="text-2xl">Altas Capacidades</h2>
        </div>
        <div>

        </div>
        <!-- Botones de login, registro, etc-->
        <div class="flex justify-center space-x-4">
            <NavBarButton :name="'Expediente'"/>
            <NavBarButton :name="'Perfil'"/>
            
            <router-link :to="{name: 'Login'}"><NavBarButton :name="'Iniciar Sesión'"/></router-link>

            <NavBarButton :name="'Registrarse'"/>
        </div>
    </div>
</template>

<script>
import NavBarButton from './NavBarButton.vue'

export default {
    name: 'NavBar',
    components: {
        NavBarButton
    }
}
</script>


<style>
    .header-button {
        border: 2px solid black;
        padding: 4px;
        background-color: white;
    }

</style>

