<template>
    <div class="fixed top-0 left-0 w-screen h-screen bg-gray-200 opacity-90 z-20">
        <div class="absolute top-1/3 left-1/2 -mt-12 -ml-80 w-1/3 border-2 border-black rounded-md shadow-md opacity-100 p-2 bg-gray-300 ">
            <div class="absolute top-2 right-4 cursor-pointer"><XCircleIcon class="w-6 h-6" @click="alreadyCreated ? $emit('closeModifyUser') : $emit('closeNewUser')"/></div>
            <p class="font-bold text-base">{{alreadyCreated ? 'Modificar usuario' : 'Nuevo usuario'}}</p>
            <div class="w-3/5 mx-auto space-y-2">        
                <!-- Email -->
                <input  class="w-full border-2 border-black rounded-md shadow-md"
                        placeholder="Email..." id="email" name="email" v-model="newUser.email">
                <!-- Nombre y Apellidos -->
                <div class="flex space-x-2">
                    <input  class="w-1/3 border-2 border-black rounded-md shadow-md"
                        placeholder="Nombre..." v-model="newUser.nombre">
                    <input  class="w-full border-2 border-black rounded-md shadow-md"
                        placeholder="Apellidos..."  v-model="newUser.apellidos">
                </div>
                <!-- Dni y Teléfono -->
                <div class="flex space-x-2">
                    <input  class="w-2/3 border-2 border-black rounded-md shadow-md"
                        placeholder="Dni..."  v-model="newUser.dni">
                    <input  class="w-full border-2 border-black rounded-md shadow-md"
                        placeholder="Telefono..."  v-model="newUser.telefono">
                </div>
                <!-- Fecha de nacimiento -->
                <input  class="w-full border-2 border-black rounded-md shadow-md"
                        placeholder="Fecha de nacimiento..." type="date"  v-model="newUser.fechaNac">
                
                <div class="flex flex-col items-start pl-2">
                    <p class="float-left text-red-500 font-semibold" v-for="warning in warnings" :key="warning">{{warning}}</p>
                </div>

                <AppButton :name="alreadyCreated ? 'Modificar usuario' : 'Crear usuario'" @click="handleClick"/>
            </div>
        </div>
    </div>
</template>

<script>
    import policies from '../services/policies';

    import AppButton from './AppButton.vue';

    import {XCircleIcon} from '@heroicons/vue/outline'

    export default {
    name: "PopUpAnyadirUsuario",
    components: { AppButton, XCircleIcon },
    props: {
        /**
         * Este componente recibirá esta estructura cuando se esté modificando un
         * nuevo usuario
         */
        createdUser: {
            email: '',
            nombre: '',
            apellidos: '',
            dni: '',
            telefono: '',
            fechaNac: ''
        },
        alreadyCreated: false //Si el usuario ya ha sido creado y se está modificando
    },
    data(){
        return {
            newUser: {
                email: '',
                nombre: '',
                apellidos: '',
                dni: '',
                telefono: '',
                fechaNac: ''
            },
            cleanEmail: '', //Guarda el email, en caso de ser modificado para que el componente padre sepa que usuario se ha modificado
            warnings: ['* Solo el email es obligatorio']
        }
    },
    mounted() {
        if(this.alreadyCreated){
            this.cleanEmail = this.createdUser.email
            
            this.newUser.email = this.createdUser.email
            this.newUser.nombre = this.createdUser.nombre
            this.newUser.apellidos = this.createdUser.apellidos
            this.newUser.dni = this.createdUser.dni
            this.newUser.telefono = this.createdUser.telefono
            this.newUser.fechaNac = this.createdUser.fechaNac
        }
    },
    methods: {
        /**
         * Comprueba que los inputs sean correctos
         */
        allInputsAreOk(){
            this.warnings = []

            var allOk = true
            
            //Comprobamos que el email no esté vacío
            if (this.newUser.email == ''){
                this.warnings.push('* El email es obligatorio')
                allOk = false
            }

            //Comprobamos que el email sea correcto
            if (!policies.emailEsCorrecto(this.newUser.email)){
                this.warnings.push('* El email es incorrecto')
                allOk = false
            }

            //Comprobamos que el teléfonon sea correcto
            if (!policies.telefonoEsCorrecto(this.newUser.telefono)){
                this.warnings.push('* Teléfono incorrecto')
                allOk = false
            }

            //Comprobamos que el dni sea correcto (sea nif o sea nie)
            if(!policies.dniNieEsCorrecto(this.newUser.dni)){
                this.warnings.push('* Dni o Nie Incorrecto')
                allOk = false
            }

            return allOk
        },
        /**
         * Le envíamos al padre del componente el nuevo usuario creado
         */
        handleNewUser(){
            if(!this.allInputsAreOk()){
                return
            }
            this.$emit('newUser', this.newUser)
            this.newUser = {email: '',
                nombre: '',
                apellidos: '',
                dni: '',
                telefono: '',
                fechaNac: ''}
        },
        handleModifyUser(){
            if(!this.allInputsAreOk()){
                return
            }
            this.$emit('modifyUser', this.newUser, this.cleanEmail)
            this.newUser = {email: '',
                nombre: '',
                apellidos: '',
                dni: '',
                telefono: '',
                fechaNac: ''}
        },
        handleClick(){
            if(this.alreadyCreated)
                this.handleModifyUser()
            else
                this.handleNewUser()
        }
    }
}
</script>