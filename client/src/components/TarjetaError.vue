<template>
    <div class="border-2 border-red-700 bg-red-50 rounded-md text-center p-3 text-sm ">
        {{error}}
    </div>
</template>

<script>
export default {
    name: 'TarjetaError',
    props: {
        error: ''
    }
}
</script>