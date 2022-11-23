<template>
    <div class="m-4 border-2 rounded-md border-gray-800 shadow-2xl flex flex-col p-4">
        <pop-up-buscar-cuestionarios v-if="mostrarBuscarCuestionarios" @close-buscar-cuestionario="toggleMostrarBuscarCuestionarios" @anyadir-cuestionarios="anyadirCuestionarios"/>
        <p class="font-bold txt-lg">{{this.categoria.rol}}</p>
        <div class="w-full grid grid-cols-3">
            <tarjeta-listado-cuestionario v-for="cuestionario in cuestionarios" :key="cuestionario?.id" :cuestionario="cuestionario" :mostrarEliminar="true" @eliminar-cuestionario="eliminarCuestionario"/>
            <div class="flex flex-col items-center justify-center h-56 cursor-pointer" @click="toggleMostrarBuscarCuestionarios">
                <PlusIcon class="h-16 text-gray-800"/>
                <p class="font-bold text-lg text-gray-800">Relacionar cuestionario</p>
            </div>
        </div>
    </div>
</template>

<script>
import TarjetaListadoCuestionario from '../../components/TarjetaListadoCuestionario.vue'

import {PlusIcon} from '@heroicons/vue/outline'


import {mapStores} from 'pinia'
import {useAuthStore} from '../../stores/Auth.js'
import PopUpBuscarCuestionarios from '../../components/PopUpBuscarCuestionarios.vue'

export default {
    name: 'TarjetaCategoria',
    props: {
        categoria: Object
    },
    data(){
        return {
            cuestionarios: [],
            mostrarBuscarCuestionarios: false
        }
    },
    components: {
        TarjetaListadoCuestionario,
        PlusIcon,
        PopUpBuscarCuestionarios
    },
    created(){
        this.cargarCuestionarios()
    },
    computed: {
        ...mapStores(useAuthStore)
    },
    methods: {
        async cargarCuestionarios(){
            const app = await this.AuthStore.App
            if(!app)
                return this.$router.push({name: 'Login'})
        
            const cuestionarios_defecto_rol = await app.dao.cuestionarios_defecto_rol.read({}, {filter: {rol_id: this.categoria.id}})

            for(const cuestionarioDefecto of cuestionarios_defecto_rol){
                const cuestionarioDB = await app.dao.cuestionarios.read(cuestionarioDefecto.cuestionario_id)
                console.log(this.cuestionarios)
                this.cuestionarios.push(cuestionarioDB)
            }
        },
        async eliminarCuestionario(idCuestionario){
            const app = await this.AuthStore.App
            if(!app)
                return this.$router.push({name: 'Login'})

            const cuestionario_defecto_rol = (await app.dao.cuestionarios_defecto_rol.read({}, {filter: {cuestionario_id: idCuestionario, rol_id: this.categoria.id}}))[0]
            await app.dao.cuestionarios_defecto_rol.delete({id: cuestionario_defecto_rol.id})

            this.cuestionarios = this.cuestionarios.filter(cuestionario => cuestionario.id != idCuestionario)
        },
        toggleMostrarBuscarCuestionarios(){
            this.mostrarBuscarCuestionarios = !this.mostrarBuscarCuestionarios
        },
        async anyadirCuestionarios(cuestionariosSeleccionados){
            const app = await this.AuthStore.App
            if(!app)
                return this.$router.push({name: 'Login'})

            for(const cuestionarioSeleccionado of cuestionariosSeleccionados){
                //si el cuestionario no ha sido añadido a la categoria
                if(this.cuestionarios.findIndex(cuestionario => cuestionario.id == cuestionarioSeleccionado.id) === -1){
                    app.dao.cuestionarios_defecto_rol.create({rol_id: this.categoria.id, cuestionario_id: cuestionarioSeleccionado.id})
                    this.cuestionarios.push(cuestionarioSeleccionado)
                }   
            }

            this.toggleMostrarBuscarCuestionarios()
        }
    }
}
</script>