package bma.amine.clinica

import androidx.room.Dao
import androidx.room.Insert
import androidx.room.Query

@Dao
interface RequestDAO {
    @Insert
    fun addTmpRequest(request: RequestTmp): Long

    @Query("DELETE FROM Requests WHERE id = :tmpRequestId")
    fun deleteTmpRequest(tmpRequestId: Long)
}