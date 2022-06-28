<template>
    <div>
        <div class="flex justify-center"><MoonLoader :loading="cargandoDatos" class="mt-4" /></div>
        <div class="flex justify-center mt-10" v-if="existeUsuario">
            <div class="shadow-xl flex flex-col w-2/5 rounded-md border-l-2 border-indigo-500 text-center items-center">
                <h1 class="font-bold mt-2 text-xl">Perfil</h1>
                <UserIcon class="text-gray-800 h-28 mt-2" />
                <h1 class="font-semibold mt-2 text-lg text-gray-800">{{usuario.nombre}} {{usuario.apellidos}}</h1>
                <div class="flex justify-center space-x-2">
                    <h1 class="text-blue-500">{{usuario.email}}</h1>
                    <p class="font-semibold text-gray-800">-</p>
                    <h1 class="text-gray-800">{{rolUsuario.rol}}</h1>
                </div>
                <h1 class="text-gray-700 mt-2 font-semibold">{{usuario.telefono}}</h1>
                <h1 class="text-gray-700 font-semibold">{{obtenerStringNacimiento}}</h1>
                <AppButton class="mt-3 w-1/3 text-center mb-4" :name="'Modificar'"/>
            </div>
        </div>
        <div class="" v-else>
            <h1 class="text-center text-xl font-bold mt-2">No existe el usuario con id {{this.id}}</h1>
        </div>
    </div>
</template>

<script>
import initializeAppObject from '../services/daoProvider'
import MoonLoader from 'vue-spinner/src/MoonLoader.vue'

import {UserIcon} from '@heroicons/vue/outline'
import AppButton from '../components/AppButton.vue'

export default {
    name: 'Perfil',
    components: {
        MoonLoader,
        UserIcon,
        AppButton
    },
    props: {
        id: ''
    },
    data(){
        return {
            usuario: {},
            rolUsuario: {},
            existeUsuario: false,
            cargandoDatos: true
        }
    },
    async created(){
        this.cargandoDatos = true
        await this.cargarUsuario()
        
        if(this.existeUsuario){
            await this.cargarRolUsuario()
        }

        this.cargandoDatos = false
    },
    methods: {
        async cargarUsuario(){
            console.log(this.id)
            if(this.id == '')
                return false

            const app = await initializeAppObject()

            try{
                this.usuario = await app.dao.usuario.read({id: this.id})
                this.existeUsuario = true
            }catch(e){
                this.usuario = {}
                this.existeUsuario = false
            }
        },
        async cargarRolUsuario(){
            const app = await initializeAppObject()
            this.rolUsuario = await app.dao.rol.read({id: this.usuario.rol_id})
        }
    },
    computed: {
        obtenerStringNacimiento(){
            const fechaNac = new Date(this.usuario.fecha_nacimiento)

            return "Nació el " + fechaNac.getUTCDate().toString().padStart(2,'0') + "/" + (fechaNac.getMonth() + 1).toString().padStart(2,'0') + "/" + fechaNac.getFullYear()
        }
    }
}
</script>