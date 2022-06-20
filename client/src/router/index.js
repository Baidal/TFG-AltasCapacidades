import { createRouter, createWebHistory } from 'vue-router'
import Home from '../views/Home.vue'
import AsignarCuestionariosExpediente from '../views/AsignarCuestionariosExpediente.vue'
import Login from '../views/Login'

const routes = [
  {
    path: '/',
    name: 'Home',
    component: Home
  },
  {
    path: '/crearCuestionario',
    name: 'CrearCuestionario',
    component: AsignarCuestionariosExpediente,
    props: {creandoExpediente: true}
  },
  {
    path: '/login',
    name: 'Login',
    component: Login
  }
]

const router = createRouter({
  history: createWebHistory(process.env.BASE_URL),
  routes
})

export default router
