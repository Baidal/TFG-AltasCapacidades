import { createRouter, createWebHistory } from 'vue-router'
import Home from '../views/Home.vue'
import AsignarCuestionariosExpediente from '../views/AsignarCuestionariosExpediente.vue'
import Login from '../views/Login'
import Expedientes from '../views/Expedientes'
import Expediente from '../views/Expediente'
import Perfil from '../views/Perfil'
import Cuestionario from '../views/Cuestionario'
import ErroresExpediente from '../views/ErroresExpediente'
import Administracion from '../views/Administracion'

const routes = [
  {
    path: '/',
    name: 'Home',
    component: Home
  },
  {
    path: '/crearExpediente',
    name: 'CrearExpediente',
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
  },
  {
    path: '/perfil/:id',
    name: 'Perfil',
    component: Perfil,
    props: true
  },
  {
    path: '/cuestionario/:id',
    name: 'Cuestionario',
    component: Cuestionario,
    props: true
  },
  {
    path: '/expediente/errores',
    name: 'ErroresExpediente',
    component: ErroresExpediente,
    props: true
  },
  {
    path: '/administracion',
    name: 'Administracion',
    component: Administracion
  }
]

const router = createRouter({
  history: createWebHistory(process.env.BASE_URL),
  routes
})

export default router
