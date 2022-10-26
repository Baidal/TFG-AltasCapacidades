<template>
    <div>
        <div class="flex flex-col mt-10 justify-center items-center" v-if="userPerteneceExpediente">
            <div class="w-2/5 text-center">
                <p class="font-semibold text-2xl">Estadísticas obtenidas de los cuestionarios realizados por <b>{{nombreUsuario}}</b> en el expediente <b>{{expediente.nombre}}</b></p>
            </div>
            <div class="w-1/2 flex mt-8">
                <div class="w-1/4 text-center flex flex-col items-center justify-center mx-8">
                    <p class="font-bold text-3xl">
                        69% Aptitud*
                    </p>
                    <p class="italic text-gray-600 font-semibold">
                        *Datos obtenidos de calcular la media de todos los informes generados a partir de los resultados de los usuarios
                    </p>
                </div>
                <div class="w-3/4">
                    <StatsBar :color="'#f87979'" :data="[65,67,70,85,79]" :label="'% Aptitud obtenida para cada ámbito'"></StatsBar>
                </div>
            </div>
            <app-button :name="'Volver'" class="mt-4" @click="this.$router.push({name: 'Expediente', params: {id: this.idExpediente}})"/>
        </div>
        <div v-else class="mt-10 text-3xl text-center">
            No existe la relación entre los usuarios indicados.
        </div>
    </div>
</template>


<script>
import {mapStores} from 'pinia'
import {useAuthStore} from '../../stores/Auth'

import StatsBar from '../../components/StatsBar.vue'

import utils from '../../services/utils'
import AppButton from '../../components/AppButton.vue'

export default {
    name: 'EstadisticiasIndividuales',
    props: {
        idExpediente: '',
        idUsuario: ''
    },
    components: {
        StatsBar,
        AppButton
    },
    data(){
        return {
            userPerteneceExpediente: true,
            user: {},
            expediente: {}
        }
    },
    async created(){
        if(!this.AuthStore.userIsLoggedIn)
            return this.$router.push({name: 'Login'})

        if(!this.userIsPsicologo)
            return this.$router.push({name: 'NoAutorizado'})

        await this.userPerteneceAExpediente()

        if(this.userPerteneceExpediente){
            this.cargarUser()
            this.cargarExpediente()
        }

    },
    methods: {
        async userPerteneceAExpediente(){
            const app = await this.AuthStore.App

            const usuario_expediente = await app.dao.usuario_expediente.read({}, {filter: {usuario_id: this.idUsuario, expediente_id: this.idExpediente}})

            this.userPerteneceExpediente = usuario_expediente.length !== 0
        },
        async cargarUser(){
            const app = await this.AuthStore.App
            this.user = await app.dao.usuario.read(parseInt(this.idUsuario))
        },
        async cargarExpediente(){
            const app = await this.AuthStore.App
            this.expediente = await app.dao.expediente.read(parseInt(this.idExpediente))
        }
    },
    computed: {
        ...mapStores(useAuthStore),
        userIsPsicologo(){
            return utils.userIsPsicologo(this.AuthStore.getUser.rol_id)
        },
        nombreUsuario(){
            return this.user?.nombre + ' ' + this.user?.apellidos
        }
    }
}
</script>