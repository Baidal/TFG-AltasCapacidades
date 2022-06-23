<template>
    <div class="w-full border-2 border-gray-700 bg-gray-300 p-4 text-left rounded-md">
        <div class="flex flex-col">
            <input :class="claseCssInput()" v-model="anotacion.titulo" :disabled="!modificable"/>
            <span role="textbox" :contenteditable="modificable" :class="claseCssTextarea()" ref="span">{{anotacion.anotacion}}</span>
            <div class="mt-4 flex space-x-3">
                <AppButton class="" :name="modificable ? 'Aplicar modificación' : 'Modificar Anotación'" @click="modificarAnotacion"/>
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
    data(){
        return{
            modificable: false
        }
    },
    methods: {
        obtenerFecha(fecha){
            return utils.formatearFecha(fecha)
        },
        toggleModificable(){
            this.modificable = !this.modificable
        },
        claseCssInput(){
            var cssClass = "font-bold bg-gray-300 "

            return cssClass + (this.modificable ? "border-2 border-gray-500 rounded-md focus:border-gray-500" : "") 
        },
        claseCssTextarea(){
            var cssClass = "overflow-hidden bg-gray-300 mt-2 "

            return cssClass + (this.modificable ? "border-2 border-gray-500 border-black rounded-md" : "")
        },
        modificarAnotacion(){
            if(this.modificable){
                this.anotacion.anotacion = this.$refs.span.textContent
                this.$emit('modificarAnotacion', this.anotacion)
            }
            
            this.toggleModificable()
        }
    }

}
</script>