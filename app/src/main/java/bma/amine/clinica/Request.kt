package bma.amine.clinica

data class Request(
    val _id:String?,
    val date: String,
    val patientId: String,
    val doctorId: String,
    val firstName: String?,
    val lastName: String?,
    val symptoms: Array<String>,
    val treatements: String?,
    val picture: String?,
    val status: String?
)