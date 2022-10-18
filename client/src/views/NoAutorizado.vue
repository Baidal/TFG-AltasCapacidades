<template>
    <div class="text-center mt-2 text-7xl font-bold flex flex-col space-y-12 justify-center items-center">
        Acceso no permitido
        <AppButton :name="'Volver'" @click="this.$router.go(-2)" class="w-30 text-4xl mt-10"/>
    </div>
</template>

<script>
import AppButton from '../components/AppButton.vue'
export default {
    name: 'NoAutorizado',
    components: {
        AppButton
    }
}
</script>