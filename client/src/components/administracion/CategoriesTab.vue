<template>
    <div class="mt-2 flex space-x-3 justify-center flex-wrap mb-6 items-center">
        <p v-for="category in categories" :key="category.id" :class="getCategoryClass(category.rol) + ' my-3'">
            {{category.rol}}
        </p>
    </div>
</template>

<script>
import initializeAppObject from '../../services/daoProvider'
import utils from '../../services/utils'

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
    methods: {
        async getAllCategories(){
            const app = await initializeAppObject()
            this.categories = await app.dao.rol.read()
        },
        getCategoryClass(category){
            return utils.getCategoryClass(category)
        }
    }
}
</script>