<template>
    <div class="block text-center mt-2 space-y-2 mb-20">
        <p class="text-lg font-bold">{{this.creandoExpediente ? "Nuevo expediente" : "Añadir formularios al expediente"}}</p>
        <div class="flex flex-col space-y-2">
            <AppButton class="mx-auto text-green-800 cursor-pointer" @click="crearExpediente" :name="'Crear expediente'"/>
        </div>
        <!-- Formulario con los datos del niño -->
        <div v-if="this.mostrarFormularioNiño">
            <div class="w-2/5 border-4 border-gray-800 rounded-md mx-auto flex space-y-2 flex-col pl-4 pr-4 pb-4 pt-2 shadow-md">
                <p class="font-bold text-md mb-2">Nombre del expediente</p>
                <input v-model="nombreExpediente" name="nombreExpediente" class="w-full border-2 border-black rounded-md p-1 mx-auto" placeholder="Nombre expediente..."/>
                
                <!-- Nombre y apellidos-->
                <p class="font-bold text-md mb-2">Datos del niño/a</p>
                <div class="flex space-x-2">
                    <input v-model="datosNiño.nombre" name="nombre" class="w-1/3 border-2 border-black rounded-md p-1" placeholder="Nombre..."/>
                    <input v-model="datosNiño.apellidos" name="apellidos" class="w-2/3 border-2 border-black rounded-md p-1" placeholder="Apellidos..."/>
                </div>
                <!-- Dni y Fecha nacimiento-->
                <div class="flex space-x-2">
                    <input v-model="datosNiño.dni" name="dni" class="w-1/4 border-2 border-black rounded-md p-1" placeholder="Dni..."/>
                    <input v-model="datosNiño.fechaNac" type="date" name="fechaNac" class="w-3/4 border-2 border-black rounded-md p-1" placeholder="Fecha nacimiento..."/>
                </div>
                <div>
                    <p v-for="error in erroresValidacion" :key="error" class="text-left font-semibold text-sm text-red-600">{{error}}</p>
                </div>
            </div>
        </div>
        <!-- Tarjetas que contienen los usuarios y los cuestionarios a asignar al expediente-->
        <div class="flex justify-center flex-wrap space-x-4">
            <TarjetaUsuariosCuestionarios 
                :titulo="categoria.nombre" 
                :usuarios="categoria.usuarios"
                :cuestionarios="categoria.cuestionarios" 
                @add-users="addUsersToCategory" 
                v-for="categoria in categorias" 
                :key="categoria.nombre"
                @delete-user="deleteUser"
                @new-created-user="newCreatedUser"
                @delete-cuestionario="deleteCuestionario"
                @anyadir-cuestionarios="anyadirCuesiontarios"
                @modify-user="modifyUser"
                />
        </div>
    </div>
</template>

<script>
import crypto from 'crypto'
import initializeAppObject from '../services/daoProvider'

import {PlusCircleIcon} from '@heroicons/vue/outline'
import TarjetaUsuariosCuestionarios from '../components/TarjetaUsuariosCuestionarios.vue'
import AppButton from '../components/AppButton.vue'
import PopUpAnyadirUsuario from '../components/PopUpAnyadirUsuario.vue'
import policies from '../services/policies'

import {mapStores} from 'pinia'
import {useAuthStore} from '../stores/Auth.js'
import utils from '../services/utils'

