<template>
    <div :class="['border-2', 'mb-1','cursor-pointer', 'border-gray-700', 'rounded-md', 'p-1', 'opacity-60', marked ? 'bg-gray-200' : 'bg-white']" v-on:click="toggleMarked">
        <p class="font-bold text-black">{{nombre}}</p>
    </div>
</template>

<script>
    export default {
        name: 'BusquedaUsuarioTarjeta',
        data() {
            return {
                marked: false
            }
        },  
        props: {
            nombre: '',
        },
        methods: {
            toggleMarked(){
                this.marked = !this.marked
            }
        }
    }
</script>