<template>
    <div class="grid grid-rows-4 w-full grid-container-cuestionarios">
        <TarjetaCuestionariosUsuario 
            v-for="usuario in this.usuarios" 
            :key="usuario.usuario.id" 
            :usuario="usuario.usuario" 
            :cuestionarios="usuario.cuestionarios" 
            :idExpediente="expedienteId"
            @eliminarRelacionCuestionario="eliminarRelacionCuestionario"/>
    </div>
</template>

<script>

import {mapStores} from 'pinia'
import {useAuthStore} from '../../stores/Auth'
import TarjetaCuestionariosUsuario from './TarjetaCuestionariosUsuario.vue'

export default {
    name: 'CuestionariosRealizadosUsuarios',
    components: { TarjetaCuestionariosUsuario },
    props: {
        expedienteId: ''
    },
    data(){
        return {
            /**
             * Usuarios será un array de objetos del siguiente prototipo:
             * [
             *  {
             *      usuario: {id: '2', nombre: 'luis', ...},
             *      cuestionarios: [
             *                      {
             *                          completado: true,
             *                          cuestionario: {nombre: 'cuestionario 1', id: 1}
             *                      },
             *                      {
             *                          completado: false,
             *                          cuestionario: {nombre: 'cuestionario 2', id: 2}
             *                      }                       
             *      ]
             *  }
             * ]
             */
            usuarios: []
        } 
        
    },
    async created(){    
        const app = await this.AuthStore.App
        if(!app)
            return this.$router.push({name: 'Login'})

        if(!this.expedienteId)
            return

        this.usuarios = await this.loadAllUsers(app)
    },
    computed: {
        ...mapStores(useAuthStore)
    },
    methods: {
        async loadAllUsers(app){
            let Usuarios = []
            
            //Cargamos todos los usuarios relacionados con el expediente
            const usuario_expediente = await app.dao.usuario_expediente.read({}, {filter: {expediente_id: this.expedienteId}})

            for(const usuarioExpediente of usuario_expediente){
                let usuario = await app.dao.usuario.read(usuarioExpediente.usuario_id)
                let categoria_usuario = await app.dao.rol.read(usuarioExpediente.rol_id)
                usuario.categoria = categoria_usuario

                //Cargamos todos los cuestionarios que un usuario tiene relacionados en un expediente
                const cuestionario_usuario_expediente = await app.dao.cuestionario_usuario_expediente.read({}, {filter: {usuario_expediente_id: usuarioExpediente.id}})
                
                let cuestionarios = []
                for(const cuestionarioUsuarioExpediente of cuestionario_usuario_expediente){
                    const cuestionario = await app.dao.cuestionarios.read(cuestionarioUsuarioExpediente.cuestionario_id)
                    cuestionarios.push({
                            completado: cuestionarioUsuarioExpediente.completado == 1 ? true : false,
                            cuestionario,
                        })
                }
                
                Usuarios.push({usuario, cuestionarios})
            }

            return Usuarios
        },
        eliminarRelacionCuestionario(idCuestionario, idUsuario){
            //this.usuario.cuestionarios = this.usuario.cuestionarios.filter(objetoCuestionario => objetoCuestionario.cuestionario.id == idCuestionario)
            const indexUsuario = this.usuarios.findIndex(usuario => usuario.usuario.id == idUsuario)
            if(indexUsuario === -1)
                return

            console.log(this.usuarios[indexUsuario])
            
            this.usuarios[indexUsuario].cuestionarios = this.usuarios[indexUsuario].cuestionarios.filter(objetoCuestionario => objetoCuestionario.cuestionario.id != idCuestionario)
        }
    }   
}
</script>

<style scoped>
    .grid-container-cuestionarios{
        grid-template-columns: repeat(auto-fill, minmax(450px, 1fr));
    }
</style>