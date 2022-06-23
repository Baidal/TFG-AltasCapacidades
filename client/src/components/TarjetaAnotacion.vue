<template>
    <div class="w-full border-2 border-gray-700 bg-gray-300 p-4 text-left rounded-md">
        <div class="flex flex-col">
            <p class="font-bold">{{anotacion.titulo}}</p>
            <p class="">{{anotacion.anotacion}}</p>
            
            <div class="mt-4 flex space-x-3">
                <AppButton class="" :name="'Modificar Anotación'"/>
                <p class="text-gray-500 my-auto italic text-sm font-semibold">Creada el {{obtenerFecha(anotacion.create_time)}} - Modificada el {{obtenerFecha(anotacion.update_time)}}</p>
            </div>
        </div>
    </div>
</template>

<script>
import AppButton from '../components/AppButton.vue'

import utils from '../services/utils'

export default {
    name: 'Anotacion',
    components: {
        AppButton
    },
    props: {
        anotacion: {}
    },
    methods: {
        obtenerFecha(fecha){
            return utils.formatearFecha(fecha)
        }
    }

}
</script>