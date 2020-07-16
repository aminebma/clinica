package bma.amine.clinica

import androidx.room.Entity
import androidx.room.PrimaryKey

@Entity(tableName= "Requests")
data class RequestTmp(
    val date: String,
    val patientId: String,
    val doctorId: String,
    val patientFirstName: String?,
    val patientLastName: String?,
    val symptoms: List<String>,
    val treatments: String?,
    val picture: String?
) {
    @PrimaryKey(autoGenerate = true)
    var id:Int?=null
}