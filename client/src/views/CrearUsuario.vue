<template>
    <div class="w-1/3 mx-auto border-gray-800 border-2 rounded-lg shadow-2xl mt-2">
        <p class="text-center font-bold text-gray-800">Nuevo usuario</p>
        <form class="flex flex-col mt-4 mx-4" >
            <label for="email" class="text-sm text-red-500 italic">* Campo obligatorio</label>
            <input class="border-2 border-gray-800 focus:border-gray-900 w-full rounded-md" id="email" placeholder=" Email..." autocomplete="email" v-model="this.email"/>

            <label for="password" class="text-sm text-red-500 italic mt-2">* Campo obligatorio</label>
            <div class="flex">
                <input class="border-2 border-gray-800 focus:border-gray-900 w-1/2 rounded-md" id="password" placeholder=" Contraseña" type="password" autocomplete="current-password" v-model="this.password"/>
                <app-button :name="'Generar contraseña'" class="w-1/2 text-sm ml-2" @click="generarContraseña"/>
            </div>

            <div class="flex mt-3">
                <input class="border-2 border-gray-800 focus:border-gray-900 rounded-md w-1/3" placeholder=" Nombre" autocomplete="name" v-model="this.nombre"/>
                <input class="border-2 border-gray-800 focus:border-gray-900 rounded-md w-2/3 ml-2" placeholder=" Apellidos" autocomplete="name" v-model="this.apellidos"/>
            </div>

            <div class="flex mt-3">
                <input class="border-2 border-gray-800 focus:border-gray-900 rounded-md w-1/2" placeholder=" Teléfono" autocomplete="name" v-model="this.telefono"/>
                <input class="border-2 border-gray-800 focus:border-gray-900 rounded-md w-1/2 ml-2" placeholder=" DNI/NIE" autocomplete="name" v-model="this.dni"/>
            </div>
            <div class="flex mt-2">
                <div class="flex flex-col w-1/2">
                    <label class="text-gray-500">Género</label>
                    <select class="border-2 border-gray-800 rounded-md" v-model="genero">
                        <option v-for="genero in generos" :key="genero" :value="genero">{{genero}}</option>
                    </select>
                </div>
                <div class="flex flex-col w-1/2 ml-2">
                    <label class="text-gray-500">Estado civil</label>
                    <select class="border-2 border-gray-800 rounded-md" v-model="estadoCivil">
                        <option v-for="estadoCivil in estadosCiviles" :key="estadoCivil" :value="estadoCivil">{{estadoCivil}}</option>
                    </select>
                </div>
            </div>
            <div class="w-full flex flex-col items-center justify-center mt-2">
                <label class="text-gray-500">Fecha de nacimiento</label>
                <input type="date" class="border-2 border-gray-800 w-1/2 rounded-md mx-auto" v-model="this.fechaNac"/>
            </div>
            <div class="w-full flex flex-col items-center justify-center mt-2">
                <label class="text-gray-500">Categoría</label>
                <select class="border-2 border-gray-800 rounded-md w-1/2 mx-auto" ref="seleccionarCategoria">
                    <option v-for="categoria in categorias" :key="categoria.id" :value="categoria.id">{{categoria.rol}}</option>
                </select>
            </div>

            <app-button :name="'Crear usuario'" class="w-1/3 mx-auto mt-3 mb-2" @click="crearUsuario"/>
            <p class="text-green-700 text-center">{{usuarioCreado}}</p>
            <ul class="text-center">
                <li v-for="error in erroresValidacion" :key="error" class="text-red-500 italic text-sm">* {{error}}</li>
            </ul>
        </form>
    </div>
</template>

<script>
import {useAuthStore} from '../stores/Auth.js'
import {mapStores} from 'pinia'

import utils from '../services/utils'
import policies from '../services/policies'

import AppButton from '../components/AppButton.vue'

import generos from '../staticData/generos'
import estadosCiviles from '../staticData/estadosCiviles'

export default {
    name: 'CrearUsuario',
    components: {
        AppButton
    },
    data(){
        return {
            email: '',
            password: '',
            nombre: '',
            apellidos: '',
            telefono: '',
            dni: '',
            fechaNac: '',
            genero: '',
            estadoCivil: '',
            generos,
            estadosCiviles,
            categorias: [],
            erroresValidacion: [],
            usuarioCreado: ''
        }
    },
    created(){
        if(!this.loggedIn)
            return this.$router.push({name: 'Login'})

        if(!this.userIsAdmin && !this.userIsPsicologo)
            return this.$router.push({name: 'NoAutorizado'})

        this.cargarCategorias()
    },
    computed: {
        ...mapStores(useAuthStore),
        loggedIn(){
            return this.AuthStore.userIsLoggedIn
        },
        userIsAdmin(){
            return utils.userIsAdmin(this.AuthStore.getUser.id)
        },
        userIsPsicologo(){
            return utils.userIsPsicologo(this.AuthStore.getUser.id)
        }
    },
    methods: {
        async cargarCategorias(){
            const app = await this.AuthStore.App
            if(!app)
                return this.$router.push({name: 'Login'})

            this.categorias = await app.dao.rol.read()

            if(this.userIsPsicologo){
                this.categorias = this.categorias.filter(categoria => categoria.id != 3)
            }
        },
        comprobarDatosCorrectos(){
            if(!policies.emailEsCorrecto(this.email))
                this.erroresValidacion.push('Email incorrecto')

            if(!policies.contraseñaEsCorrecta(this.password))
                this.erroresValidacion.push('La contraseña tiene que tener 8 carácteres, una letra mayúscula y minúscula y un número.')

            if(this.dni.length !== 0 && !policies.dniNieEsCorrecto(this.dni))
                this.erroresValidacion.push('DNI o NIE incorrecto')

            if(this.telefono.length !== 0 && !policies.telefonoEsCorrecto(this.telefono))
                this.erroresValidacion.push('Teléfono incorrecto')
        },
        vaciarCampos(){
            this.email = ''
            this.password = ''
            this.nombre = ''
            this.apellidos = ''
            this.telefono = ''
            this.dni = ''
            this.fechaNac = ''
        },
        async crearUsuario(e){
            e.preventDefault()

            this.erroresValidacion = []
            this.usuarioCreado = ''

            this.comprobarDatosCorrectos()

            if(this.erroresValidacion.length !== 0)
                return

            const app = await this.AuthStore.App

            const usuarioExiste = await app.dao.usuario.read({}, {filter: {email: this.email}})
            if(usuarioExiste.length !== 0){
                this.erroresValidacion.push('El email ' + this.email + ' ya existe en el sistema')
                return
            }
            
            try{
                const nuevoUsuario = await app.dao.usuario.create({
                    email: this.email,
                    password: this.password,
                    nombre: this.nombre,
                    apellidos: this.apellidos,
                    dni: this.dni,
                    telefono: this.telefono,
                    fecha_nacimiento: this.fechaNac,
                    genero: this.genero,
                    estado_civil: this.estadoCivil,
                    estado_id: 1,
                    rol_id: this.$refs.seleccionarCategoria.value
                })

                this.usuarioCreado = 'Usuario creado con éxito.'
                this.vaciarCampos()
            }catch(e){
                this.erroresValidacion.push('Se ha producido un error al crear el usuario. Inténtalo de nuevo.')
            }
        },
        generarContraseña(e){
            e.preventDefault()

            this.password = utils.generarContrasenyaAleatoria()
        }
    }
}
</script>