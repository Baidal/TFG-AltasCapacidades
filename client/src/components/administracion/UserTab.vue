<template>
    <div class="border-2 border-black border-opacity-80 rounded-lg p-2 w-full">
        <div class="flex justify-between bg-">
            <p class="cursor-pointer font-semibold ml-2 hover:bg-gray-100 rounded-md px-2" @click="this.$router.push({name: 'Perfil', params: {id: user.id}})">{{user.email}}</p>
            <div class="flex space-x-2">
                <!-- Dropdown de categoria-->
                <select :class="getCategoryClass(user.categoria?.rol)" v-if="!userIsAdmin()" @change="onChangeSelectCategory">
                    <option :value="user.categoria?.id">{{user.categoria?.rol}}</option>
                    <option v-for="category in categories" :key="category?.id" :value="category?.id">{{category?.rol}}</option>
                </select>
                <p :class="getCategoryClass(user.categoria?.rol)" v-else>{{user.categoria?.rol}}</p>
                
                <!-- Dropdown de estado del usuario-->
                <select :class="getStateClass(user.estado?.estado)" @change="onChangeSelectState">
                    <option :value="user.estado?.id">{{user.estado?.estado}}</option>
                    <option v-for="state in states" :key="state.id" :value="state?.id">{{state.estado}}</option>
                </select>
            </div>
        </div>
    </div>
</template>

<script>
import utils from '../../services/utils'

import {mapStores} from 'pinia'
import {useAuthStore} from '../../stores/Auth.js'

export default {
    name: 'UserTab',
    data(){
        return {
            categories: [],
            states: []
        }
    },
    props: {
        user: {}
    },
    async mounted(){
        await this.getUserCategory()
        await this.getUserState()
        this.getAllCategories()
        this.getAllStates()
    },
    computed: {
        ...mapStores(useAuthStore)
    },
    methods: {
        async getUserCategory(){
            const app = await this.AuthStore.App
            if(!app)
                this.$router.push({name: 'Login'})

            this.user.categoria = await app.dao.rol.read(this.user.rol_id)
        },
        async getUserState(){
            const app = await this.AuthStore.App
            if(!app)
                this.$router.push({name: 'Login'})

            this.user.estado = await app.dao.estado.read(this.user.estado_id)
        },
        async getAllCategories(){
            const app = await this.AuthStore.App
            if(!app)
                this.$router.push({name: 'Login'})
            
            this.categories = await app.dao.rol.read()
            this.categories = this.categories.filter(category => category.rol != 'admin' && category.id !== this.user.categoria.id) 
        },
        async getAllStates(){
            const app = await this.AuthStore.App
            if(!app)
                this.$router.push({name: 'Login'})

            this.states = await app.dao.estado.read()
            this.states = this.states.filter(state => state.id !== this.user.estado.id) 
        },
        getCategoryClass(category){
            return utils.getCategoryClass(category)
        },
        getStateClass(state){
            switch(state){
                case 'activo':
                    return 'bg-green-600 bg-opacity-70 rounded px-1 font-semibold text-center'
                case 'inactivo':
                    return 'bg-yellow-600 bg-opacity-70 rounded px-1 font-semibold text-center'
                case 'vetado':
                    return 'bg-red-600 bg-opacity-70 rounded px-1 font-semibold text-center'
            }
        },
        userIsAdmin(){
            return this.user.categoria?.rol == 'admin'
        },
        async onChangeSelectCategory(event){
            const nuevoRolId = event.target.value
            const app = await this.AuthStore.App
            if(!app)
                this.$router.push({name: 'Login'})
            
            const nuevoRolBD = await app.dao.rol.read(parseInt(nuevoRolId))

            app.dao.usuario.update(this.user.id, {rol_id: nuevoRolId})
            this.user.categoria = nuevoRolBD

            this.getAllCategories()
        },
        async onChangeSelectState(event){
            const nuevoEstadoId = event.target.value
            const app = await this.AuthStore.App
            if(!app)
                this.$router.push({name: 'Login'})
            
            const nuevoEstadoBD = await app.dao.estado.read(parseInt(nuevoEstadoId))

            app.dao.usuario.update(this.user.id, {estado_id: nuevoEstadoId})
            this.user.estado = nuevoEstadoBD
        }
    }
}
</script>

<style>
    select option{
        background: rgba(255, 255, 255);
    }
</style>