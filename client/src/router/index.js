import { createRouter, createWebHistory } from 'vue-router'
import Home from '../views/Home.vue'
import AsignarCuestionariosExpediente from '../views/AsignarCuestionariosExpediente.vue'
import Login from '../views/Login'
import Expedientes from '../views/Expedientes'
import Expediente from '../views/Expediente'

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
  },
  {
    path: '/expedientes',
    name: 'Expedientes',
    component: Expedientes
  },
  {
    path: '/expediente/:id',
    name: 'Expediente',
    component: Expediente,
    props: true
  }
]

const router = createRouter({
  history: createWebHistory(process.env.BASE_URL),
  routes
})

export default router
