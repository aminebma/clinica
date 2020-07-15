package bma.amine.clinica

import android.content.Context
import android.os.Bundle
import androidx.fragment.app.Fragment
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import androidx.navigation.findNavController
import com.google.android.material.dialog.MaterialAlertDialogBuilder
import kotlinx.android.synthetic.main.fragment_home_doctor.*

class HomeDoctor : Fragment() {

    override fun onCreateView(
        inflater: LayoutInflater, container: ViewGroup?,
        savedInstanceState: Bundle?
    ): View? {
        // Inflate the layout for this fragment
        return inflater.inflate(R.layout.fragment_home_doctor, container, false)
    }

    override fun onActivityCreated(savedInstanceState: Bundle?) {
        super.onActivityCreated(savedInstanceState)

        doctor_bottom_navigation.setOnNavigationItemSelectedListener { item ->
            when(item.itemId) {
                R.id.homePageDoctor -> {
                    requireActivity().findNavController(R.id.doctorNavhost).navigate(R.id.action_dashboard_to_homeUnderDoctor)
                    true
                }
                R.id.dashboardDoctor -> {
                    requireActivity().findNavController(R.id.doctorNavhost).navigate(R.id.action_homeUnderDoctor_to_dashboard)
                    true
                }
                R.id.logoutDoctor -> {
                    MaterialAlertDialogBuilder(context)
                        .setTitle("Déconnexion")
                        .setMessage("Voulez-vous vous déconnecter ?")
                        .setNeutralButton("Annuler") { dialog, which ->
                        }
                        .setPositiveButton("Confirmer") { dialog, which ->
                            val prefs = requireActivity().getSharedPreferences("clinicaData", Context.MODE_PRIVATE)
                            prefs.edit().clear().apply()
                            requireActivity().findNavController(R.id.navhost).navigate(R.id.action_homeDoctor_to_login)
                        }
                        .show()
                    true
                }
                else -> false
            }
        }
    }
}
