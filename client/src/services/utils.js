export default {
    /**
     * Devuelve el objeto fecha 
     * @param {Date} fecha 
     * @returns String
     */
    formatearFecha(fecha){
        const date = new Date(fecha)
        return date.getUTCDate().toString().padStart(2,'0') + "/" + (date.getMonth() + 1).toString().padStart(2,'0') + "/" + date.getFullYear()
    }
}