package bma.amine.clinica

data class AccountValidation(
    val phoneNumber: String,
    val code: Int,
    val sid: String
)