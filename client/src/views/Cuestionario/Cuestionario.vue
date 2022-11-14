<template>
    <div class="flex flex-col justify-center mt-4 items-center">
        <div class="w-1/2 text-center text-gray-800 text-lg font-semibold">
            <p>Cuestionario {{this.id}} - Completado por Luis Vidal el 25/10/22 - Tutor</p>
        </div>
        <div class="w-1/2 border border-gray-800"></div>
        <div class="w-1/2 mt-2">
            <Cuestion v-for="cuestion in cuestiones" :key="cuestion.numCuestion" :numCuestion="cuestion.numCuestion" :pregunta="cuestion.pregunta" :respuestas="cuestion.respuestas" :viendoRespuestas="viendoRespuestas"/>
        </div>
        <app-button :name="'Volver'" class="mt-4 mb-4" @click="this.$router.go(-1)"/>
    </div>
</template>

<script>
import AppButton from '../../components/AppButton.vue';
import Cuestion from './Cuestion.vue';

export default {
    name: "Cuestionario",
    props: {
        id: ""
    },
    data() {
        return {
            cuestiones: [{
                idCuestion: 1, 
                numCuestion: 1, 
                pregunta: "¿Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.?",
                respuestas: [{
                        respuesta: 'Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum. Sed ut perspiciatis unde omnis iste natus error sit voluptatem accusantium doloremque laudantium. Iusto odio dignissimos ducimus qui blanditiis.', 
                        idRespuesta: 1, 
                        marcada: false
                    },
                    {
                        respuesta: 'Sed ut perspiciatis unde omnis iste natus error sit voluptatem accusantium doloremque laudantium.', 
                        idRespuesta: 2, 
                        marcada: false
                    },
                    {
                        respuesta: 'At vero eos et accusamus et iusto odio dignissimos ducimus qui blanditiis.', 
                        idRespuesta: 3, 
                        marcada: false
                    },
                    {
                        respuesta: 'Excepteur sint occaecat cupidatat non proident.', 
                        idRespuesta: 4, 
                        marcada: true
                    }
                ]
            },
            {
                idCuestion: 2, 
                numCuestion: 2, 
                pregunta: "¿Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.?",
                respuestas: [{
                        respuesta: 'Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum. Sed ut perspiciatis unde omnis iste natus error sit voluptatem accusantium doloremque laudantium. Iusto odio dignissimos ducimus qui blanditiis.', 
                        idRespuesta: 1, 
                        marcada: false
                    },
                    {
                        respuesta: 'Sed ut perspiciatis unde omnis iste natus error sit voluptatem accusantium doloremque laudantium.', 
                        idRespuesta: 2, 
                        marcada: true
                    },
                    {
                        respuesta: 'At vero eos et accusamus et iusto odio dignissimos ducimus qui blanditiis.', 
                        idRespuesta: 3, 
                        marcada: false
                    },
                    {
                        respuesta: 'Excepteur sint occaecat cupidatat non proident.', 
                        idRespuesta: 4, 
                        marcada: false
                    }
                ]
            },
            {
                idCuestion: 3, 
                numCuestion: 3, 
                pregunta: "¿Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.?",
                respuestas: [{
                        respuesta: 'Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum. Sed ut perspiciatis unde omnis iste natus error sit voluptatem accusantium doloremque laudantium. Iusto odio dignissimos ducimus qui blanditiis.', 
                        idRespuesta: 1, 
                        marcada: false
                    },
                    {
                        respuesta: 'Sed ut perspiciatis unde omnis iste natus error sit voluptatem accusantium doloremque laudantium.', 
                        idRespuesta: 2, 
                        marcada: true
                    },
                    {
                        respuesta: 'At vero eos et accusamus et iusto odio dignissimos ducimus qui blanditiis.', 
                        idRespuesta: 3, 
                        marcada: false
                    },
                    {
                        respuesta: 'Excepteur sint occaecat cupidatat non proident.', 
                        idRespuesta: 4, 
                        marcada: true
                    }
                ]
            }],
            viendoRespuestas: true
        };
    },
    components: { Cuestion, AppButton }
}
</script>