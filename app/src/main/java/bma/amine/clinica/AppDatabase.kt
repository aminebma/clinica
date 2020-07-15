package bma.amine.clinica

import androidx.room.Database
import androidx.room.RoomDatabase
import androidx.room.TypeConverters

@Database(entities = arrayOf(RequestTmp::class), version = 1)
@TypeConverters(Converters::class)
abstract class AppDatabase: RoomDatabase() {

}