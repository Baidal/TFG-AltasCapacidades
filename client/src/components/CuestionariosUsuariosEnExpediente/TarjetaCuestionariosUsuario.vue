<template>
    <div class="border-2 border-black rounded-md m-2 p-2 text-center">
        <p class="font-bold text-left">{{usuario.nombre}} - {{usuario.categoria.rol}}</p>
        <div class="grid grid-cols-3 w-full grid-container" v-if="sinCuestionarios">
            <TarjetaCuestionario v-for="cuestionario in this.cuestionarios" :key="cuestionario.cuestionario.id" :cuestionario="cuestionario"/>
        </div>
        <router-link :to="{name: 'Home'}" class="text-blue-700  w-full" v-if="sinCuestionarios">Ver estadísticas</router-link>
        <div v-else>
            <p class="font-bold text-center mt-4">Sin cuestionarios asignados</p>
        </div>
    </div>
</template>

<script>
import TarjetaCuestionario from "./TarjetaCuestionario.vue";
export default {
    name: "CuestionariosRealizadosUsuarios",
    props: {
        usuario: Object,
        cuestionarios: Array
    },
    components: { TarjetaCuestionario },
    computed: {
        sinCuestionarios(){
            return this.cuestionarios.length !== 0
        }
    }
}
</script>

<style scoped>
    .grid-container{
        grid-template-columns: repeat(auto-fill, minmax(100px, 140px));
    }
</style>