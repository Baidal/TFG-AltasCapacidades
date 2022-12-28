<template>
    <div class="fixed top-0 left-0 w-screen h-screen bg-gray-200 opacity-90 z-20">
        <div class="absolute top-1/3 left-1/2 -mt-12 -ml-80 w-1/3 border-2 border-black rounded-md shadow-md opacity-100 p-2 bg-white z-40">
            <div class="absolute top-2 right-4 cursor-pointer"><XCircleIcon class="w-6 h-6" @click="this.closePopUp"/></div>
            <h1 class="text-xl font-bold text-center">Mis datos en el expediente</h1>
            <!-- Contenedor con todos los inputs -->
            <div class="flex flex-col mt-2 w-full px-2">
                <!-- profesion -->
                <div class="flex flex-col w-full" v-if="usuarioEsCentro">
                    <p class="text-gray-600 font-semibold">Mi especialidad</p>
                    <input class="border-2 border-black rounded-md" placeholder="Especialidad..." v-model="datosUsuarioExpediente.profesion"/>
                </div>
                <div class="flex flex-col w-full mt-2">
                    <p class="text-gray-600 font-semibold">Mi relación con el niño/a</p>
                    <textarea class="border-2 border-black rounded-md h-20" placeholder="Relación..." v-model="datosUsuarioExpediente.relacion_niño"></textarea>
                </div>
                <div class="flex flex-col w-full mt-2">
                    <p class="text-gray-600 font-semibold">Colabaoración</p>
                    <textarea class="border-2 border-black rounded-md h-20" placeholder="Colaboración..." v-model="datosUsuarioExpediente.colaboracion"></textarea>
                </div>
                <div class="flex flex-col w-full mt-2 ">
                    <p class="text-gray-600 font-semibold">Fecha desde que conozco al niño (aproximadamente)</p>
                    <input class="border-2 border-black rounded-md w-52" placeholder="Especialidad..." type="date" v-model="datosUsuarioExpediente.fecha_conoce"/>
                </div>
                <div class="flex w-full justify-center space-x-3 mt-4">
                    <app-button :name="'Mejor no'" @click="this.closePopUp"/>
                    <app-button :name="'Modificar datos'" @click="this.modificarDatos"/>
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
import AppButton from './AppButton.vue'

export default {
    name: 'PopUpModificarDatosUsuarioEnExpediente',
    components: {
        XCircleIcon,
        AppButton
    },
    props: {
        expedienteId: ''
    },
    data(){
        return {
            datosUsuarioExpediente: {},
        }
    },
    created(){
        this.cargarDatosUsuarioEnExpediente()
    },
    computed: {
        ...mapStores(useAuthStore),
        usuarioEsCentro(){
            return utils.userIsCentro(this.datosUsuarioExpediente?.rol_en_expediente)
        }
    },
    methods: {
        closePopUp(){
            this.$emit('closePopUpModificarDatosUsuario')
        },
        async cargarDatosUsuarioEnExpediente(){
            const app = await this.AuthStore.App
            if(!app)
                return this.$router.push({name: 'Login'})
        
            let usuario_expediente = (await app.dao.usuario_expediente.read({}, {filter: {usuario_id: this.AuthStore.getUser.id, expediente_id: parseInt(this.expedienteId)}}))[0]

            //Si por algún casual el usuario aún no tiene una instancia creada de la tabla datos_adicionales_usuario para el expediente, la creamos
            if(!usuario_expediente.datos_adicionales_usuario_id){
                //Creamos la nueva instancia
                let nuevoDatosUsuario = await app.dao.datos_adicionales_usuario.create()
                
                //Copiamos el objeto usuario expediente a uno nuevo para evitar perder el id
                let usuario_expediente_modificar = Object.assign({}, usuario_expediente)
                delete usuario_expediente_modificar.id

                usuario_expediente_modificar.datos_adicionales_usuario_id = nuevoDatosUsuario.id

                await app.dao.usuario_expediente.update(usuario_expediente.id, usuario_expediente_modificar)
            }

            this.datosUsuarioExpediente = await app.dao.datos_adicionales_usuario.read(usuario_expediente.datos_adicionales_usuario_id)
            this.datosUsuarioExpediente.rol_en_expediente = usuario_expediente.rol_id
            if(this.datosUsuarioExpediente.fecha_conoce)
                this.datosUsuarioExpediente.fecha_conoce = utils.formatearFechaAEstandar(this.datosUsuarioExpediente.fecha_conoce)
        },
        async modificarDatos(){
            const app = await this.AuthStore.App
            if(!app)
                return this.$router.push({name: 'Login'})
            
            this.datosUsuarioExpediente.fecha_conoce = utils.formatearFechaAMysql(this.datosUsuarioExpediente.fecha_conoce)
            console.log(this.datosUsuarioExpediente.fecha_conoce)
            this.datosUsuarioExpediente.create_time = utils.formatearFechaAMysql(this.datosUsuarioExpediente.create_time)
            this.datosUsuarioExpediente.update_time = utils.formatearFechaAMysql()
    
            let datosUsuariosExpedienteModificar = Object.assign({}, this.datosUsuarioExpediente)
            delete datosUsuariosExpedienteModificar.id

            app.dao.datos_adicionales_usuario.update(this.datosUsuarioExpediente.id, datosUsuariosExpedienteModificar)
            this.closePopUp()

        }
    },
}
</script>