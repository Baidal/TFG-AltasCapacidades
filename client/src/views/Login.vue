<template>
    <div class="mx-auto w-1/4 mt-10 border-l-2 border-indigo-600 rounded-md shadow-xl p-6 text-center flex flex-col items-center">
        <h1 class="font-bold text-lg">Iniciar sesión</h1>
        <input class="mt-3 border-2 border-gray-700 rounded-lg w-2/3" placeholder="Email..." v-model="email"/>
        <input class="mt-3 border-2 border-gray-700 rounded-lg w-2/3" placeholder="Contraseña..." v-model="password" type="password"/>
        <AppButton :name="'Inicia Sesión'" class="mt-3" @click="login"/>
        <p class="text-md italic text-red-500">{{errorLogin}}</p>
    </div>
</template>

<script>
import {mapStores} from 'pinia'

import AppButton from '../components/AppButton.vue';
import {useAuthStore} from '../stores/Auth.js'

export default {
    name: "Login",
    components: { AppButton },
    data(){
        return {
            email: '',
            password: '',
            errorLogin: ''
        }
    },
    computed: {
        ...mapStores(useAuthStore)
    },
    methods: {
        async login(){
            const result = await this.AuthStore.login(this.email, this.password)
            console.log("result: ", result)
            if(result){
                this.$router.push({name: 'Perfil', params: {id: this.AuthStore.user.id}})
                return
            }
            
            this.errorLogin = 'Login incorrecto'

        }
    }
}
</script>