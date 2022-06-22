<template>
    <div>
        <div class="flex flex-col mx-10 mt-5" v-if="this.expedienteEncontrado()">
            <!-- Zona superior de la vista-->
            <div class="flex mb-2">
                <!-- Icono de expediente y nombre de expediente -->
                <div class="flex flex-col text-center sm:w-1/2 md:w-2/5 lg:w-1/3 xl:w-1/4 2xl:w-1/5">
                    <ClipboardListIcon class="h-32 text-green-400"/>
                    <p class="font-bold">{{expediente.nombre}}</p>
                </div>
                <div class="flex-1 ml-5 items-end">
                    <div class="flex flex-col space-y-2">
                        <p class="font-bold">{{expediente.nombre_niño}}</p>
                        <p class="text-sm font-semibold">{{obtenerEdadNiño}}</p>
                        <p class="text-sm font-semibold">{{expediente.dni_niño}}</p>
                        <p class="text-sm text-gray-600 font-semibold">Expediente creado el {{formatearFechaCreacionExpediente}}</p>
                        <AppButton :name="'Modificar expediente'" class="w-52"/>
                    </div>
                </div>
            </div>

            <!-- Raya que separa la zona superior de la inferior -->
            <div class="border border-gray-500 rounded-lg"></div>

            <!-- Zona inferior -->
            <div class="flex sm:flex-col md:flex-row lg:flex-row xl:flex-row 2xl:flex-row">
                <!-- Parte izquierda-->
                <div class="flex flex-col text-center sm:w-1/2 md:w-2/5 lg:w-1/3 xl:w-1/4 2xl:w-1/5">
                    <!-- Bocadillo -->
                    <div class="mx-8 mt-8 border-2 border-gray-700 rounded-md shadow-lg p-4 text-center mb-4">
                        Usuarios relacionados con el expediente
                    </div>
                    <!-- Listado de usuarios relacionados con el expediente -->
                    <div class="mx-auto max-h-52 overflow-x-hidden overflow-y-auto space-y-3 w-3/4 flex items-center flex-col mb-8">
                        <div class="flex space-x-12 justify-between w-full" v-for="usuario in usuariosRelacionados" :key="usuario.id">
                            <UserIcon class="h-7 min-h-full"/>
                            <p class="font-semibold my-auto">{{usuario.nombre}}</p>
                            <XCircleIcon class="h-7 min-h-full cursor-pointer" v-on:click="eliminarRelacionExpedienteUsuario(usuario.id)"/>
                        </div>                     
                    </div>
                    <!-- Usuarios nuevos a relacionar -->
                    <div class="flex flex-col justify-center ">
                        <p class="text-lg font-semibold">Relacionar un usuario con el expediente</p>
                        <InputBuscar :placeHolder="'Buscar usuarios...'" v-model="inputBuscarUsuarios" class="mb-3"/>
                        
                        <div class="max-h-40 overflow-x-hidden overflow-y-auto">
                            <BusquedaUsuarioTarjeta :nombre="usuario.email" class="w-3/4 mx-auto" v-for="usuario in usuariosBuscados" :key="usuario.id" v-on:click="handleSeleccionarUsuario(usuario)"/>
                            <AppButton 
                                :name="this.usuariosSeleccionados.length == 1 ? 'Añadir usuario' : 'Añadir usuarios'" 
                                v-if="this.hayUsuariosSeleccionados" 
                                v-on:click="this.handleRelacionarUsuarios()"
                                class="mt-2"/>
                        </div>
                    </div>
                </div>
                <!-- Parte derecha -->
                <div class="ml-5 mt-6 flex flex-col w-full">
                    <div class="flex justify-between mb-2">
                        <div class="border-gray-700 rounded-sm flex shadow-lg p-1 space-x-4 border-2">
                            <div class="hover:shadow-lg p-2 rounded-md cursor-pointer">
                                <p class="font-semibold text-md text-center">Cuestionarios</p>
                            </div>
                            <p class="my-auto">|</p>
                            <div class="hover:shadow-lg p-2 rounded-md cursor-pointer">
                                <p class="font-semibold text-md text-center rounded-md">Anotaciones</p>
                            </div>
                        </div>    

                        <div class="space-x-4 flex border-gray-700 rounded-sm border-2 px-3">
                            <button class="px-1 font-semibold border-gray-800 rounded-sm hover:bg-gray-50 my-auto items-end">Nueva anotación</button>
                        </div>

                        <div class="w-60 flex">
                            <InputBuscar :placeHolder="'Buscar anotación...'" class="w-full my-auto"/>
                        </div>
                    </div>
                    <div class="border-2 border-gray-600 mb-2"></div>
                    <div class="flex flex-col space-y-2">
                        <TarjetaAnotacion/>
                    </div>
                </div>
            </div>
        </div>
        <p class="font-bold text-center text-2xl mt-4" v-if="!this.expedienteEncontrado() && !this.cargandoDatos">Expediente no encontrado</p>
        <div class="mt-4 flex justify-center" v-if="this.cargandoDatos">
            <MoonLoader/>
        </div>
    </div>
    
</template>

<script>
import MoonLoader from 'vue-spinner/src/MoonLoader.vue'

import {ClipboardListIcon, XCircleIcon} from '@heroicons/vue/outline'
import {UserIcon} from '@heroicons/vue/solid'

