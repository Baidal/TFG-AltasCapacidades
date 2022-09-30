<template>
    <div class="w-4/5 mx-auto mt-2">
        <div class="flex flex-col justify-center items-center space-y-3">
            <UserTab v-for="user in users" :key="user.id" :user="user"/>
        </div>
    </div>
</template>

<script>
import initializeAppObject from '../../services/daoProvider'
import UserTab from './UserTab.vue'
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
    methods: {
        async getAllUsers() {
            const app = await initializeAppObject();
            this.users = await app.dao.usuario.read();
        }
    },
    components: { UserTab }
}
</script>