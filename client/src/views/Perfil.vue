<template>
    <div>
        <div class="flex justify-center"><MoonLoader :loading="cargandoDatos" class="mt-4" /></div>
        <div class="flex justify-center mt-10" v-if="existeUsuario">
            <div class="shadow-xl w-2/5 rounded-md border-l-2 border-indigo-500 text-center">
                <div class="flex flex-col items-center">
                    <h1 class="font-bold mt-2 text-xl">Perfil</h1>
                    <UserIcon class="text-gray-800 h-28 mt-2" />
                    <div v-if="!modificando">
                        <h1 class="font-semibold mt-2 text-lg text-gray-800">{{usuario.nombre}} {{usuario.apellidos}}</h1>
                        <div class="flex justify-center space-x-2">
                            <h1 class="text-blue-500">{{usuario.email}}</h1>
                            <p class="font-semibold text-gray-800">-</p>
                            <h1 class="text-gray-800">{{rolUsuario.rol}}</h1>
                        </div>
                        <h1 class="text-gray-700 mt-2 font-semibold">{{usuario.telefono}}</h1>
                        <h1 class="text-gray-700 font-semibold">{{obtenerStringNacimiento}}</h1>
                    </div>
                    <div v-else class="w-1/2">
                        <!-- Nombre -->
                        <div class="flex flex-col items-center">
                            <div class="w-2/3 text-left"><label for="nombre" class="text-sm font-bold pl-1">Nombre</label></div>
                            <input class="w-2/3 border-2 border-gray-800 rounded-md font-semibold" name="nombre" placeholder="Nombre..." v-model="usuarioModificado.nombre"/>
                        </div>
                        <!-- Apellidos -->
                        <div class="flex flex-col items-center">
                            <div class="w-2/3 text-left"><label for="apellidos" class="text-sm font-bold pl-1">Apellidos</label></div>
                            <input class="w-2/3 border-2 border-gray-800 rounded-md font-semibold" name="apellidos" placeholder="Apellidos..." v-model="usuarioModificado.apellidos"/>
                        </div>
                        <!-- email -->
                        <div class="flex flex-col items-center">
                            <div class="w-2/3 text-left"><label for="email" class="text-sm font-bold pl-1">Email</label></div>
                            <input class="w-2/3 border-2 border-gray-800 rounded-md font-semibold" name="email" placeholder="Email..." v-model="usuarioModificado.email"/>
                        </div>
                        <!-- telefono -->
                        <div class="flex flex-col items-center">
                            <div class="w-2/3 text-left"><label for="telefono" class="text-sm font-bold pl-1">Teléfono</label></div>
                            <input class="w-2/3 border-2 border-gray-800 rounded-md font-semibold" name="telefono" placeholder="telefono..." v-model="usuarioModificado.telefono"/>
                        </div>
                        <!-- fecha Nacimiento -->
                        <div class="flex flex-col items-center">
                            <div class="w-2/3 text-left"><label for="telefono" class="text-sm font-bold pl-1">Fecha de nacimiento</label></div>
                            <input class="w-2/3 border-2 border-gray-800 rounded-md font-semibold" name="telefono" placeholder="telefono..." v-model="usuarioModificado.fecha_nacimiento" type="date"/>
                        </div>
                        <p v-for="error in erroresAlModificar" :key="error" class="text-sm text-red-500">{{error}}</p>

                    </div>
                    <AppButton class="mt-3 w-1/3 text-center mb-3" :name="modificando ? 'Aplicar cambios' : 'Modificar'" @click="modificando ? toggleModificando('aplicarCambios') : toggleModificando('empezarAModificar')"/>
                    <AppButton class="w-1/3 text-center mb-4" :name="'Cancelar'" @click="toggleModificando('cancelar')" v-if="modificando"/>
                </div>
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
import utils from '../services/utils'
import policies from '../services/policies'

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
            usuarioModificado: {},
            rolUsuario: {},
            existeUsuario: false,
            cargandoDatos: true,
            modificando: false,
            erroresAlModificar: []
        }
    },
    async created(){
        this.cargandoDatos = true
        await this.cargarUsuario()
        
        if(this.existeUsuario){
            await this.cargarRolUsuario()
            this.asignarUsuarioAModificado()
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
        },
        async toggleModificando(opcion){
            //Si el usuario empieza a modificar
            if(opcion == 'empezarAModificar'){
                this.modificando = !this.modificando
                this.erroresAlModificar = []

                return
            }else if(opcion == 'aplicarCambios'){
                let allOk = this.comprobarDatosUsuario()
                
                if(!allOk)
                    return

                allOk = await this.modificarUsuario()

                if(!allOk)
                    return

                this.modificando = !this.modificando
            }else if(opcion == 'cancelar') {
                this.asignarUsuarioAModificado()
                this.modificando = !this.modificando
            }

            //Si el usuario ya ha modificado los datos necesarios

        },
        asignarUsuarioAModificado(){
            this.usuarioModificado = Object.assign({}, this.usuario)
            this.usuarioModificado.fecha_nacimiento = utils.formatearFechaAEstandar(this.usuarioModificado.fecha_nacimiento)
        },
        comprobarDatosUsuario(){
            let allOk = true
            this.erroresAlModificar = []

            if(!policies.emailEsCorrecto(this.usuarioModificado.email) || this.usuarioModificado.email.length == 0){
                this.erroresAlModificar.push('* Email incorrecto')
                allOk = false
            }

            if(!policies.telefonoEsCorrecto(this.usuarioModificado.telefono) || this.usuarioModificado.telefono.length == 0){
                this.erroresAlModificar.push('* Teléfono incorrecto')
                allOk = false
            }

            if(this.usuarioModificado.nombre.length == 0){
                this.erroresAlModificar.push('* El nombre no puede estar vacío')
                allOk = false
            }

            if(this.usuarioModificado.apellidos.length == 0){
                this.erroresAlModificar.push('* Los apellidos no pueden estar vacíos')
                allOk = false
            }

            return allOk
        },
        async modificarUsuario(){
            const app = await initializeAppObject()

            //Comprobamos si existe un usuario con el nuevo email (si se ha modificado este)
            if(this.usuario.email != this.usuarioModificado.email){
                const usersDB = await app.dao.usuario.read({}, {filter: {email: this.usuarioModificado.email}})
                
                if(usersDB.length != 0){
                    this.erroresAlModificar.push('* El email introducido ya existe')
                    return false
                }
            }

            delete this.usuarioModificado.id
            this.usuarioModificado.create_time = utils.formatearFechaAMysql(this.usuarioModificado.create_time)
            this.usuarioModificado.update_time = utils.formatearFechaAMysql()

            this.usuario = await app.dao.usuario.update({id: this.usuario.id}, this.usuarioModificado)

            return true
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