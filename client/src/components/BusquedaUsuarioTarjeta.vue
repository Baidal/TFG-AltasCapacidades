<template>
    <div :class="['border-2', 'mb-1','cursor-pointer', 'border-gray-800', 'rounded-md', 'p-1', marked && clickable ? 'bg-gray-200' : 'bg-white']" v-on:click="toggleMarked">
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
            clickable: {
                type: Boolean,
                default: true
            },
        },
        methods: {
            toggleMarked(){
                this.marked = !this.marked
            }
        }
    }
</script>