<template>
  <button
    class="border-2 border-black p-1 rounded-md font-bold hover:bg-gray-200 bg-white"
  >
    {{this.name}}
  </button>
</template>

<script>
export default {
  name: "AppButton",
  props: {
    name: "",
  },
};
</script>
