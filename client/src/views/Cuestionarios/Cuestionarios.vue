<template>
    <div class="w-full px-20 mt-10 flex flex-col">
        <pop-up-anyadir-cuestionario v-if="mostrarAnyadirCuestionario" @close-pop-up="this.toggleMostrarAnyadirCuestionario" @cuestionario-anyadido="cuestionarioAnyadido"/>
        <p class="text-left font-bold text-xl">Listado de cuestionarios</p>
        <div class="w-full border-t-4 border-gray-700 mt-1 rounded-lg h-2"></div>
        <div class="grid grid-rows-4 grid-container">
            <tarjeta-listado-cuestionario v-for="cuestionario in cuestionarios" :key="cuestionario.id" :cuestionario="cuestionario"/>
            <div class="flex flex-col items-center justify-center cursor-pointer" @click="this.toggleMostrarAnyadirCuestionario">
                <PlusIcon class="h-20"/>
                <p class="font-bold text-lg">Nuevo cuestionario</p>
            </div>
        </div>
    </div>
</template>

<script>
import TarjetaListadoCuestionario from '../../components/TarjetaListadoCuestionario.vue'
import PopUpAnyadirCuestionario from '../../components/PopUpAnyadirCuestionario.vue'

import {PlusIcon} from '@heroicons/vue/outline'


import {mapStores} from 'pinia'
import {useAuthStore} from '../../stores/Auth.js'

import utils from '../../services/utils'

export default {
    name: 'Cuestionarios',
    data(){
        return {
            cuestionarios: Array,
            mostrarAnyadirCuestionario: false
        }
    },
    components: {
        TarjetaListadoCuestionario,
        PlusIcon,
        PopUpAnyadirCuestionario
    },
    created(){
        if(!this.AuthStore.userIsLoggedIn)
            return this.$router.push({name: 'Login'})

        if(!(this.userIsPsicologo || this.userIsAdmin))
            return this.$router.push({name: 'NoAutorizado'})

        this.cargarCuestionarios()
    },
    computed: {
        ...mapStores(useAuthStore),
        userIsPsicologo(){
            return utils.userIsPsicologo(this.AuthStore.getUser.id)
        },
        userIsAdmin(){
            return utils.userIsAdmin(this.AuthStore.getUser.id)
        }
    },
    methods: {
        async cargarCuestionarios(){
            const app = await this.AuthStore.App
            if(!app) 
                return this.$router.push({name: 'Login'})

            this.cuestionarios = await app.dao.cuestionarios.read()
        },
        toggleMostrarAnyadirCuestionario(){
            this.mostrarAnyadirCuestionario = !this.mostrarAnyadirCuestionario
        },
        cuestionarioAnyadido(cuestionario){
            this.cuestionarios.push(cuestionario)
            this.toggleMostrarAnyadirCuestionario()
        }
    }
}
</script>

<style scoped>
    .grid-container{
        grid-template-columns: repeat(auto-fill, minmax(220px, 1fr));
    }
</style>