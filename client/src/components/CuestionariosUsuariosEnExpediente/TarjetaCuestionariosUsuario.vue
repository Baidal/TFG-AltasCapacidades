<template>
    <div class="border-2 border-black rounded-md m-2 p-2">
        <p class="font-bold">{{usuario.nombre}} - {{usuario.categoria.rol}}</p>
        <div class="grid grid-rows-4 grid-cols-3 w-full grid-container" v-if="this.cuestionarios.length !== 0">
            <TarjetaCuestionario v-for="cuestionario in this.cuestionarios" :key="cuestionario.cuestionario.id" :cuestionario="cuestionario"/>
        </div>
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
    components: { TarjetaCuestionario }
}
</script>

<style>
    .grid-container{
        grid-template-columns: repeat(auto-fill, minmax(40px, 50px));
    }
</style>