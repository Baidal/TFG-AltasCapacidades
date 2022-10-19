<template>
    <div class="flex justify-between bg-indigo-600 header-color p-4 w-full">
        <!-- Nombre de la app -->
        <div>
            <router-link :to="{name: 'Home'}"><h2 class="text-2xl">Altas Capacidades</h2></router-link>
        </div>
        <div>

        </div>
        <!-- Botones de login, registro, etc-->
        <div class="flex justify-center space-x-4">
            <router-link :to="{name: 'Expedientes'}"><NavBarButton :name="'Expedientes'"/></router-link>
            
            <router-link :to="{name: 'Administracion'}" v-if="this.userIsAdmin"><NavBarButton :name="'Administración'"/></router-link>
            
            <router-link :to="{name: 'Perfil', params: {id: 2}}"><NavBarButton :name="'Perfil'"/></router-link>
            <router-link :to="{name: 'Login'}" v-if="!this.loggedIn"><NavBarButton :name="'Iniciar Sesión'"/></router-link>
            <NavBarButton :name="'Cerrar sesión'" v-else @click="this.logout"/>
        </div>
    </div>
</template>

<script>
import {mapStores} from 'pinia'
import {useAuthStore} from '../stores/Auth.js'

import NavBarButton from './NavBarButton.vue'

export default {
    name: 'NavBar',
    components: {
        NavBarButton
    },
    computed: {
        ...mapStores(useAuthStore),
        loggedIn(){
            return this.AuthStore.userIsLoggedIn
        },
        userIsAdmin(){
            return this.AuthStore.getUser.rol_id == 3
        },
        userIsPsicologo(){
            return this.AuthStore.getUser.rol_id == 1
        }
    },
    methods: {
        logout(){
            this.AuthStore.logout()
        }
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

