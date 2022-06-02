<template>
  <div>
    <img alt="Vue logo" src="./assets/logo.png">
    <HelloWorld msg="Welcome to Your Vue.js App"/>
  </div>
</template>

<script>
import initializeAppObject from './services/daoProvider'
import HelloWorld from './components/HelloWorld.vue'

export default {
  name: 'App',
  data() {
    return {
      arr: []
    }
  },
  mounted(){
    this.useDaoApp()
  },
  components: {
    HelloWorld
  },
  methods: {
    async useDaoApp(){
      console.log(typeof initializeAppObject)
      var app = await initializeAppObject()
      console.log(app.dao)
      app.dao.llave_invitacion.read().then(llaves => {
        this.arr = llaves
      })

      var app2 = await initializeAppObject()
    }
  }
}
</script>

<style>
#app {
  font-family: Avenir, Helvetica, Arial, sans-serif;
  -webkit-font-smoothing: antialiased;
  -moz-osx-font-smoothing: grayscale;
  text-align: center;
  color: #2c3e50;
  margin-top: 60px;
}
</style>
