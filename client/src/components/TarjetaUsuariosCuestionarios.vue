<template>
  
  <div class="w-2/6 border-2 border-black text-center rounded-lg flex flex-col space-y-3">
    <!-- PopUp que se muestra cuando se añade un usuario-->
    <PopUpAnyadirUsuario v-if="mostrarNuevoUsuario" 
      @close-new-user="this.mostrarNuevoUsuario = !this.mostrarNuevoUsuario" 
      @new-user="handleCreateUser"
      :alreadyCreated="false"
    />
    <!-- PopUp que se muestra cuando se modifica un usuario creado-->
    <PopUpAnyadirUsuario v-if="mostrarModificarUsuario" 
      @close-modify-user="mostrarModificarUsuario = !mostrarModificarUsuario" 
      @modify-user="handleModifyUser"
      :alreadyCreated="true"
      :createdUser="this.userToModify"
    />
    <PopUpBuscarCuestionarios v-if="mostrarBuscarCuestionario"
      @close-buscar-cuestionario="this.mostrarBuscarCuestionario = !this.mostrarBuscarCuestionario"
      @anyadir-cuestionarios="handleAnyadirCuestionario"
    />
    <p class="font-bold text-lg">{{ titulo }}</p>
    <!-- Buscador de usuarios-->
    <div>
        <label for="users">Añadir usuarios a la categoría</label>
        <InputBuscar :placeHolder="'Buscar usuarios...'" v-model="userSearchInput"/>
        <!-- Mostramos los usuarios buscados -->
        <div class="w-2/3 mx-auto mt-2 max-h-52 overflow-scroll" v-if="showSearchedUsers()">
          <BusquedaUsuarioTarjeta class="w-full" :nombre="user.nombre" v-for="user in usersSearched" :key="user.id" v-on:click="handleSelectUser(user.id)"/>
        </div>

        <AppButton :name="'Añadir usuario'" class="mt-5" @click="$emit('addUsers',this.titulo,this.selectedUsers); clearSearchData()" v-if="showSearchedUsers()"/>
    </div>

    <!-- Mostramos los usuarios añadidos a la categoría-->
    <div class="flex flex-wrap mx-4 justify-center">
        <TarjetaUsuario 
          :nombre="usuario.nombre" 
          :email="usuario.email" 
          :id="usuario.id"
          :nuevoUsuario="usuario.nuevoUsuario"
          class="mx-2 my-2" 
          v-for="usuario in usuarios" 
          :key="usuario.email" 
          @delete-user="(id) => $emit('deleteUser', id, titulo)"
          @modify-user="(id) => addUserToModify(id)"
          />
        <!-- Botón de añadir nuevo usuario-->
        <div class="flex flex-col items-center my-auto cursor-pointer" @click="this.mostrarNuevoUsuario = !this.mostrarNuevoUsuario">
            <PlusCircleIcon class="w-14 h-14"/>
            <p class="font-bold">Crear nuevo usuario</p>
        </div>
    </div>
    <div class="border border-black w-3/4 mx-auto rounded-md mb-4"></div>
    <p class="font-bold text-lg m-4">Cuestionarios</p>
    <!-- Mostramos los cuestionarios de la categoría -->
    <div class="flex flex-wrap justify-center">
        <TarjetaCuestionario 
          v-for="cuestionario in cuestionarios"
          :key="cuestionario.id"
          :nombre="cuestionario.nombre"
          :id="cuestionario.id"
          :showRemoveButton="true"
          @delete-cuestionario="(id) => $emit('deleteCuestionario', titulo, id)"
          class="mx-1 my-1"/>
        <!-- Botón de añadir cuestionario-->
        <div class="flex flex-col items-center my-auto w-1/4 mx-1 cursor-pointer" @click="this.mostrarBuscarCuestionario = !this.mostrarBuscarCuestionario">
            <PlusCircleIcon class="w-14 h-14"/>
            <p class="font-bold">Añadir</p>
            <p class="font-bold">cuestionario</p>
        </div>
    </div>


  </div>
</template>

<script>
import initializeAppObject from '../services/daoProvider'

