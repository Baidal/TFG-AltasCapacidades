<template>
    <div>
        <section class="bg-white dark:bg-gray-900">
            <div class="grid py-8 px-4 mx-auto max-w-screen-xl lg:gap-8 xl:gap-0 lg:py-16 lg:grid-cols-12">
                <div class="place-self-center mr-auto lg:col-span-7">
                    <h1 class="mb-4 max-w-2xl text-4xl font-extrabold leading-none md:text-5xl xl:text-6xl dark:text-white">Sistema de gestión de altas capacidades en edades infantiles</h1>
                    <p class="mb-6 max-w-2xl font-light text-gray-500 lg:mb-8 md:text-lg lg:text-xl dark:text-gray-400">Sistema de gestión para la detección de altas capacidades en edades infantiles.</p>
                    <app-button 
                        :name="this.loggedIn ? 'Expedientes' : 'Inicia Sesión'" 
                        @click="this.loggedIn ? this.$router.push({name: 'Expedientes'}) : this.$router.push({name: 'Login'})" 
                        class="inline-flex justify-center items-center py-3 px-5 text-base font-medium text-center text-gray-900 rounded-lg border border-gray-300 hover:bg-gray-100 focus:ring-4 focus:ring-gray-100 dark:text-white dark:border-gray-700 dark:hover:bg-gray-700 dark:focus:ring-gray-800"/>
                </div>
                <div class="hidden lg:mt-0 lg:col-span-5 lg:flex w-72 mx-auto">
                    <img src="../assets/altascapacidadeslogo.png" alt="logo">
                </div>                
            </div>
        </section>

        <section class="bg-gray-50 dark:bg-gray-800">
            <div class="py-8 px-4 mx-auto max-w-screen-xl sm:py-16 lg:px-6">
                <div class="space-y-8 md:grid md:grid-cols-2 lg:grid-cols-3 md:gap-12 md:space-y-0">
                    <div>
                        <div class="flex justify-center items-center mb-4 w-10 h-10 rounded-full bg-primary-100 lg:h-12 lg:w-12 dark:bg-primary-900">
                            <ClipboardListIcon class="w-5 h-5"/>
                        </div>
                        <h3 class="mb-2 text-xl font-bold dark:text-white">Cuestionarios</h3>
                        <p class="text-gray-500 dark:text-gray-400">Realiza cuestionarios sobre los comportamientos observados en los niños.</p>
                    </div>
                    <div>
                        <div class="flex justify-center items-center mb-4 w-10 h-10 rounded-full bg-primary-100 lg:h-12 lg:w-12 dark:bg-primary-900">
                            <UserCircleIcon class="h-5 w-5"/>
                        </div>
                        <h3 class="mb-2 text-xl font-bold dark:text-white">Psicólogos</h3>
                        <p class="text-gray-500 dark:text-gray-400">Los datos recogidos por la aplicación solo serán visibles por los psicólogos, que se encargarán de analizarlos.</p>
                    </div>
                    <div>
                        <div class="flex justify-center items-center mb-4 w-10 h-10 rounded-full bg-primary-100 lg:h-12 lg:w-12 dark:bg-primary-900">
                            <ChartPieIcon class="h-5 w-5"/>
                        </div>
                        <h3 class="mb-2 text-xl font-bold dark:text-white">Análisis de datos</h3>
                        <p class="text-gray-500 dark:text-gray-400">Los datos recogidos a partir de los cuestionarios se utilizarán para detectar posibles indicios de altas capacidades.</p>
                    </div>
                </div>
            </div>
        </section>
        <section class="dark:bg-gray-900 dark:bg-gray-800">
        <div class="py-8 px-4 mx-auto max-w-screen-xl lg:py-16 lg:px-6">
            <div class="max-w-screen-lg text-gray-500 sm:text-lg dark:text-gray-400">
                <h2 class="mb-4 text-4xl font-bold text-gray-900 dark:text-white">¿Cómo funciona?</h2>
                <p class="mb-4 font-medium">La aplicación	utilizará la información recopilada de todos los cuestionarios realizados en un expediente, y los procesará utilizando un <a href="https://es.wikipedia.org/wiki/Sistema_experto" class="underline" target="_blank">sistema experto.</a> Una vez se disponga de los resultados, estos se mostrarán a los psicólogos, que serán los encargados de analizarlos. Los datos recopilados únicamente serán usados para la generación de resultados. En ningún caso se harán públicos, ni se distribuirán.</p>
            </div>
        </div>
        </section>
    </div>
</template>

<script>
import AppButton from '../components/AppButton.vue'
import {ClipboardListIcon, ChartPieIcon, UserCircleIcon} from '@heroicons/vue/solid'

import {mapStores} from 'pinia'
import {useAuthStore} from '../stores/Auth.js'

import Footer from '../components/Footer.vue'

export default {
    name: 'Home',
    components: {
        AppButton,
        ClipboardListIcon,
        ChartPieIcon,
        UserCircleIcon,
        Footer
    },
    computed: {
    ...mapStores(useAuthStore),
    loggedIn(){
        return this.AuthStore.userIsLoggedIn
    }
    }
}
</script>
