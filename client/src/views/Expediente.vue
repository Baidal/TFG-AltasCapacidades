<template>
    <div>
        <h1>Hola mundo!</h1>
        {{this.expedienteEncontrado() ? 'Encontrado' : 'No encontrado'}}
    </div>
</template>

<script>
import initializeAppObject from '../services/daoProvider'

export default {
    name: 'Expediente',
    props: {
        id: ''
    },
    data() {
        return {
            expediente: {},
        }
    },
    created(){
        this.cargarExpediente()
    },
    methods: {
        async cargarExpediente(){
            if(this.id == '')
                return false
            
            const app = await initializeAppObject()
            const expedientes = await app.dao.expediente.read()

            this.expediente = expedientes.find(expedienteDB => expedienteDB.id == this.id) || {}
            
            return this.expedienteEncontrado()
        },
        expedienteEncontrado(){
            return Object.keys(this.expediente).length !== 0
        }
    },

}
</script>