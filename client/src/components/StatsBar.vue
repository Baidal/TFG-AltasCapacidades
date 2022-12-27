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
        chartData: {}
    }
}
</script>