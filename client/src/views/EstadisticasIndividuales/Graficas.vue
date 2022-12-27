<template>
    <div class="flex flex-col">
        <div class="flex flex-col mt-4" v-for="datoCuestionario in datosCuestionarios" :key="datoCuestionario.id">
            <p class="text-xl font-bold">{{ datoCuestionario.labels[0] }}</p>
            <stats-bar :chart-data="datoCuestionario"/>
        </div>
        
    </div>
</template>

<script>
import StatsBar from '../../components/StatsBar.vue'
export default {
  components: { StatsBar },
    name: 'Graficas',
    data(){
        return {
            datosCuestionarios: []
        }
    },
    created(){
        this.cargarDatasets()
    },
    methods: {
        cargarDatasets(){
            //Dataset hipercognicion
            this.datosCuestionarios.push(
                {
                    id: 1,
                    labels: ['Hipercognición'],
                    datasets: 
                    [ 
                        { 
                            data: [80],
                            label: 'Hipercognición',
                            backgroundColor: '#45c73a',
                        } 
                    ]
                }
            )
            this.datosCuestionarios.push(
                {
                    id: 2,
                    labels: ['Sobre-excitabilidad'],
                    datasets: 
                    [ 
                        { 
                            data: [77],
                            label: 'Sensorial',
                            backgroundColor: '#d13434',
                        },
                        { 
                            data: [80],
                            label: 'Física',
                            backgroundColor: '#db7337',
                        },
                        { 
                            data: [70],
                            label: 'Sensorial',
                            backgroundColor: '#d69f38',
                        }   
                    ]
                }
            )
            this.datosCuestionarios.push(
                {
                    id: 3,
                    labels: ['Aptitudes'],
                    datasets: 
                    [ 
                        { 
                            data: [77],
                            label: 'lingüística',
                            backgroundColor: '#c92a3a',
                        },
                        { 
                            data: [80],
                            label: 'matemática',
                            backgroundColor: '#3737de',
                        },
                        { 
                            data: [77],
                            label: 'espacial',
                            backgroundColor: '#4fe357',
                        },
                        { 
                            data: [70],
                            label: 'Psicomotriz',
                            backgroundColor: '#d2de52',
                        },
                        { 
                            data: [65],
                            label: 'Socioemocional',
                            backgroundColor: '#de4bd7',
                        }        
                    ]
                }
            )
        }
    }
}
</script>