<template>
  <div>
    <NavBar />
    <div>
      <router-view/>
    </div>
  </div>
</template>

<script>
import initializeAppObject from './services/daoProvider'
import NavBar from './components/NavBar.vue'

export default {
  name: 'App',
  data() {
    return {
    }
  },
  mounted(){
  },
  components: {
    NavBar
},
  methods: {
    
  }
}
</script>

<style>

</style>
