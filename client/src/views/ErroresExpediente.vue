<template>
    <div>
        <div class="flex justify-center">
            <div class="w-2/5 text-center flex flex-col space-y-2">
                <h1 class="text-3xl font-bold">Errores al crear el expediente</h1>
                <TarjetaError v-for="error in erroresArray" :key="error" :error="error"/>
                
                <AppButton class="w-1/3 mx-auto" :name="'Continuar al expediente'" v-on:click="this.$router.push({name: 'Expediente', params: {id: expedienteId}})"/>
            </div>
        </div>
    </div>
</template>

<script>
import TarjetaError from "../components/TarjetaError.vue";
import AppButton from "../components/AppButton.vue";
export default {
    name: "ErroresExpediente",
    components: {
        TarjetaError,
        AppButton
    },
    props: {
        errores: '',
        expedienteId: 0
    },
    data() {
        return {
            erroresArray: []
        };
    },
    mounted() {
        this.erroresArray = this.errores.split('&')
    },
    components: { TarjetaError, AppButton }
}
</script>