<template>
    <div class="flex flex-col mt-10">
        <p class="font-bold text-5xl">Resultados conjuntos</p>
        <div class="mt-6 flex justify-center">
            <div class="w-1/4 text-center flex flex-col items-center justify-center mx-8">
                <p class="font-bold text-3xl">
                    69% Aptitud*
                </p>
                <p class="italic text-gray-600 font-semibold">
                    *Datos obtenidos de calcular la media de todos los informes generados a partir de los resultados de los usuarios
                </p>
            </div>
            <div class="w-3/4">
                <Bar :chart-data="chartData" :height="100"/>
            </div>
        </div>
    </div>
</template>

<script>
import {Bar} from 'vue-chartjs'

import { Chart as ChartJS, Title, Tooltip, Legend, BarElement, CategoryScale, LinearScale } from 'chart.js'

ChartJS.register(Title, Tooltip, Legend, BarElement, CategoryScale, LinearScale)

export default {
    name: 'Resultadosconjuntos',
    data(){
        return {
            chartData: {
                labels: [ 'Visión espacial', 'Capacidad psicomotriz', 'Inteligencia Emocional', 'Capacidad Resolutiva', 'Inteligencia' ],
                datasets: 
                [ 
                    { 
                        data: [75, 70, 83, 80, 77],
                        label: '% Aptitud obtenida para cada ámbito',
                        backgroundColor: '#f87979',
                        borderColor: '#ffffff',
                        borderWidth: 2,
                        borderRadius: 2
                    } 
                ]
            },
            chartOptions: {
                responsive: true
            }
        }
    },
    props: {
        idExpediente: ''
    },
    components: {
        Bar
    }
    
}
</script>