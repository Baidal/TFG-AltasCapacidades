<template>
    <div class="border-2 border-black rounded-md m-2 p-2 text-center flex flex-col">
        <pop-up-buscar-cuestionarios 
            v-if="mostrarBuscarCuestionario" 
            @close-buscar-cuestionario="toggleBuscarCuestionario"
            @anyadir-cuestionarios="relacionarCuestionarios"/>
        <p class="font-bold text-left">{{usuario.nombre ? usuario.nombre : 'Usuario sin nombre'}} - {{usuario.categoria.rol}}</p>
        <div class="grid grid-cols-3 w-full grid-container" v-if="sinCuestionarios">
            <TarjetaCuestionario 
                v-for="cuestionario in this.cuestionarios" 
                :key="cuestionario.cuestionario.id" 
                :cuestionario="cuestionario" 
                :usuario="this.usuario" 
                :idExpediente="this.idExpediente"
                @eliminarRelacionCuestionario="eliminarRelacionCuestionario"/>
        </div>
        <router-link :to="{name: 'EstadisticasIndividuales', params: {idExpediente: idExpediente, idUsuario: usuario?.id}}" class="text-blue-700  w-full" v-if="sinCuestionarios">Ver estadísticas</router-link>
        <div v-else>
            <p class="font-bold text-center mt-4">Sin cuestionarios asignados</p>
        </div>
        <app-button :name="'Asignar cuestionarios'" class="mt-2" @click="toggleBuscarCuestionario"/>
    </div>
</template>

<script>

import AppButton from '../AppButton.vue';
import PopUpBuscarCuestionarios from '../PopUpBuscarCuestionarios.vue';
import TarjetaCuestionario from "./TarjetaCuestionario.vue";

import {mapStores} from 'pinia'
import {useAuthStore} from '../../stores/Auth.js'

export default {
    name: "CuestionariosRealizadosUsuarios",
    data(){
        return {
            mostrarBuscarCuestionario: false
        }
    },
    props: {
        usuario: Object,
        cuestionarios: Array,
        idExpediente: ''
    },
    components: { TarjetaCuestionario, AppButton, PopUpBuscarCuestionarios },
    computed: {
        ...mapStores(useAuthStore),
        sinCuestionarios(){
            return this.cuestionarios.length !== 0
        }
    },
    methods: {
        toggleBuscarCuestionario(){
            this.mostrarBuscarCuestionario = !this.mostrarBuscarCuestionario
        },
        async relacionarCuestionarios(cuestionariosSeleccionados){
            const app = await this.AuthStore.App
            

            const usuarioExpediente = (await app.dao.usuario_expediente.read({}, {filter: {usuario_id: this.usuario.id, expediente_id: this.idExpediente}}))[0]
            
            for(const cuestionario of cuestionariosSeleccionados){
                //Eliminamos los cuestionarios que el usuario ya tenga asignados
                if(this.cuestionarios.findIndex(cuestionarioYaAsignado => cuestionarioYaAsignado.cuestionario.id == cuestionario.id) === -1){
                    app.dao.cuestionario_usuario_expediente.create({
                        cuestionario_id: cuestionario.id,
                        usuario_expediente_id: usuarioExpediente.id,
                        completado: 0
                    })

                    this.cuestionarios.push({
                        completado: false,
                        cuestionario: cuestionario
                    })
                }
            }

            this.toggleBuscarCuestionario()
        },
        eliminarRelacionCuestionario(idCuestionario){
            this.$emit('eliminarRelacionCuestionario', idCuestionario, this.usuario.id)
        }
    },
    
}
</script>

<style scoped>
    .grid-container{
        grid-template-columns: repeat(auto-fill, minmax(100px, 140px));
    }
</style>