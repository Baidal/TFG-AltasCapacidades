<template>
  <div class="relative min-h-screen">
    <div class="pb-60">
      <NavBar />      
      <router-view/>
    </div>
    <Footer class="absolute bottom-0 w-full h-60"/>
  </div>
</template>

<script>
import Footer from './components/Footer.vue'
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
    NavBar,
    Footer
},
  methods: {
    
  }
}
</script>

<style>

</style>
