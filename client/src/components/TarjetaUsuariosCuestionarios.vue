<template>
  <div class="w-2/6 border-2 border-black text-center rounded-lg flex flex-col space-y-3">
    <p class="font-bold text-lg">{{ titulo }}</p>
    <!-- Buscador de usuarios-->
    <div>
        <label for="users">Añadir usuarios a la categría</label>
        <div class="flex space-x-2 mx-auto border-2 border-black p-1 rounded-lg w-2/3">
            <SearchIcon class="w-6 h-6" />
            <input
                type="search"
                id="users"
                placeholder="Añadir usuarios..."
                class="w-full focus:outline-none"
            />      
        </div>
        <button class="px-2 py-1 border-2 border-black rounded-md mt-4">Añadir usuarios</button>
    </div>

    <!-- Mostramos los usuarios añadidos a la categoría-->
    <div class="flex flex-wrap mx-4 justify-center">
        <TarjetaUsuario :nombre="'Luis'" :email="'luisvr601@gmail.com'" class="mx-2 my-2"/>
        <TarjetaUsuario :nombre="'Luis'" :email="'luisvr601@gmail.com'" class="mx-2 my-2"/>
        <TarjetaUsuario :nombre="'Luis'" :email="'luisvr601@gmail.com'" class="mx-2 my-2"/>
        <TarjetaUsuario :nombre="'Luis'" :email="'luisvr601@gmail.com'" class="mx-2 my-2"/>
        <TarjetaUsuario :nombre="'Luis'" :email="'luisvr601@gmail.com'" class="mx-2 my-2"/>
        <TarjetaUsuario :nombre="'Luis'" :email="'luisvr601@gmail.com'" class="mx-2 my-2"/>
        <TarjetaUsuario :nombre="'Luis'" :email="'luisvr601@gmail.com'" class="mx-2 my-2"/>
        <TarjetaUsuario :nombre="'Luisdsaddsadasd'" :email="'luisvr601@gmail.com'" class="mx-2 my-2"/>
        <TarjetaUsuario :nombre="'Luisdsaddsadasd'" :email="'luisvr601@gmail.com'" class="mx-2 my-2"/>
        <TarjetaUsuario :nombre="'Luisdsaddsadasd'" :email="'luisvr601@gmail.com'" class="mx-2 my-2"/>
        <!-- Botón de añadir nuevo usuario-->
        <div class="flex flex-col items-center my-auto">
            <PlusCircleIcon class="w-14 h-14"/>
            <p class="font-bold">Crear nuevo usuario</p>
        </div>
    </div>
    <div class="border border-black w-3/4 mx-auto rounded-md mb-4"></div>
    <p class="font-bold text-lg m-4">Cuestionarios</p>
    <!-- Mostramos los cuestionarios de la categoría -->
    <div class="flex flex-wrap justify-center">
        <TarjetaCuestionario :nombre="'Cuestionario 1'" class="mx-1 my-1"/>
        <TarjetaCuestionario :nombre="'Cuestionario 1'" class="mx-1 my-1"/>
        <TarjetaCuestionario :nombre="'Cuestionario 1'" class="mx-1 my-1"/>
        <TarjetaCuestionario :nombre="'Cuestionario 1'" class="mx-1 my-1"/>
        <TarjetaCuestionario :nombre="'Cuestionario 1'" class="mx-1 my-1"/>
        <!-- Botón de añadir cuestionario-->
        <div class="flex flex-col items-center my-auto w-1/4 mx-1">
            <PlusCircleIcon class="w-14 h-14"/>
            <p class="font-bold">Añadir</p>
            <p class="font-bold">cuestionario</p>
        </div>
    </div>


  </div>
</template>

<script>
import { SearchIcon, PlusCircleIcon } from "@heroicons/vue/outline";
import TarjetaUsuario from '../components/TarjetaUsuario.vue'
import TarjetaCuestionario from "./TarjetaCuestionario.vue";


export default {
  name: "TarjetaUsuariosCuestionarios",
  props: {
    titulo: "",
  },
  components: {
    SearchIcon,        
    TarjetaUsuario,
    PlusCircleIcon,
    TarjetaCuestionario
  },
};
</script>
