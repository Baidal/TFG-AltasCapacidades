<template>
    <div class="fixed top-0 left-0 w-screen h-screen bg-gray-200 opacity-90 z-20">
        <div class="absolute top-1/3 left-1/2 -mt-12 -ml-80 w-1/3 border-2 border-black rounded-md shadow-md opacity-100 p-2 bg-white z-40">
            <div class="absolute top-2 right-4 cursor-pointer"><XCircleIcon class="w-6 h-6" @click="this.closePopUp"/></div>
            <div class="flex flex-col w-full px-3">
                <h1 class="mt-3 font-bold text-lg text-center">Datos del usuario</h1>
                <div class="flex flex-col items-center justify-center space-y-2">
                    <h1 class="font-semibold mt-2 text-lg text-gray-800">{{obtenerNombreUsuario}}</h1>
                    <div class="flex justify-center space-x-2">
                        <h1 class="text-blue-500">{{usuario.email}}</h1>
                        <p class="font-semibold text-gray-800">-</p>
                        <h1 class="text-gray-700 font-semibold">{{usuario.categoria?.rol}}</h1>
                    </div>
                    <h1 class="text-gray-700 mt-2 font-semibold">{{usuario.telefono ? usuario.telefono : 'Usuario sin teléfono'}}</h1>
                    <h1 class="text-gray-700 font-semibold">{{obtenerStringNacimiento}}</h1>
                    <h1 class="text-gray-700 font-semibold">Estado civil: {{ usuario.estado_civil ? usuario.estado_civil : 'Prefiero no decirlo' }}</h1>
                    <h1 class="text-gray-700 font-semibold">Género: {{ usuario.genero ? usuario.genero : 'Prefiero no decirlo' }}</h1>
                </div>
                <h1 class="mt-3 font-bold text-lg text-center">Datos del usuario en el expediente</h1>
                <div class="flex flex-col items-center justify-center space-y-2">
                    <h1 class="text-gray-700 font-semibold">Relación con el niño: {{ datosUsuarioExpediente.relacion_niño ? datosUsuarioExpediente.relacion_niño : 'Sin especificar' }}</h1>
                    <h1 class="text-gray-700 font-semibold">Fecha desde que se conoce al niño: {{ datosUsuarioExpediente.fecha_conoce ? obtenerFechaConoce : 'Sin especificar' }}</h1>
                    <h1 class="text-gray-700 font-semibold">Colaboración: {{ datosUsuarioExpediente.colaboracion ? datosUsuarioExpediente.colaboracion : 'Sin especificar' }}</h1>
                    <h1 class="text-gray-700 font-semibold" v-if="usuarioEsCentro">Especialidad: {{ datosUsuarioExpediente.profesion ? datosUsuarioExpediente.profesion : 'Sin especificar' }}</h1>
                    <h1 class="text-gray-700 font-semibold">Categoría en el expediente: {{ usuario.categoriaEnExpediente ? usuario.categoriaEnExpediente.rol : 'Sin especificar' }}</h1>
                </div>
            </div>
        </div>
    </div>
</template>

<script>
import {XCircleIcon} from '@heroicons/vue/outline'

import {mapStores} from 'pinia'
import {useAuthStore} from '../stores/Auth'
import utils from '../services/utils'

export default {
    name: 'PopUpMostrarDatosUsuarioEnExpediente',
    props: {
        idExpediente: '',
        idUsuario: ''
    },
    components: {
        XCircleIcon
    },
    data(){
        return {
            usuario: {},
            expediente: {},
            datosUsuarioExpediente: {}
        }
    },
    created(){
        this.cargarUsuario()
        this.cargarExpediente()
    },
    computed: {
        ...mapStores(useAuthStore),
        obtenerNombreUsuario(){
            if(this.usuario.nombre)
                return this.usuario.nombre + " " + this.usuario.apellidos

            return "Usuario sin nombre"
        },
        obtenerStringNacimiento(){
            if(!this.usuario.fecha_nacimiento)
                return "Sin fecha de nacimiento"

            return "Nació el " + utils.formatearFecha(this.usuario.fecha_nacimiento)
        },
        usuarioEsCentro(){
            return utils.userIsCentro(this.usuario.id)
        },
        obtenerFechaConoce(){
            return utils.formatearFecha(this.datosUsuarioExpediente.fecha_conoce)
        }
    },
    methods: {
        closePopUp(){
            this.$emit('closePopUpMostrarDatosUsuario')
        },
        async cargarUsuario(){
            const app = await this.AuthStore.App
            if(!app)
                return this.$router.push({name: 'Login'})


            this.usuario = await app.dao.usuario.read(this.idUsuario)
            this.usuario.categoria = await app.dao.rol.read(this.usuario.rol_id)

            const usuario_expediente = (await app.dao.usuario_expediente.read({}, {filter: {usuario_id: this.idUsuario, expediente_id: parseInt(this.idExpediente)}}))[0]
            
            this.usuario.categoriaEnExpediente = await app.dao.rol.read(usuario_expediente.rol_id)
            
            this.datosUsuarioExpediente = await app.dao.datos_adicionales_usuario.read(usuario_expediente.datos_adicionales_usuario_id)
            console.log(utils.formatearFecha(this.datosUsuarioExpediente.fecha_conoce))
        },
        async cargarExpediente(){
            const app = await this.AuthStore.App
            if(!app)
                return this.$router.push({name: 'Login'})

            this.expediente = await app.dao.expediente.read(parseInt(this.idExpediente))
        }
    }
}
</script>
