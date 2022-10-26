<template>
    <Bar :chart-data="chartData" :height="100"></Bar>
</template>

<script>

import {Bar} from 'vue-chartjs'

import { Chart as ChartJS, Title, Tooltip, Legend, BarElement, CategoryScale, LinearScale } from 'chart.js'

ChartJS.register(Title, Tooltip, Legend, BarElement, CategoryScale, LinearScale)

export default {
    name: 'StatsBar',
    components: {
        Bar
    },
    props: {
        data: Array,
        label: '',
        color: ''
    },
    data(){
        return {
            chartData: {
                labels: [ 'Visión espacial', 'Capacidad psicomotriz', 'Inteligencia Emocional', 'Capacidad Resolutiva', 'Inteligencia' ],
                datasets: 
                [ 
                    { 
                        data: this.data,
                        label: this.label,
                        backgroundColor: this.color,
                    } 
                ]
            },
            chartOptions: {
                responsive: true
            }
        }
    }
}
</script>