export default {
    /**
     * Devuelve un string obtenido del objeto fecha pasado por parámetro
     * con el formato DD/MM/YYYY
     * @param {Date} fecha 
     * @returns String
     */
    formatearFecha(fecha){
        const date = new Date(fecha)
        return date.getUTCDate().toString().padStart(2,'0') + "/" + (date.getMonth() + 1).toString().padStart(2,'0') + "/" + date.getFullYear()
    },
    /**
     * Devuelve un string obtenido del objeto fecha pasado por parámetro
     * con el formato YYYY-MM-DD
     * @param {Date} fecha 
     * @returns String
     */
    formatearFechaAEstandar(fecha){
        const date = new Date(fecha)
        return date.getFullYear() + "-" + (date.getMonth() + 1).toString().padStart(2,'0') + "-" + date.getUTCDate().toString().padStart(2,'0')
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
            case 'Tutores':
                return 'bg-pink-600 bg-opacity-70 rounded px-1 font-semibold w-28 text-center'
            case 'admin':
                return 'bg-blue-600 bg-opacity-70 rounded px-1 font-semibold w-28 text-center'
        }
    },
}