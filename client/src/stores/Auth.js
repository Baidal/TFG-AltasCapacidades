import { defineStore } from 'pinia'
import initializeAppObject from '../services/daoProvider'

export const useAuthStore = defineStore('Auth', {
    state: () => {
        return {
            user: {}
        }
    },
    actions: {
        async login(email, password){
            try{
                const {App, userId} = await initializeAppObject(email,password)
                
                if(App !== null && userId !== null){
                    this.user = await App.dao.usuario.read(userId)
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
        userIsLoggedIn(){
            const userObjectIsInitialized = !(this.user && Object.keys(this.user).length === 0 && Object.getPrototypeOf(this.user) === Object.prototype)

            return userObjectIsInitialized
        },
        async getApp(){
            const {App, _} = await initializeAppObject()
            return this.userIsLoggedIn ? App : false 
        },
        getUser(){
            return this.user
        }
    }
})