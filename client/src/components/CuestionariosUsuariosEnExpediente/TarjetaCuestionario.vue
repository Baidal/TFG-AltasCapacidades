<template>
    <div class="border-2 border-black flex flex-col m-2 rounded-md cursor-pointer hover:shadow-xl z-auto" @click.self="this.$router.push({name: 'Cuestionario', params: {id: cuestionario?.cuestionario.id}})">
        <pop-up-eliminar 
            v-if="mostrarEliminarCuestionario"
            :textoPrincipal="'¿Deseas eliminar el cuestionario del usuario? El usuario no podrá realizar este cuestionario hasta que vuelva a ser asignado.'"
            :textoBotonIzq="'Eliminar relación'"
            :textoBotonDer="'Mejor no'"
            @close-eliminar="toggleMostrarEliminarCuestionario"
            @eliminar="eliminarRelacionCuestionario"/>
        <ClipboardListIcon class="h-28"/>
        <p class="text-center text-gray-800 font-bold">{{cuestionario?.cuestionario.nombre}}</p>
        <div class="justify-center flex flex-col items-center">
            <div class="flex justify-center">
                <CheckIcon v-if="cuestionarioCompletado" class="h-4 my-auto"/>
                <p v-if="cuestionarioCompletado">Realizado</p>
            </div>
            
            <p v-if="!cuestionarioCompletado" class="text-red-800 font-semibold">No realizado</p>
            <p 
                v-if="!cuestionarioCompletado" 
                class="text-gray-700 italic hover:shadow-lg hover:border-red-700 hover:bg-red-200 hover:text-red-700 border-2 border-transparent m-2 rounded-md"
                @click="toggleMostrarEliminarCuestionario"   
            >Eliminar cuestionario</p>
            
        </div>
    </div>
</template>

<script>
import {ClipboardListIcon, CheckIcon, XIcon} from '@heroicons/vue/outline'
import PopUpEliminar from '../PopUpEliminar.vue'

import {mapStores} from 'pinia'
import {useAuthStore} from '../../stores/Auth.js'

export default {
    name: 'TarjetaCuestionario',
    components: {
        ClipboardListIcon,
        CheckIcon,
        XIcon,
        PopUpEliminar,
    },
    data(){
        return {
            mostrarEliminarCuestionario: false
        }
    },
    props: {
        cuestionario: Object,
        usuario: {},
        idExpediente: ''
    },
    computed: {
        ...mapStores(useAuthStore),
        cuestionarioCompletado(){
            return this.cuestionario?.completado
        }
    },
    methods: {
        toggleMostrarEliminarCuestionario(){
            this.mostrarEliminarCuestionario = !this.mostrarEliminarCuestionario
        },
        async eliminarRelacionCuestionario(){
            const app = await this.AuthStore.App

            const usuario_expediente = (await app.dao.usuario_expediente.read({}, {filter: {usuario_id: this.usuario.id, expediente_id: this.idExpediente}}))[0]
            
            const cuestionario_usuario_expediente = (await app.dao.cuestionario_usuario_expediente.read({}, {filter: {cuestionario_id: parseInt(this.cuestionario.cuestionario.id), usuario_expediente_id: usuario_expediente.id}}))[0]


            app.dao.cuestionario_usuario_expediente.delete({id: cuestionario_usuario_expediente.id})

            this.$emit('eliminarRelacionCuestionario', this.cuestionario.cuestionario.id)

            this.toggleMostrarEliminarCuestionario()
        }
    }
}
</script>

<style scoped>
    button:hover{
        font-weight: 500;
    }
</style>