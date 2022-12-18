<template>
    <div class="mt-2 flex space-x-3 justify-center flex-wrap mb-6 items-center">
        <p v-for="category in categories" :key="category.id" :class="getCategoryClass(category.rol) + ' my-3'">
            {{category.rol}}
        </p>
    </div>
</template>

<script>
import utils from '../../services/utils'

import {mapStores} from 'pinia'
import {useAuthStore} from '../../stores/Auth.js'

export default {
    name: 'CategoriesTab',
    data(){
        return {
            categories: []
        }
    },
    mounted(){
        this.getAllCategories()
    },
    computed: {
        ...mapStores(useAuthStore)
    },
    methods: {
        async getAllCategories(){
            const app = await this.AuthStore.App
            if(!app)
                this.$router.push({name: 'Login'})

            this.categories = await app.dao.rol.read()
        },
        getCategoryClass(category){
            return utils.getCategoryClass(category)
        }
    }
}
</script>