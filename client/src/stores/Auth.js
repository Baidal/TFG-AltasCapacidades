import { defineStore } from 'pinia'
import {toRaw} from 'vue'

import initializeAppObject from '../services/daoProvider'

const actualUser = JSON.parse(localStorage.getItem("user"));
const User = actualUser ? actualUser : {}

const actualToken = localStorage.getItem('token')
const Token = actualToken ? actualToken : ''

export const useAuthStore = defineStore('Auth', {
    state: () => {
        return {
            user: User,
            app: {},
            token: Token
        }
    },
    actions: {
        async login(email, password){
            try{
                const {App, userId, token} = await initializeAppObject(email,password)

                this.app = App
                this.token = token
                
                if(App !== null && userId !== null){
                    this.user = await App.dao.usuario.read(userId)
                    this.user.categoria = await App.dao.rol.read(this.user.rol_id)
                    localStorage.setItem('user', JSON.stringify(this.user))
                    localStorage.setItem('token', this.token)
                    return true
                }

                return false
            }catch(err){
                console.log("Error: ", err)
                return false
            }
        }
    },
    getters: {
        appIsInitialized(){
            const appObjectIsInitialized = !(this.app && Object.keys(this.app).length === 0 && Object.getPrototypeOf(this.app) === Object.prototype)
            return appObjectIsInitialized
        },
        userIsLoggedIn(){
            const userObjectIsInitialized = !(this.user && Object.keys(this.user).length === 0 && Object.getPrototypeOf(this.user) === Object.prototype)

            return userObjectIsInitialized// && appObjectIsInitialized
        },
        getUser(){
            return this.user
        },
        async App(){
            //Si el objeto app no está inicializado pero hay token, iniciamos sesión con el token 
            if(!this.appIsInitialized )
                if(this.token){
                    const {App, _, __} = await initializeAppObject('', '', this.token)
                    this.app = App
                }else
                    //Si el objeto app es falso y no existe el token, no se puede iniciar sesión
                    return false       

            return toRaw(this.app)
        }
    }
})