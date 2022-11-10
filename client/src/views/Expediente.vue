<template>
    <div>
        <div class="flex flex-col mx-10 mt-5 mb-20" v-if="this.expedienteEncontrado()">
            <PopUpNuevaAnotacion 
                v-if="mostrarNuevaAnotacion" 
                @close-nueva-anotacion="toggleMostrarNuevaAnotacion"
                @nueva-anotacion="añadirNuevaAnotacion"
            />
            <PopUpModificarExpediente
                v-if="mostrarModificarExpediente"
                @close-modificar-expediente="toggleMostrarModificarExpediente"
                :expediente="this.expediente"
                @modificar-expediente="modificarExpediente"
            />
            <PopUpDesrelacionarUsuarioExpediente 
                v-if="mostrarDesrelacionarExpediente"
                @close-desrelacionar="toggleMostrarDesrelacionar"
                @desrelacionar-usuario="eliminarRelacionExpedienteUsuario"
                :usuarioId="usuarioADesrelacionar"
            />
            <!-- Zona superior de la vista-->
            <div class="flex mb-2">
                <!-- Icono de expediente y nombre de expediente -->
                <div class="flex flex-col text-center sm:w-1/2 md:w-2/5 lg:w-1/3 xl:w-1/4 2xl:w-1/5">
                    <IdentificationIcon class="h-32 text-gray-700"/>
                    <p class="font-bold">{{expediente.nombre}}</p>
                </div>
                <div class="flex-1 ml-5 items-end">
                    <div class="flex flex-col space-y-2">
                        <p class="font-bold">{{expediente.nombre_niño}} {{expediente.apellidos_niño}}</p>
                        <p class="text-sm font-semibold">{{obtenerEdadNiño}}</p>
                        <p class="text-sm font-semibold">{{expediente.dni_niño}}</p>
                        <p class="text-sm text-gray-600 font-semibold">Expediente creado el {{formatearFechaCreacionExpediente}}</p>
                        <AppButton :name="'Modificar expediente'" class="w-52" @click="toggleMostrarModificarExpediente"/>
                    </div>
                </div>
            </div>

            <!-- Raya que separa la zona superior de la inferior -->
            <div class="border border-gray-500 rounded-lg"></div>

            <!-- Zona inferior -->
            <div class="flex sm:flex-col md:flex-row lg:flex-row xl:flex-row 2xl:flex-row">
                <!-- Parte izquierda-->
                <div v-if="userIsPsicologo" class="flex flex-col text-center sm:w-1/2 md:w-2/5 lg:w-1/3 xl:w-1/4 2xl:w-1/5">
                    <!-- Bocadillo -->
                    <div class="mx-8 mt-8 border-2 border-gray-700 rounded-md shadow-lg p-4 text-center mb-4">
                        Usuarios relacionados con el expediente
                    </div>
                    <!-- Listado de usuarios relacionados con el expediente -->
                    <div class="mx-auto max-h-52 overflow-x-hidden overflow-y-auto space-y-3 w-3/4 flex items-center flex-col mb-8">
                        <div class="flex justify-between w-full" v-for="usuario in usuariosRelacionados" :key="usuario.id">
                            <UserIcon class="h-11 my-auto"/>
                            <div class="flex flex-col w-full cursor-pointer" v-on:click="this.$router.push({name: 'Perfil', params: {id: usuario.id}})">
                                <p class="font-semibold my-auto" v-if="usuario.nombre">{{usuario.nombre}}</p>
                                <p class="italic text-gray-400 text-sm my-auto" v-else>Usuario sin nombre</p>
                                <p v-if="usuario.usuario_eliminado" class="text-sm italic text-gray-700">usuario eliminado</p>

                                <p class="italix text-gray-500 text-xs">{{usuario.rol}}</p>
                            </div>
                            <XCircleIcon 
                                :class="'h-11 my-auto z-10' + (userIsPsicologo && usuarioSePuedeDesrelacionar(usuario.id) ? ' cursor-pointer' : ' cursor-not-allowed') + (usuario.usuario_eliminado ? ' cursor-not-allowed' : '')" 
                                v-on:click="userIsPsicologo && !usuario.usuario_eliminado && usuarioSePuedeDesrelacionar(usuario.id) && toggleMostrarDesrelacionar(usuario.id)"/>
                        </div>                     
                    </div>
                    <!-- Usuarios nuevos a relacionar -->
                    <div class="flex flex-col justify-center ">
                        <p class="text-lg font-semibold">Relacionar un usuario con el expediente</p>
                        <InputBuscar :placeHolder="'Buscar usuarios...'" v-model="inputBuscarUsuarios" class="mb-3"/>
                        <select class="w-1/2 mx-auto border-2 border-gray-900 rounded-md" ref="seleccionarCategoria">
                            <option :value="categoria.id" v-for="categoria in categorias" :key="categoria.id">{{categoria.rol}}</option>
                        </select>

                        <div class="max-h-40 overflow-x-hidden overflow-y-auto mt-2">
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
                <div class="ml-5 mt-6 flex-1 flex-col">
                    <div class="flex justify-between mb-2">
                        <div class="border-black rounded-sm flex shadow-lg p-1 space-x-4 border-2">
                            <div class="hover:shadow-lg p-2 rounded-md cursor-pointer">
                                <p class="font-semibold text-md text-center" @click="toggleContenidoPrincipal('cuestionarios')">Cuestionarios</p>
                            </div>
                            <p v-if="userIsPsicologo" class="my-auto">|</p>
                            <div v-if="userIsPsicologo" class="hover:shadow-lg p-2 rounded-md cursor-pointer">
                                <p class="font-semibold text-md text-center rounded-md" @click="toggleContenidoPrincipal('anotaciones')">Anotaciones</p>
                            </div>
                            <p v-if="userIsPsicologo" class="my-auto">|</p>
                            <div v-if="userIsPsicologo" class="hover:shadow-lg p-2 rounded-md cursor-pointer">
                                <p class="font-semibold text-md text-center rounded-md" @click="toggleContenidoPrincipal('cuestionariosrealizados')">Cuestionarios realizados</p>
                            </div>
                            <p v-if="userIsPsicologo" class="my-auto">|</p>
                            <div v-if="userIsPsicologo" class="hover:shadow-lg p-2 rounded-md cursor-pointer">
                                <p class="font-semibold text-md text-center rounded-md" @click="toggleContenidoPrincipal('estadisticasexpediente')">Estadísticas del expediente</p>
                            </div>
                        </div>    

                        <div class="space-x-4 flex border-gray-700 rounded-sm border-2 px-3 hover:bg-gray-50" v-if="contenidoPrincipalAnotaciones">
                            <button class="px-1 font-semibold border-gray-800 rounded-sm my-auto" @click="toggleMostrarNuevaAnotacion">Nueva anotación</button>
                        </div>
                        <div v-if="contenidoPrincipalCuestionarios" class="my-auto text-lg font-bold">
                            Cuestionarios
                        </div>
                        <div v-if="contenidoPrincipalCuestionariosRealizados" class="my-auto text-lg font-bold">
                            Cuestionarios Realizados
                        </div>
                        <div v-if="contenidoPrincipalEstadisticasExpediente" class="my-auto text-lg font-bold">
                            Estadísticas
                        </div>

                        <div class="w-60 flex items-end" v-if="contenidoPrincipalAnotaciones">
                            <InputBuscar :placeHolder="'Buscar anotación...'" class="w-full" v-model="buscarAnotacion"/>
                        </div>
                        <div class="w-60 flex items-end" v-if="contenidoPrincipalCuestionarios">
                            <InputBuscar :placeHolder="'Buscar cuestionario...'" class="w-full" v-model="buscarCuestionario"/>
                        </div>
                        <!-- <div v-if="contenidoPrincipalCuestionariosRealizados || contenidoPrincipalEstadisticasExpediente">

                        </div> -->
                    </div>
                    <div class="border-2 border-gray-600 mb-2"></div>
                    <div class="flex flex-col space-y-2 overflow-y-auto main-section-height" v-if="contenidoPrincipalAnotaciones">
                        <p v-if="this.anotaciones.length === 0" class="text-2xl font-semibold text-gray-700">Aún no existen anotaciones</p>
                        <TarjetaAnotacion v-for="anotacion in anotaciones" :key="anotacion.id" :anotacion="anotacion" @modificar-anotacion="modificarAnotacion" @eliminar-anotacion="eliminarAnotacion"/>
                    </div>
                    <div class="overflow-y-auto main-section-height grid grid-rows-4 grid-container" v-if="contenidoPrincipalCuestionarios">
                        <p v-if="this.cuestionarios.length === 0" class="text-2xl font-semibold text-gray-700">No hay cuestionarios por realizar</p>
                        <router-link :to="{name: 'Cuestionario', params: {id: cuestionario.id}}" class="w-full h-56 flex justify-center text-center p-2" v-for="cuestionario in cuestionarios" :key="cuestionario.id">
                            <div class="rounded-lg shadow-lg w-full mx-1 flex flex-col items-center hover:shadow-xl cursor-pointer">
                                <ClipboardListIcon class="h-22 text-gray-800"/>
                                <h1 class="font-semibold mb-4">{{cuestionario.nombre}}</h1>
                            </div>
                        </router-link>
                    </div>
                    <div v-if="contenidoPrincipalCuestionariosRealizados">
                        <CuestionariosRealizadosUsuarios :expedienteId="this.id"/>
                    </div>
                    <div v-if="contenidoPrincipalEstadisticasExpediente">
                        <EstadisticasExpediente :idExpediente="this.id"/>
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

