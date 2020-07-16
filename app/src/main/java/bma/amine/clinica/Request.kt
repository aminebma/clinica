package bma.amine.clinica

data class Request(
    val _id:String?,
    val date: String,
    val patientId: String,
    val doctorId: String,
    val patientFirstName: String?,
    val patientLastName: String?,
    val symptoms: Array<String>,
    val treatments: String?,
    val picture: String?,
    val status: String?
)