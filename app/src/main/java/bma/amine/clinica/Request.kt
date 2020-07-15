package bma.amine.clinica

import java.util.*

data class Request(
    val _id:String?,
    val Idp: String,
    val Idm: String,
    val nomPatient: String?,
    val prenomPatient: String?,
    val symptomes: Array<String>,
    val traitements: String?,
    val date: String,
    val photo: String?,
    val etat: String?
)