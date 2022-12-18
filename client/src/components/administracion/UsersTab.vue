<template>
    <div class="w-4/5 mx-auto mt-2">
        <div class="flex flex-col justify-center items-center space-y-3">
            <UserTab v-for="user in users" :key="user.id" :user="user"/>
        </div>
    </div>
</template>

<script>
import UserTab from './UserTab.vue'

import {mapStores} from 'pinia'
import {useAuthStore} from '../../stores/Auth.js'

export default {
    name: "UsersTab",
    data() {
        return {
            users: []
        };
    },
    async mounted() {
        this.getAllUsers();
    },
    computed: {
        ...mapStores(useAuthStore)
    },
    methods: {
        async getAllUsers() {
            const app = await this.AuthStore.App
            if(!app)
                this.$router.push({name: 'Login'})

            this.users = await app.dao.usuario.read();
        }
    },
    components: { UserTab }
}
</script>