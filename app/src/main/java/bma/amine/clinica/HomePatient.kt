package bma.amine.clinica

import android.content.Context
import android.os.Bundle
import androidx.fragment.app.Fragment
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import androidx.navigation.findNavController
import androidx.recyclerview.widget.LinearLayoutManager
import com.google.android.material.dialog.MaterialAlertDialogBuilder
import com.google.android.material.snackbar.Snackbar
import kotlinx.android.synthetic.main.fragment_home_patient.*
import retrofit2.Call
import retrofit2.Callback
import retrofit2.Response

class HomePatient : Fragment() {

    override fun onCreateView(
        inflater: LayoutInflater, container: ViewGroup?,
        savedInstanceState: Bundle?
    ): View? {
        // Inflate the layout for this fragment
        return inflater.inflate(R.layout.fragment_home_patient, container, false)
    }

    override fun onActivityCreated(savedInstanceState: Bundle?) {
        super.onActivityCreated(savedInstanceState)

        loadData()
        patientsList.layoutManager = LinearLayoutManager(requireActivity())

        patient_bottom_navigation.setOnNavigationItemSelectedListener { item ->
            when(item.itemId) {
                R.id.homePagePatient -> {
                    true
                }
                R.id.logoutPatient -> {
                    MaterialAlertDialogBuilder(context)
                        .setTitle("Déconnexion")
                        .setMessage("Voulez-vous vous déconnecter ?")
                        .setNeutralButton("Annuler") { dialog, which ->
                        }
                        .setPositiveButton("Confirmer") { dialog, which ->
                            val prefs = requireActivity().getSharedPreferences("clinicaData", Context.MODE_PRIVATE)
                            prefs.edit().clear().apply()
                            requireActivity().findNavController(R.id.navhost).navigate(R.id.action_homePatient_to_login)
                        }
                        .show()
                    true
                }
                else -> false
            }
        }
    }

    fun loadData(){
        val call = RetrofitService.endpoint.getDoctors()
        call.enqueue(object: Callback<ArrayList<Doctor>> {
            override fun onFailure(call: Call<ArrayList<Doctor>>, t: Throwable) {
                Snackbar.make(requireView(), "Une erreur s'est produite.", Snackbar.LENGTH_INDEFINITE)
                    .setAction("D'accord"){}
                    .show()
            }

            override fun onResponse(call: Call<ArrayList<Doctor>>, response: Response<ArrayList<Doctor>>) {
                if(response.isSuccessful){
                    val list = response.body()
                    patientsList.adapter = DoctorAdapter(requireActivity(), list!!)
                }else{
                    Snackbar.make(requireView(), "Une erreur s'est produite.", Snackbar.LENGTH_INDEFINITE)
                        .setAction("D'accord"){}
                        .show()
                }
            }
        })
    }
}
