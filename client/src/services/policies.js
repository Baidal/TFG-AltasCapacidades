export default {
    emailEsCorrecto(email){
        return email.match(/^\w+([\.-]?\w+)*@\w+([\.-]?\w+)*(\.\w{2,3})+$/)
    },
    telefonoEsCorrecto(telefono){
        return !(telefono != '' && (telefono.length != 9 || !telefono.match(/^\d+$/)))
    },
    dniNieEsCorrecto(dni){
        return !(dni != '' && !(dni.match(/^[0-9]{8}[TRWAGMYFPDXBNJZSQVHLCKE]$/i) || dni.match(/^[XYZ][0-9]{7}[TRWAGMYFPDXBNJZSQVHLCKE]$/i)))
    }
}