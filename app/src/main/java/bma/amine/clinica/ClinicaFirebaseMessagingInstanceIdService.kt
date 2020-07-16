package bma.amine.clinica

import android.content.Context
import com.google.android.gms.tasks.OnCompleteListener
import com.google.firebase.iid.FirebaseInstanceId
import com.google.firebase.iid.FirebaseInstanceIdService

class ClinicaFirebaseMessagingInstanceIdService: FirebaseInstanceIdService() {
    override fun onTokenRefresh() {
        super.onTokenRefresh()
        FirebaseInstanceId.getInstance().instanceId
            .addOnCompleteListener(OnCompleteListener { task ->
                if (!task.isSuccessful) {
                    return@OnCompleteListener
                }

                // Get new Instance ID token
                val token = task.result?.token
                val prefs = getSharedPreferences("clinicaData", Context.MODE_PRIVATE)
                prefs.edit().putString("FCM",token).apply()
            })
    }
}