import {ClipboardListIcon, XCircleIcon, IdentificationIcon} from '@heroicons/vue/outline'
import {UserIcon} from '@heroicons/vue/solid'

import AppButton from '../components/AppButton.vue'
import BusquedaUsuarioTarjeta from '../components/BusquedaUsuarioTarjeta.vue'
import InputBuscar from '../components/InputBuscar.vue'
import TarjetaAnotacion from '../components/TarjetaAnotacion.vue'
import NuevaAnotacion from '../components/PopUpNuevaAnotacion.vue'

import moment from 'moment'
import utils from '../services/utils'
import PopUpNuevaAnotacion from '../components/PopUpNuevaAnotacion.vue'
import PopUpModificarExpediente from '../components/PopUpModificarExpediente.vue'
import TarjetaCuestionario from '../components/TarjetaCuestionario.vue'
import PopUpDesrelacionarUsuarioExpediente from '../components/PopUpDesrelacionarUsuarioExpediente.vue'

import {mapStores} from 'pinia'
import {useAuthStore} from '../stores/Auth'
import CuestionariosRealizadosUsuarios from '../components/CuestionariosUsuariosEnExpediente/CuestionariosRealizadosUsuarios.vue'
import EstadisticasExpediente from '../components/EstadisticasExpediente/EstadisticasExpediente.vue'

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
    TarjetaAnotacion,
    NuevaAnotacion,
    PopUpNuevaAnotacion,
    PopUpModificarExpediente,
    IdentificationIcon,
    TarjetaCuestionario,
    PopUpDesrelacionarUsuarioExpediente,
    CuestionariosRealizadosUsuarios,
    EstadisticasExpediente
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
            usuariosSeleccionados: [],
            /**
             * Define cual es el contenido mostrado en el expediente
             * Puede ser anotaciones o cuestionarios
             */
            contenidoPrincipal: 'cuestionarios',
            anotaciones: [],
            cuestionarios: [],
            buscarAnotacion: '',
            buscarCuestionario: '',
            mostrarNuevaAnotacion: false,
            mostrarModificarExpediente: false,
            mostrarDesrelacionarExpediente: false,
            usuarioADesrelacionar: '',
            cuestionarios: [],
            categorias: []
        }
    },
    async created(){
        if(!this.loggedIn)
            return this.$router.push({name: 'Login'})

        if(!(await this.userHasAccess))
            return this.$router.push({name: 'NoAutorizado'})
        
        this.cargandoDatos = true
        console.log("TEST: ", this.AuthStore.getUser)
        const expedienteEncontrado = await this.cargarExpediente()

        if (expedienteEncontrado){
            this.cargarUsuariosRelacionados()
            this.cargarAnotaciones()
            this.cargarCuestionarios()
            this.cargarCategorias()
        }

        this.cargandoDatos = false
    },
    methods: {
        async cargarExpediente(){
            if(this.id == '')
                return false
            
            const app = await this.AuthStore.App
            if(!app){
                this.$router.push({name: 'Login'})
                return
            }

            const expedientes = await app.dao.expediente.read()

            this.expediente = expedientes.find(expedienteDB => expedienteDB.id == this.id) || {}
            
            return this.expedienteEncontrado()
        },
        expedienteEncontrado(){
            return Object.keys(this.expediente).length !== 0
        },
        async cargarUsuariosRelacionados(){
            const app = await this.AuthStore.App
            if(!app){
                this.$router.push({name: 'Login'})
                return
            }
            
            let usuario_expediente = await app.dao.usuario_expediente.read({}, {filter: {expediente_id: this.expediente.id}})

            usuario_expediente.forEach(async row => {
                let usuario = await app.dao.usuario.read(row.usuario_id)

                usuario.usuario_expediente_ID = row.id //Guardamos el id de la tabla que relaciona al usuario con el expediente para luego poder acceder a el sin necesidad de tener que recurrir a la BD de nuevo
                usuario.usuario_eliminado = row.usuario_eliminado == 1 ? true : false

                //buscamos el rol del usuario dentro del expediente
                const rol_usuario_expediente = await app.dao.rol.read(row.rol_id)
                usuario.rol = rol_usuario_expediente.rol
                console.log(rol_usuario_expediente)
                this.usuariosRelacionados.push(usuario)

            })
        },
        async cargarAnotaciones(){
            const app = await this.AuthStore.App
            if(!app){
                this.$router.push({name: 'Login'})
                return
            }

            let anotacionesDB = await app.dao.anotaciones.read({}, {filter: {expediente_id: this.expediente.id}})
            anotacionesDB = anotacionesDB.sort((a1, a2) => {
                const dateA1 = new Date(a1.create_time)
                const dateA2 = new Date(a2.create_time)
                return dateA1 > dateA2 ? -1 : 1
            })

            this.anotaciones = anotacionesDB
        },
        async cargarCuestionarios(){
            const app = await this.AuthStore.App
            if(!app){
                this.$router.push({name: 'Login'})
                return
            }
            
            let usuario_expediente = await app.dao.usuario_expediente.read({}, {filter: {usuario_id: this.AuthStore.getUser.id, expediente_id: this.id}})
            usuario_expediente = usuario_expediente[0]
            
            let cuestionario_usuario_expediente = await app.dao.cuestionario_usuario_expediente.read({}, {filter: {usuario_expediente_id: usuario_expediente.id}})

            for(let cuestionarioRelacionado of cuestionario_usuario_expediente){
                const cuestionario = await app.dao.cuestionarios.read(cuestionarioRelacionado.cuestionario_id)
                this.cuestionarios.push(cuestionario)
            }
        },
        async cargarCategorias(){
            const app = await this.AuthStore.App
            if(!app){
                this.$router.push({name: 'Login'})
                return
            }

            let categoriasDB =  await app.dao.rol.read()
            categoriasDB = categoriasDB.filter(categoria => !categoria.rol.includes('admin'))
            this.categorias = categoriasDB
        },
        async eliminarRelacionExpedienteUsuario(usuarioId){
            const usuario = this.usuariosRelacionados.find(usuarioBuscar => usuarioBuscar.id == usuarioId)
            
            const app = await this.AuthStore.App
            if(!app){
                this.$router.push({name: 'Login'})
                return
            }

            await app.dao.usuario_expediente.update({id: usuario.usuario_expediente_ID}, {usuario_eliminado: 1})

            this.usuariosRelacionados = this.usuariosRelacionados.filter(usuario => usuario.id != usuarioId)
        
            this.toggleMostrarDesrelacionar()
        },
        async buscarUsuariosARelacionar(buscador){
            const app = await this.AuthStore.App
            if(!app){
                this.$router.push({name: 'Login'})
                return
            }
            
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
                    const app = await this.AuthStore.App
                    if(!app){
                        this.$router.push({name: 'Login'})
                        return
                    }
                    
                    const categoriaId = this.$refs.seleccionarCategoria.value
                    const categoria = this.categorias.find(categoriaBuscar => categoriaBuscar.id == categoriaId)
                    const usuario_expediente = await app.dao.usuario_expediente.create({usuario_id: usuarioSeleccionado.id, expediente_id: this.expediente.id, rol_id: categoriaId})

                    usuarioSeleccionado.rol = categoria.rol
                    usuarioSeleccionado.usuario_expediente_ID = usuario_expediente.id

                    this.usuariosRelacionados.push(usuarioSeleccionado)

                    return
                }
            })

            this.usuariosSeleccionados = []
            this.usuariosBuscados = []
        },
        toggleContenidoPrincipal(contenido){
            this.contenidoPrincipal = contenido
        },
        async modificarAnotacion(anotacion){
            const app = await this.AuthStore.App
            if(!app){
                this.$router.push({name: 'Login'})
                return
            }

            //Convertimos las fechas al formato de mysql
            anotacion.create_time = utils.formatearFechaAMysql(anotacion.create_time)
            anotacion.update_time = utils.formatearFechaAMysql()

            //Guardamos el id de la anotacion y se lo quitamos al objeto porque no se puede modificar el id
            const anotacion_id = anotacion.id
            delete anotacion.id
            
            app.dao.anotaciones.update({id: anotacion_id}, anotacion)

            //Volvemos a guardar el id para que no se pierda
            anotacion.id = anotacion_id

            this.anotaciones[this.anotaciones.findIndex(anotacionAModificar => anotacionAModificar.id == anotacion.id)] = anotacion
        },
        toggleMostrarNuevaAnotacion(){
            this.mostrarNuevaAnotacion = !this.mostrarNuevaAnotacion
        },
        toggleMostrarDesrelacionar(usuarioId){
            this.usuarioADesrelacionar = usuarioId
            this.mostrarDesrelacionarExpediente = !this.mostrarDesrelacionarExpediente 
        },
        async añadirNuevaAnotacion(titulo, anotacion){
            const app = await this.AuthStore.App
            if(!app){
                this.$router.push({name: 'Login'})
                return
            }

            const nuevaAnotacion = await app.dao.anotaciones.create({
                titulo: titulo,
                anotacion: anotacion,
                usuario_id: this.AuthStore.getUser.id,
                expediente_id: this.expediente.id
            })

            //El objeto devuelto por la BD no tiene los parámetros create_time y update por lo que se los añadimos
            nuevaAnotacion.create_time = nuevaAnotacion.creation_time
            nuevaAnotacion.update_time = nuevaAnotacion.creation_time

            this.anotaciones.unshift(nuevaAnotacion)

            this.toggleMostrarNuevaAnotacion()
        },
        async eliminarAnotacion(idAnotacion){
            const app = await this.AuthStore.App
            if(!app){
                this.$router.push({name: 'Login'})
                return
            }

            app.dao.anotaciones.delete({id: idAnotacion})

            this.anotaciones = this.anotaciones.filter(anotacion => anotacion.id != idAnotacion)
        },
        toggleMostrarModificarExpediente(){
            this.mostrarModificarExpediente = !this.mostrarModificarExpediente
        },
        async modificarExpediente(expediente_modificado){
            const app = await this.AuthStore.App
            if(!app){
                this.$router.push({name: 'Login'})
                return
            }

            delete expediente_modificado.id
            expediente_modificado.create_time = utils.formatearFechaAMysql(expediente_modificado.create_time)
            expediente_modificado.update_time = utils.formatearFechaAMysql()

            this.expediente = await app.dao.expediente.update({id: this.expediente.id}, expediente_modificado)

            this.toggleMostrarModificarExpediente()
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
        },
        buscarAnotacion(new_input, _){
            if(new_input.length == 0){
                this.anotaciones = this.cargarAnotaciones()
                return
            }

            if(new_input.length < 3)
                return

            new_input = new_input.toLowerCase()

            this.anotaciones = this.anotaciones.filter(anotacion => anotacion.titulo.toLowerCase().includes(new_input))
        },
        buscarCuestionario(new_input){
            if(new_input.length == 0){
                this.cuestionarios = this.cargarCuestionarios()
                return
            }

            if(new_input.length < 3)
                return

            new_input = new_input.toLowerCase()

            this.cuestionarios = this.cuestionarios.filter(cuestionario => cuestionario.nombre.toLowerCase().includes(new_input))
        }
    },
    computed: {
        ...mapStores(useAuthStore),
        hayUsuariosSeleccionados(){
            return this.usuariosSeleccionados.length !== 0
        },
        formatearFechaCreacionExpediente(){
            return utils.formatearFecha(this.expediente.create_time)
        },
        obtenerEdadNiño(){
            const fechaNacimiento = moment(this.expediente.fechanacimiento_niño)
            const ahora = moment(Date.now())

            const años = ahora.diff(fechaNacimiento, 'years')
            if(isNaN(años)){
                return 'Edad no especificada'
            }

            let cadenaDevolver = años == 1 ? años + " año - " : años + " años - "
            return cadenaDevolver + 'Nacido el ' +  utils.formatearFecha(this.expediente.fechanacimiento_niño)
        },
        contenidoPrincipalAnotaciones(){
            return this.contenidoPrincipal == 'anotaciones'
        },
        contenidoPrincipalCuestionarios(){
            return this.contenidoPrincipal == 'cuestionarios'
        },
        contenidoPrincipalCuestionariosRealizados(){
            return this.contenidoPrincipal == 'cuestionariosrealizados'
        },
        contenidoPrincipalEstadisticasExpediente(){
            return this.contenidoPrincipal == 'estadisticasexpediente'
        },
        loggedIn(){
            return this.AuthStore.userIsLoggedIn
        },
        async userHasAccess(){
            const app = await this.AuthStore.App
            if(!app){
                this.$router.push({name: 'Login'})
                return
            }
            
            const usuario_expediente = await app.dao.usuario_expediente.read({}, {filter: {expediente_id: this.id, usuario_id: this.AuthStore.getUser.id}})
            
            return this.loggedIn && usuario_expediente.length !== 0
        },
        userIsPsicologo(){
            return utils.userIsPsicologo(this.AuthStore.getUser.rol_id)
        },
        usuarioSePuedeDesrelacionar(){
            return idUsuario => idUsuario != this.AuthStore.getUser.id
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

    .main-section-height{
        height: 56rem;
    }

    .grid-container{
        grid-template-columns: repeat(auto-fill, minmax(220px, 1fr));
    }
</style>