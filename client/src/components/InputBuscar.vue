<template>
    <div class="flex space-x-2 mx-auto border-2 border-black p-1 rounded-lg w-2/3">
        <SearchIcon class="w-6 h-6" />
        <input
            type="search"
            id="users"
            :placeholder="placeHolder"
            class="w-full focus:outline-none"
            :value="modelValue"
            @input="$emit('update:modelValue', $event.target.value)"
        />
    </div>
</template>

<script>
import {SearchIcon} from '@heroicons/vue/solid'

export default {
    name: 'InputBuscar',
    components: {
        SearchIcon
    },
    props: ['modelValue', 'placeHolder'],
    emits: ['update:modelValue']
}
</script>