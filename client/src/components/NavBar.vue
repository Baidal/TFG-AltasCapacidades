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
            <router-link :to="{name: 'Expedientes'}" v-if="this.loggedIn"><NavBarButton :name="'Expedientes'"/></router-link>
            <router-link :to="{name: 'CrearUsuario' }" v-if="this.loggedIn && (this.userIsAdmin || this.userIsPsicologo)"><NavBarButton :name="'Nuevo usuario'"/></router-link>
            <router-link :to="{name: 'Administracion'}" v-if="this.userIsAdmin"><NavBarButton :name="'Administración'"/></router-link>
            
            <router-link :to="{name: 'Perfil', params: {id: this.userId}}" v-if="this.loggedIn"><NavBarButton :name="'Perfil'"/></router-link>
            <router-link :to="{name: 'Login'}" v-if="!this.loggedIn"><NavBarButton :name="'Iniciar Sesión'"/></router-link>
            <NavBarButton :name="'Cerrar sesión'" v-else @click="this.logout"/>
        </div>
    </div>
</template>

<script>
import {mapStores} from 'pinia'
import {useAuthStore} from '../stores/Auth.js'

import NavBarButton from './NavBarButton.vue'

import utils from '../services/utils'

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
            return utils.userIsAdmin(this.AuthStore.getUser.rol_id)
        },
        userIsPsicologo(){
            return utils.userIsPsicologo(this.AuthStore.getUser.rol_id)
        },
        userId(){
            return this.AuthStore.getUser.id || 0
        }
    },
    methods: {
        logout(){
            this.AuthStore.logout()
            this.$router.push({name: 'Login'})
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

