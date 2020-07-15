package bma.amine.clinica

import android.app.Application

class App:Application() {
    override fun onCreate() {
        super.onCreate()
        RoomService.context = applicationContext
    }
}