<template>
    <div class="w-1/3 mx-auto mt-10">
        <p v-if="fechaModificacion !== ''" class="text-center text-gray-700 italic mb-2">Última modificación realizada por {{ usuarioQueHaModificadoObservaciones.nombre }} {{ usuarioQueHaModificadoObservaciones.apellidos }} el {{ fechaModificacion }}.</p>
        <div class="flex flex-col w-full mb-6" v-for="(observacion, index) in observaciones" :key="observacion.id">
            <p class="text-left text-lg font-bold">{{ observacion.observacion}}</p>
            <textarea 
                class="w-full border-2 border-gray-800 rounded-md h-28 pl-2 pt-1" 
                :placeholder="usuarioEsPsicologo ? 'Todavía sin contestar...' : 'Escribe aquí...'" 
                :readonly="usuarioEsPsicologo"
                v-model="respuestas_observaciones[index].respuesta"></textarea>
        </div>
        <div class="flex justify-center w-full mt-4">
            <app-button :name="'Guardar'" v-if="!usuarioEsPsicologo" @click="guardarRespuestaObservaciones"/>
        </div>
    </div>
</template>

<script>
import AppButton from './AppButton.vue'

import {mapStores} from 'pinia'
import {useAuthStore} from '../stores/Auth.js'
import utils from '../services/utils'

export default {
    components: { AppButton },
    name: 'Observaciones',
    props: {
        expedienteId: ''
    },
    data() {
        return {
            observaciones: Array,
            respuestas_observaciones: [],
            usuarioQueHaModificadoObservaciones: {},
            fechaModificacion: '',
        }
    },
    computed: {
        ...mapStores(useAuthStore),
        usuarioEsPsicologo(){
            return utils.userIsPsicologo(this.AuthStore.getUser.id)
        }
    },
    created() {
        this.cargarObservaciones()
    },
    methods: {
        async cargarObservaciones(){
            const app = await this.AuthStore.App
            if(!app)
                return this.$router.push({name: 'Login'})
                
            this.observaciones = await app.dao.observaciones.read()


            const respuestas = await app.dao.respuesta_observacion.read({}, {filter: {expediente_id: this.expedienteId}})
            console.log(respuestas)
            //Cargamos la respuesta de cada observación. Cada respuesta estará linkeada al textearea que corresponde al enunciado de cada observación
            for(const observacion of this.observaciones){
                const indice_respuesta_observacion = respuestas.findIndex(respuesta => respuesta.observaciones_id == observacion.id)
                
                if(indice_respuesta_observacion !== -1){
                    this.respuestas_observaciones.push({respuesta: respuestas[indice_respuesta_observacion].respuesta})
                
                    //Cargamos el usuario que ha creado la respuesta para mostrarlo en la interfaz
                    this.usuarioQueHaModificadoObservaciones = await app.dao.usuario.read(respuestas[indice_respuesta_observacion].usuario_id)
                    //Cargamos las fechas de modificacion y creacion
                    this.fechaModificacion = utils.formatearFecha(respuestas[indice_respuesta_observacion].update_time)
                    console.log("fecha modificacion", this.fechaModificacion)
                }else
                    this.respuestas_observaciones.push({respuesta: ''})
            }
        },
        async guardarRespuestaObservaciones(){
            const app = await this.AuthStore.App
            if(!app)
                return this.$router.push({name: 'Login'})
            
            //Buscamaos en la base de datos si ya existen respuestas para cada observación
            const respuestas = await app.dao.respuesta_observacion.read({}, {filter: {expediente_id: this.expedienteId}})

            //Creamos un for tradicional porque necesitamos el índice
            for(let i = 0; i < this.respuestas_observaciones.length; i++){    
                
                let respuesta = this.respuestas_observaciones[i]
                respuesta.observaciones_id = this.observaciones[i].id
                respuesta.expediente_id = this.expedienteId
                respuesta.usuario_id = this.AuthStore.getUser.id

                let indice_respuesta_existente = respuestas.findIndex(respuestaDB => respuestaDB.observaciones_id == respuesta.observaciones_id)

                //Ya existe la respuesta, hacemos un update
                if(indice_respuesta_existente !== -1){
                    respuesta.create_time = utils.formatearFechaAMysql(respuestas[indice_respuesta_existente].create_time)
                    respuesta.update_time = utils.formatearFechaAMysql()
                    await app.dao.respuesta_observacion.update(respuestas[indice_respuesta_existente].id, respuesta)
                }else{
                    await app.dao.respuesta_observacion.create(respuesta)
                }

            }
        }
    }
}

</script>