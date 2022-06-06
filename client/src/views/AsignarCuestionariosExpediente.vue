<template>
    <div class="block text-center mt-2 space-y-2">
        <p class="text-lg font-bold">{{this.creandoExpediente ? "Nuevo expediente" : "Añadir formularios al expediente"}}</p>
        <PlusCircleIcon class="h-14 w-14 mx-auto text-green-800"/>
        <AppButton v-on:click="toggleFormularioNiño" :name="mostrarFormularioNiño ? 'Esconder datos' : 'Mostrar datos'"/>
        <!-- Formulario con los datos del niño -->
        <div v-if="this.mostrarFormularioNiño">
            <div class="w-2/5 border-4 border-black rounded-md mx-auto flex space-y-2 flex-col pl-4 pr-4 pb-4 pt-2 shadow-lg">
                <!-- Nombre y apellidos-->
                <p class="font-bold text-md mb-2">Datos del niño/a</p>
                <div class="flex space-x-2">
                    <input v-model="datosNiño.nombre" name="nombre" class="w-1/3 border-2 border-black rounded-md p-1" placeholder="Nombre..."/>
                    <input v-model="datosNiño.apellidos" name="apellidos" class="w-2/3 border-2 border-black rounded-md p-1" placeholder="Apellidos..."/>
                </div>
                <!-- Dni y Fecha nacimiento-->
                <div class="flex space-x-2">
                    <input v-model="datosNiño.dni" name="dni" class="w-1/4 border-2 border-black rounded-md p-1" placeholder="Dni..."/>
                    <input v-model="datosNiño.fechaNac" name="fechaNac" class="w-3/4 border-2 border-black rounded-md p-1" placeholder="Fecha nacimiento..."/>
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
                @new-created-user="newCreatedUser"/>
        </div>
    </div>
</template>

<script>
import initializeAppObject from '../services/daoProvider'

import {PlusCircleIcon} from '@heroicons/vue/outline'
import TarjetaUsuariosCuestionarios from '../components/TarjetaUsuariosCuestionarios.vue'
import AppButton from '../components/AppButton.vue'
import PopUpAnyadirUsuario from '../components/PopUpAnyadirUsuario.vue'

export default {
    name: 'AsignarCuestionariosExpediente',
    components: {
        PlusCircleIcon,
        TarjetaUsuariosCuestionarios,
        AppButton,
        PopUpAnyadirUsuario
    },
    props: {
        creandoExpediente: Boolean
    },
    data(){
        return {
            mostrarFormularioNiño: true,
            datosNiño: {
                nombre: "",
                apellidos: "",
                dni: "",
                fechaNac: ""
            },
            /**
             * Categorías es un array de objetos con el siguiente prototipo:
             * {
             *  nombre: '',
             *  usuarios: [],
             *  cuestionarios: []
             * }
             */
            categorias: [{nombre: 'Familiares', usuarios: [], cuestionarios: [{id: 1}, {id: 2}, {id: 3}]}, {nombre: 'Colegio', usuarios: [], cuestionarios: [{id: 4}]}],
        }
    },
    /**
     * Se encarga de cargar los cuestionarios predefinicidos en cada categoría de la base de datos
     */
    async created(){
        var app = await initializeAppObject()
        this.categorias.forEach((categoria, indexCategoria) => {
            categoria.cuestionarios.forEach(async (cuestionario, indexCuestionario) => {
                const cuestionario_db = await app.dao.cuestionarios.read(cuestionario.id)
                this.categorias[indexCategoria].cuestionarios[indexCuestionario].nombre = cuestionario_db.nombre
            })
        })
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
        }
    }
}
</script>

  