export default {
    name: 'AsignarCuestionariosExpediente',
    components: {
        PlusCircleIcon,
        TarjetaUsuariosCuestionarios,
        AppButton,
        PopUpAnyadirUsuario,
        crypto
    },
    props: {
        creandoExpediente: Boolean
    },
    data(){
        return {
            mostrarFormularioNiño: true,
            datosNiño: {
                nombre: '',
                apellidos: "",
                dni: "",
                fechaNac: ""
            },
            nombreExpediente: '',
            /**
             * Categorías es un array de objetos con el siguiente prototipo:
             * {
             *  id: 1,
             *  nombre: '',
             *  usuarios: [],
             *  cuestionarios: []
             * }
             */
            categorias: [],
            erroresValidacion: []
        }
    },
    computed: {
        ...mapStores(useAuthStore),
        loggedIn(){
            return this.AuthStore.userIsLoggedIn
        },
        userIsPsicologo(){
            return utils.userIsPsicologo(this.AuthStore.getUser.id)
        }
    },
    /**
     * Se encarga de cargar los cuestionarios predefinicidos en cada categoría de la base de datos
     */
    async created(){
        if(!this.loggedIn)
            return this.$router.push({name: 'Login'})
        
        if(!this.userIsPsicologo)
            return this.$router.push({name: 'NoAutorizado'})

        var app = await this.AuthStore.App
        if(!app)
            return this.$router.push({name: 'Login'})
            

        //Cargamos las categorías de la base de datos
        let categoriasDB = await app.dao.rol.read()
        
        //filtramos la categoría 'admin' del expediente
        categoriasDB = categoriasDB.filter(categoria => !categoria.rol.includes('admin'))
        
        //inicializamos la variable 'categorias' con los datos de la BD
        for(const categoriaDB of categoriasDB){
            //Extraemos de la tabla N:M los cuestionarios por defecto de una categoría
            let cuestionariosPorDefectoEnCategoria = await app.dao.cuestionarios_defecto_rol.read({}, {filter: {rol_id: categoriaDB.id}})

            //Buscamos en la base de datos la información de los cuestionarios por defecto
            let cuestionariosDB = []
            for (const idCuestionario of cuestionariosPorDefectoEnCategoria) {
                const cuestionario_db = await app.dao.cuestionarios.read(idCuestionario.cuestionario_id) 
                cuestionariosDB.push(cuestionario_db)
            }

            this.categorias.push({id: categoriaDB.id,nombre: categoriaDB.rol, usuarios: [], cuestionarios: cuestionariosDB})
        }
    },
    methods: {
        toggleFormularioNiño(){
            this.mostrarFormularioNiño = !this.mostrarFormularioNiño
        },
        /**
         * Cada vez que se elijan nuevos usuarios en las tarjetas 
         * 'TarjetaUsuariosCuestionarios', desde el hijo se llamará
         * a esta función, que guardará los usuarios de cada categoría
         * 
         * @param {*} nombre 
         * @param {*} users 
         */
        addUsersToCategory(nombre, users){
            var indexOfCategory = this.indexCategory(nombre)
            users.forEach(user => {
                if(this.categorias[indexOfCategory].usuarios.find(userArray => userArray.id == user.id) == undefined){
                    this.categorias[indexOfCategory].usuarios.push(user)
                }
            })
        },
        deleteUser(id, nombre){
            var indexOfCategory = this.indexCategory(nombre)
            this.categorias[indexOfCategory].usuarios = this.categorias[indexOfCategory].usuarios.filter(usuario => usuario.id != id) 
        },
        indexCategory(nombre) {
            return this.categorias.findIndex(categoria => categoria.nombre==nombre)
        },
        indexOfUser(categoryIndex, email){
            return this.categorias[categoryIndex].usuarios.findIndex(usuario => usuario.email == email)
        },
        /**
         * Esta función es parecida a 'addUsersToCategory', con la diferencia de que
         * el nuevo usuario que le llega no está en el sistema, lo ha 'creado' el usuario, por
         * lo que será un nuevo usuario que aún no estará registrado en el sistema (se creará cuando se cree
         * el expediente)
         * @param {string} nombreCategoria 
         * @param {object} nuevoUsuario 
         */
        newCreatedUser(nombreCategoria, nuevoUsuario){
            var indexOfCategory = this.indexCategory(nombreCategoria)

            //Buscamos si el usuario ya está en la categoría
            if(this.categorias[indexOfCategory].usuarios.findIndex(usuario => usuario.email == nuevoUsuario.email) != -1){
                return
            }

            this.categorias[indexOfCategory].usuarios.push(nuevoUsuario)
        },
        deleteCuestionario(nombreCategoria, idCuestionario){
            var indexOfCategory = this.indexCategory(nombreCategoria)

            this.categorias[indexOfCategory].cuestionarios = this.categorias[indexOfCategory].cuestionarios.filter(cuestionario => cuestionario.id != idCuestionario) 
        },
        anyadirCuesiontarios(nombreCategoria, cuestionarios){
            var indexOfCategory = this.indexCategory(nombreCategoria)
            
            cuestionarios.forEach(cuestionario => {
                //El cuestionario ya había sido añadido
                if (this.categorias[indexOfCategory].cuestionarios.findIndex(cuestionarioCategoria => cuestionarioCategoria.id == cuestionario.id) != -1)
                    return
                
                this.categorias[indexOfCategory].cuestionarios.push(cuestionario)
            })
        },
        modifyUser(nombreCategoria, userModified, cleanEmail){
            var indexOfCategory = this.indexCategory(nombreCategoria)
            var userIndex = this.indexOfUser(indexOfCategory, cleanEmail)

            this.categorias[indexOfCategory].usuarios[userIndex] = userModified
        },
        datosExpedienteCorrectos(){
            this.erroresValidacion = []
            let todoOk = true

            if(this.nombreExpediente == ''){
                todoOk = false
                this.erroresValidacion.push('* El nombre del expediente no puede estar vacío')
            }

            if(this.datosNiño.nombre == ''){
                todoOk = false
                this.erroresValidacion.push('* El nombre del niño no puede estar vacío')
            }

            if(this.datosNiño.dni != '' && !policies.dniNieEsCorrecto(this.datosNiño.dni)){
                todoOk = false
                this.erroresValidacion.push('* DNI o NIE incorrecto')
            }

            return todoOk
        },
        async crearExpediente(){
            if(!this.datosExpedienteCorrectos())
                return
            

            var app = await this.AuthStore.App
            if(!app)
                return this.$router.push({name: 'Login'})

            //Creamos el expediente
            var expedienteACrear = 
            {
                nombre_niño: this.datosNiño.nombre,
                apellidos_niño: this.datosNiño.apellidos,
                nombre: this.nombreExpediente,
                dni_niño: this.datosNiño.dni,
                fechanacimiento_niño: this.datosNiño.fechaNac,
            }

            if(expedienteACrear.fechanacimiento_niño == '')
                delete expedienteACrear.fechanacimiento_niño

            var expediente = await app.dao.expediente.create(expedienteACrear)
            
            //Se relaciona al psicólogo que loggeado con el expediente
            this.relacionarUsuarioExpediente(app, this.AuthStore.getUser.id, expediente.id, 1)

            //Usuarios cuya creación ha sido errónea
            var usuariosNoCreados = []

            //Para cada categoría creamos y relacionamos todos los usuarios
            for (const categoria of this.categorias) {
                for (const usuario of categoria.usuarios) {
                    //El usuario se ha creado en el momento de crear el expediente
                    if(usuario.nuevoUsuario){
                        try{
                            const nuevoUsuario = await app.dao.usuario.create({
                                email: usuario.email,
                                nombre: usuario.nombre,
                                apellidos: usuario.apellidos,
                                dni: usuario.dni,
                                telefono: usuario.telefono,
                                fecha_nacimiento: usuario.fechaNac,
                                password: crypto.randomBytes(8).toString('hex'), //generamos una contraseña aleatoria de 16 caracteres
                                estado_id: 1,
                                rol_id: categoria.id
                            })

                            this.relacionarUsuarioExpediente(app, nuevoUsuario.id, expediente.id, categoria.id)
                        }catch(_){
                            usuariosNoCreados.push(usuario)
                        }
                    }else {
                        //El usuario ya estaba creado, solo lo relaciona
                        this.relacionarUsuarioExpediente(app, usuario.id, expediente.id, categoria.id)
                    }

                    
                }
            }

            //No ha habido ningún error, enviamos al usuario al expediente
            if(usuariosNoCreados.length == 0){
                this.$router.push({name: 'Expediente', params: {id: expediente.id}})
                return
            }
            
            //han habido usuarios que no se han creado, se los mostramos al usuario
            let errores = []
            for(const usuarioError of usuariosNoCreados){
                console.log(usuarioError)
                errores.push('El usuario con email ' + usuarioError.email + ' ya existía en el sistema. No ha sido creado.')
            }
            this.$router.push({name: 'ErroresExpediente', params: {errores, expedienteId: expediente.id}})
        },
        /**
         * Relaciona un usuario con un expediente. Guarda también la información de la categoría a la que pertenece el usuario
         * @param {} app 
         * @param {*} usuarioId 
         * @param {*} expedienteId 
         */
        relacionarUsuarioExpediente(app, usuarioId, expedienteId, categoriaId){
            app.dao.usuario_expediente.create({
                usuario_id: usuarioId,
                expediente_id: expedienteId,
                rol_id: categoriaId
            })
        },
    }
}
</script>  
