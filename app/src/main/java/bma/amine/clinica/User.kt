package bma.amine.clinica

data class User(
    val _id:String?,
    val type: Int,
    val jwt: String,
    val firstName: String,
    val lastName: String,
    val address: String?,
    val phoneNumber: String,
    val mail: String,
    val speciality: String?,
    val picture: String?
)