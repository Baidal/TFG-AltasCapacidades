<template>
    <div class="mt-6 rounded-lg shadow-xl w-1/2 mx-auto hover:shadow-lg flex flex-col">
        <h1 class="text-center font-bold text-lg">Administración</h1>
        <!-- Tab con las opciones a elegir-->
        <div class="mt-2 flex justify-center space-x-4">
            <AppButton :name="'Usuarios'" :class="isSelectedTab('Usuarios')" @click="selectTab('Usuarios')"/>
            <AppButton :name="'Categorías'" :class="isSelectedTab('Categorías')" @click="selectTab('Categorías')"/>
        </div>

        <UsersTab v-if="this.selectedTab === 'Usuarios'" class="mb-6"/>
        <CategoriesTab v-if="this.selectedTab === 'Categorías'"/>
    </div>
</template>

<script>
import AppButton from '../components/AppButton.vue';
import UsersTab from '../components/administracion/UsersTab.vue';
import CategoriesTab from '../components/administracion/CategoriesTab.vue';

export default {
    name: "Administracion",
    components: { AppButton, UsersTab, CategoriesTab },
    data(){
        return {
            selectedTab: 'Usuarios'
        }
    },
    methods: {
        isSelectedTab(name){
            return this.selectedTab === name ? 'bg-gray-200' : ''
        },
        selectTab(name){
            this.selectedTab = name
        }
    }
}
</script>