import initializeAppObject from '../services/daoProvider'
import AppButton from '../components/AppButton.vue'
import BusquedaUsuarioTarjeta from '../components/BusquedaUsuarioTarjeta.vue'
import InputBuscar from '../components/InputBuscar.vue'

import moment from 'moment'
import TarjetaAnotacion from '../components/TarjetaAnotacion.vue'

export default {
    name: 'Expediente',
    components: {
    ClipboardListIcon,
    AppButton,
    UserIcon,
    XCircleIcon,
    MoonLoader,
    BusquedaUsuarioTarjeta,
    InputBuscar,
    TarjetaAnotacion
},
    props: {
        id: ''
    },
    data() {
        return {
            expediente: {},
            usuariosRelacionados: [],
            cargandoDatos: true,
            inputBuscarUsuarios: '',
            usuariosBuscados: [],
            usuariosSeleccionados: []
        }
    },
    async created(){
        this.cargandoDatos = true

        const expedienteEncontrado = await this.cargarExpediente()

        if (expedienteEncontrado){
            this.cargarUsuariosRelacionados()
        }

        this.cargandoDatos = false
    },
    methods: {
        async cargarExpediente(){
            if(this.id == '')
                return false
            
            const app = await initializeAppObject()
            const expedientes = await app.dao.expediente.read()

            this.expediente = expedientes.find(expedienteDB => expedienteDB.id == this.id) || {}
            
            return this.expedienteEncontrado()
        },
        expedienteEncontrado(){
            return Object.keys(this.expediente).length !== 0
        },
        async cargarUsuariosRelacionados(){
            const app = await initializeAppObject()
            let usuario_expediente = await app.dao.usuario_expediente.read()

            usuario_expediente = usuario_expediente.filter(row => row.expediente_id == this.expediente.id)

            usuario_expediente.forEach(async row => {
                let usuario = await app.dao.usuario.read(row.usuario_id)
                usuario.usuario_expediente_ID = row.id //Guardamos el id de la tabla que relaciona al usuario con el expediente para luego poder acceder a el sin necesidad de tener que recurrir a la BD de nuevo
                this.usuariosRelacionados.push(usuario)
            })
        },
        async eliminarRelacionExpedienteUsuario(usuarioId){
            const usuario = this.usuariosRelacionados.find(usuarioBuscar => usuarioBuscar.id == usuarioId)
            
            const app = await initializeAppObject()
            await app.dao.usuario_expediente.delete({id: usuario.usuario_expediente_ID})

            this.usuariosRelacionados = this.usuariosRelacionados.filter(usuario => usuario.id != usuarioId)
        },
        async buscarUsuariosARelacionar(buscador){
            const app = await initializeAppObject()
            const usuarios = await app.dao.usuario.read()

            this.usuariosBuscados = usuarios.filter(usuario => usuario.email.includes(buscador) || usuario.nombre.includes(buscador))
        },
        handleSeleccionarUsuario(user){
            //El usuario ya había sido seleccionado, lo borramos
            if(this.usuariosSeleccionados.findIndex(usuario => usuario.id == user.id) != -1){
                this.usuariosSeleccionados = this.usuariosSeleccionados.filter(usuario => usuario.id != user.id)
                return
            }

            this.usuariosSeleccionados.push(user)
        },
        handleRelacionarUsuarios(){
            this.usuariosSeleccionados.forEach(async usuarioSeleccionado => {
                //Si el usuario no se ha añadido aun al expediente
                if(this.usuariosRelacionados.findIndex(usuarioRelacionado => usuarioRelacionado.id == usuarioSeleccionado.id) == -1){
                    const app = await initializeAppObject()
                    app.dao.usuario_expediente.create({usuario_id: usuarioSeleccionado.id, expediente_id: this.expediente.id})

                    this.usuariosRelacionados.push(usuarioSeleccionado)

                    return
                }
            })

            this.usuariosSeleccionados = []
            this.usuariosBuscados = []
        }
    },
    watch: {
        inputBuscarUsuarios(new_input, _){
            if (new_input.length == 0){
                this.usuariosBuscados = []
                this.usuariosSeleccionados = []
                return
            }

            if (new_input.length < 3)
                return

            this.buscarUsuariosARelacionar(new_input)
        }
    },
    computed: {
        hayUsuariosSeleccionados(){
            return this.usuariosSeleccionados.length !== 0
        },
        formatearFechaCreacionExpediente(){
            const date = new Date(this.expediente.create_time)
            return date.getDay().toString().padStart(2,'0') + "/" + (date.getMonth() + 1).toString().padStart(2,'0') + "/" + date.getFullYear()
        },
        obtenerEdadNiño(){
            const fechaNacimiento = moment(this.expediente.fechanacimiento_niño)
            const ahora = moment(Date.now())

            const años = ahora.diff(fechaNacimiento, 'years')

            return años == 1 ? años + " año" : años + " años"
        }
    }

}
</script>

<style scoped>
    ::-webkit-scrollbar {
        width: 10px;
    }

    /* Track */
    ::-webkit-scrollbar-track {
        background: #f1f1f1; 
    }
    
    /* Handle */
    ::-webkit-scrollbar-thumb {
    background: #888; 
    }

    /* Handle on hover */
    ::-webkit-scrollbar-thumb:hover {
    background: #555; 
    }
</style>