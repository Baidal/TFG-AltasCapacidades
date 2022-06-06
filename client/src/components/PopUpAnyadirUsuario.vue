<template>
    <div class="fixed top-0 left-0 w-screen h-screen bg-gray-200 opacity-90 z-20">
        <div class="absolute top-1/3 left-1/2 -mt-12 -ml-80 w-1/3 border-2 border-black rounded-md shadow-md opacity-100 p-2 bg-gray-300 ">
            <p class="font-bold text-base">Nuevo usuario</p>
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

                <AppButton :name="'Crear usuario'" @click="handleNewUser"/>
            </div>
        </div>
    </div>
</template>

<script>
import AppButton from './AppButton.vue';
    export default {
    name: "PopUpAnyadirUsuario",
    components: { AppButton },
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
            warnings: ['* Solo el email es obligatorio']
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
            if (!this.newUser.email.match(/^\w+([\.-]?\w+)*@\w+([\.-]?\w+)*(\.\w{2,3})+$/)){
                this.warnings.push('* El email es incorrecto')
                allOk = false
            }

            //Comprobamos que el teléfonon sea correcto
            if (this.newUser.telefono != '' && (this.newUser.telefono.length != 9 || !this.newUser.telefono.match(/^\d+$/))){
                this.warnings.push('* Teléfono incorrecto')
                allOk = false
            }

            //Comprobamos que el dni sea correcto (sea nif o sea nie)
            if(this.newUser.dni != '' && !(this.newUser.dni.match(/^[0-9]{8}[TRWAGMYFPDXBNJZSQVHLCKE]$/i) || this.newUser.dni.match(/^[XYZ][0-9]{7}[TRWAGMYFPDXBNJZSQVHLCKE]$/i))){
                this.warnings.push('* Dni o Nie Incorrecto')
                allOk = false
            }

            return allOk
        },
        handleNewUser(){
            if(!this.allInputsAreOk()){
                return
            }
            
        }
    }
}
</script>