import { SearchIcon, PlusCircleIcon } from "@heroicons/vue/outline";
import TarjetaUsuario from '../components/TarjetaUsuario.vue'
import TarjetaCuestionario from "./TarjetaCuestionario.vue";
import AppButton from "./AppButton.vue";
import BusquedaUsuarioTarjeta from "./BusquedaUsuarioTarjeta.vue";
import PopUpAnyadirUsuario from './PopUpAnyadirUsuario.vue'
import PopUpBuscarCuestionarios from './PopUpBuscarCuestionarios.vue';
import InputBuscar from './InputBuscar.vue';


export default {
  name: "TarjetaUsuariosCuestionarios",
  data() {
    return {
      userSearchInput: '',
      usersSearched: [],
      selectedUsers: [],
      mostrarNuevoUsuario: false,
      mostrarBuscarCuestionario: false,
      mostrarModificarUsuario: false,
      userToModify: {}
    }
  },
  props: {
    titulo: "",
    usuarios: {
      type: Array
    },
    cuestionarios: {
      type: Array
    }
  },
  components: {
    SearchIcon,
    TarjetaUsuario,
    PlusCircleIcon,
    TarjetaCuestionario,
    AppButton,
    BusquedaUsuarioTarjeta,
    PopUpAnyadirUsuario,
    PopUpBuscarCuestionarios,
    InputBuscar
},
  methods: {
    /**
     * Cada vez que el usuario escriba algo en el input esta función buscará
     * usuarios y los añadirá a usersSearched
     * @param {string} input 
     */
    async handleUserSearch(input){
      if(input.length < 3) return
      //.read({}, {filter:  {nombre: "Diego"}})
      const app = await initializeAppObject()
      app.dao.usuario.read({}).then(usuarios => {
        this.usersSearched = usuarios
        console.log(usuarios)        
      })
    },
    /**
     * Devuelve tru si hay usuarios en el array usersSearched
     */
    showSearchedUsers(){
      return this.usersSearched.length != 0
    },
    /**
     * Cada vez que el usuario clica en un usuario buscado, este se añade en el array
     * selectedUsers. Si vuelve a clicar, se elimina del array
     * @param {int} id 
     */
    handleSelectUser(id){
      //El usuario ya había sido seleccionado
      if(this.selectedUsers.find(user => user.id == id) != undefined){
        //eliminamos al usuario del array (porque le ha dado click y lo ha deseleccionado)
        this.selectedUsers = this.selectedUsers.filter(user => user.id != id)
        return
      }

      //El usuario no había sido seleccionado
      this.selectedUsers.push(this.usersSearched.find(user => user.id == id))
    },
    /**
     * Se encarga de dejar por defecto todas las variables que almacenan
     * la información de los usuarios buscados
     */
    clearSearchData(){
      this.userSearchInput = ""
      this.usersSearched = []
      this.selectedUsers = []
    },
    handleCreateUser(newUser){
      this.mostrarNuevoUsuario = !this.mostrarNuevoUsuario

      //Buscamos si el usuario que se ha creado ya está en el array de usuarios seleccionados
      if(this.usuarios.findIndex(user => user.email == newUser.email) != -1){
        return
      }

      newUser.nuevoUsuario = true

      this.$emit('newCreatedUser',this.titulo ,newUser)
    },
    handleAnyadirCuestionario(cuestionarios){
      this.$emit('anyadirCuestionarios', this.titulo, cuestionarios)
      this.mostrarBuscarCuestionario = !this.mostrarBuscarCuestionario
    },
    handleModifyUser(modifiedUser, cleanEmail){      
      this.mostrarModificarUsuario = !this.mostrarModificarUsuario

      modifiedUser.nuevoUsuario = true

      this.$emit('modifyUser', this.titulo, modifiedUser, cleanEmail)
    },
    addUserToModify(id){
      this.userToModify = this.usuarios.find(usuario => usuario.id == id)
      this.mostrarModificarUsuario = !this.mostrarModificarUsuario
    }

  },
  watch: {
    /**
     * Cada vez que cambia usersSearched se activa esta función, que llama
     * a handleUserSearch con el nuevo valor
     * @param {*} newInput 
     * @param {*} _ 
     */
    userSearchInput(newInput, _){
      if (newInput == ""){
        this.usersSearched = []
        return
      }
      this.handleUserSearch(newInput)
    }
  }
};
</script>
