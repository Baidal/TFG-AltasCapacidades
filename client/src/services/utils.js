import {Entropy, charset32} from 'entropy-string'

/**
 * Por alguna razón, al obtener la fecha de la base de datos mysql se obtiene un día menos.
 * Añadimos ese día
 */
function obtenerDiaFecha(fecha){
    return (parseInt(fecha.getUTCDate().toString()) + 1).toString().padStart(2,'0')
}

export default {
    /**
     * Devuelve un string obtenido del objeto fecha pasado por parámetro
     * con el formato DD/MM/YYYY
     * @param {Date} fecha 
     * @returns String
     */
    formatearFecha(fecha){
        const date = new Date(fecha)
        return obtenerDiaFecha(date) + "/" + (date.getMonth() + 1).toString().padStart(2,'0') + "/" + date.getFullYear()
    },
    /**
     * Devuelve un string obtenido del objeto fecha pasado por parámetro
     * con el formato YYYY-MM-DD
     * @param {Date} fecha 
     * @returns String
     */
    formatearFechaAEstandar(fecha){
        const date = new Date(fecha)
        return date.getFullYear() + "-" + (date.getMonth() + 1).toString().padStart(2,'0') + "-" + obtenerDiaFecha(date) 
    },
    /**
     * Devuelve un Date obtenido del objeto fecha pasado por parámetro
     * con el formato apto para MYSQL. Si no se pasa nada por parámetro,
     * devuelve un objeto con la fecha actual
     * @param {Date} fecha 
     * @returns Date
     */
    formatearFechaAMysql(fecha){
        if(fecha != null)
            return new Date(fecha).toISOString().slice(0,19).replace('T', ' ')

        return new Date().toISOString().slice(0,19).replace('T', ' ')
    },
    /** Devuelve el css pertinente a cada categoría
     * 
     * @param {String} category 
     * @returns String
     */
    getCategoryClass(category){
        switch(category){
            case 'Psicólogos':
                return 'bg-purple-600 bg-opacity-70 rounded px-1 font-semibold w-28 text-center'
            case 'Psicologos':
                return 'bg-purple-600 bg-opacity-70 rounded px-1 font-semibold w-28 text-center'
            case 'Tutores':
                return 'bg-pink-600 bg-opacity-70 rounded px-1 font-semibold w-28 text-center'
            case 'admin':
                return 'bg-blue-600 bg-opacity-70 rounded px-1 font-semibold w-28 text-center'
        }
    },
    userIsPsicologo(userId){
        return userId == 1
    },
    userIsAdmin(userId){
        return userId == 3
    },
    userIsTutor(userId){
        return userId == 2
    },
    userIsCentro(userId){
        return userId == 4
    },
    generarContrasenyaAleatoria(){
        const random = new Entropy({ bits: 60, charset: charset32 })
        const string = random.string()
        return string
    },
    usuarioEstaVetado(idUsuario){
        return idUsuario == 3
    },
    usuarioEstaInactivo(idUsuario){
        return idUsuario == 2
    }
}