package bma.amine.clinica

import android.content.Context
import android.os.Build
import android.os.Bundle
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import android.widget.CompoundButton
import androidx.annotation.RequiresApi
import androidx.fragment.app.Fragment
import androidx.navigation.findNavController
import androidx.recyclerview.widget.LinearLayoutManager
import com.google.android.material.chip.Chip
import com.google.android.material.chip.ChipGroup
import com.google.android.material.dialog.MaterialAlertDialogBuilder
import com.google.android.material.snackbar.Snackbar
import kotlinx.android.synthetic.main.fragment_home_patient.*
import retrofit2.Call
import retrofit2.Callback
import retrofit2.Response


class HomePatient : Fragment() {

    lateinit var list:ArrayList<Doctor>
    val chipStatus = mutableMapOf<Int,Boolean>()
    val filter = mutableListOf<String>()

    override fun onCreateView(
        inflater: LayoutInflater, container: ViewGroup?,
        savedInstanceState: Bundle?
    ): View? {
        // Inflate the layout for this fragment
        return inflater.inflate(R.layout.fragment_home_patient, container, false)
    }

    @RequiresApi(Build.VERSION_CODES.N)
    override fun onActivityCreated(savedInstanceState: Bundle?) {
        super.onActivityCreated(savedInstanceState)

        loadData()
        patientsList.layoutManager = LinearLayoutManager(requireActivity())

        val chipIds = getChipIds(specialitiesChips)

        for(chipId in chipIds){
            chipStatus.put(chipId, false)
            val specialityChip: Chip = specialitiesChips.findViewById(chipId)

            specialityChip.setOnClickListener {
                if(!chipStatus.get(specialityChip.id)!!){
                    filter.add(specialityChip.text.toString())
                    chipStatus.replace(specialityChip.id, true)
                }
                else{
                    filter.remove(specialityChip.text.toString())
                    chipStatus.replace(specialityChip.id, false)
                }
                if(filter.size == 0)
                    patientsList.adapter = DoctorAdapter(requireActivity(), list)
                else{
                    val filteredList = list.filter { filter.contains(it.speciality) }
                    patientsList.adapter = DoctorAdapter(requireActivity(), filteredList as ArrayList<Doctor>)
                }
            }
        }

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
                    list = response.body()!!
                    patientsList.adapter = DoctorAdapter(requireActivity(), list!!)
                }else{
                    Snackbar.make(requireView(), "Une erreur s'est produite.", Snackbar.LENGTH_INDEFINITE)
                        .setAction("D'accord"){}
                        .show()
                }
            }
        })
    }

    fun getChipIds(chipGroup: ChipGroup): List<Int> {
        val checkedIds: ArrayList<Int> = ArrayList()
        for (i in 0 until chipGroup.childCount) {
            val child: View = chipGroup.getChildAt(i)
            if (child is Chip) {
                    checkedIds.add(child.getId())
            }
        }
        return checkedIds
    }
}
