<template>
    <div class="mt-4">
        <p class="text-lg font-semibold text-gray-900">Cuestión {{numCuestion}}. {{pregunta}}</p>
        <div class="pl-10 flex flex-col space-y-2 text-black text-lg" v-if="!viendoRespuestas">
            <label v-for="respuesta in respuestas" :key="respuesta.id"><input type="checkbox" :id="respuesta.id" value="respuesta.id" :checked="respuesta.marcada" aria-disabled="true"/> {{respuesta.respuesta}}</label>
        </div>
        <div v-if="viendoRespuestas" class="pl-10 flex space-y-2 flex-col text-black text-lg">
            <div class="flex justify-start" v-for="respuesta in respuestas" :key="respuesta.id">
                <div class="w-10 h-10 mt-2 flex items-center justify-center">
                    <BadgeCheckIconSolid v-if="respuesta.marcada" class="h-6"/>
                    <BadgeCheckIconOutline v-else class="h-6"/>
                </div>
                <p class="ml-2 w-full my-auto">{{respuesta.respuesta}}</p>
            </div>
        </div>
    </div>
</template>

<script>
import {BadgeCheckIcon as BadgeCheckIconSolid} from '@heroicons/vue/solid'
import {BadgeCheckIcon as BadgeCheckIconOutline} from '@heroicons/vue/outline'

export default {
    name: 'Cuestion',
    components: {
        BadgeCheckIconSolid,
        BadgeCheckIconOutline
    },
    props: {
        numCuestion: 0,
        pregunta: '',
        respuestas: Array,
        viendoRespuestas: Boolean
    },
    methods: {
        handleCheckboxClick(){
            return
        }
    },
}
</script>