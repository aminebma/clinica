package bma.amine.clinica

import androidx.room.Entity
import androidx.room.PrimaryKey

@Entity(tableName= "Requests")
data class RequestTmp(
    val Idp: String,
    val Idm: String,
    val nomPatient: String?,
    val prenomPatient: String?,
    val symptomes: List<String>,
    val traitements: String?,
    val date: String,
    val photo: String?,
    val etat: String?
) {
    @PrimaryKey(autoGenerate = true)
    var id:Int?=null
}