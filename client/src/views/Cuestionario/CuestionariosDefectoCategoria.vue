<template>
    <div class="grid grid-rows-2 grid-container-tarjeta-cuestionarios-categorias">
        <tarjeta-categoria v-for="categoria in categorias" :key="categoria.id" :categoria="categoria"/>
    </div>
</template>

<script>
import TarjetaCategoria from './TarjetaCategoria.vue'

import {mapStores} from 'pinia'
import {useAuthStore} from '../../stores/Auth.js'

export default {
    name: 'CuestionariosDefectoCategoria',
    data(){
        return {
            categorias: Array
        }
    },
    components: {
        TarjetaCategoria
    },  
    created(){
        this.cargarCategorias()
    },
    computed: {
        ...mapStores(useAuthStore)
    },
    methods: {
        async cargarCategorias(){
            const app = await this.AuthStore.App
            if(!app) 
                return this.$router.push({name: 'Login'})

            this.categorias = await app.dao.rol.read()

            this.categorias = this.categorias.filter(categoria => !categoria.rol.includes('admin'))
        }
    }
}
</script>

<style scoped>
    .grid-container-tarjeta-cuestionarios-categorias{
        grid-template-columns: repeat(auto-fill, minmax(700px, 750px));
    }
</style>