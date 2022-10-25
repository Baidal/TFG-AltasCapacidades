<template>
    <div>
        <ResultadosConjuntos/>
        <ResultadosIndividuales :idExpediente="this.idExpediente"/>
    </div>
</template>

<script>
import ResultadosConjuntos from './ResultadosConjuntos.vue';
import ResultadosIndividuales from './ResultadosIndividuales.vue';
export default {
    name: "Estadisticasexpediente",
    components: { ResultadosConjuntos, ResultadosIndividuales },
    props: {
        idExpediente: ''
    }
}
</script>