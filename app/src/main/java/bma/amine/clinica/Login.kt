package bma.amine.clinica

import android.animation.ObjectAnimator
import android.content.Context
import android.os.Bundle
import androidx.fragment.app.Fragment
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import android.view.animation.Animation
import android.view.animation.RotateAnimation
import android.widget.Toast
import androidx.core.os.bundleOf
import androidx.navigation.findNavController
import kotlinx.android.synthetic.main.fragment_login.*
import org.json.JSONObject
import retrofit2.Call
import retrofit2.Callback
import retrofit2.Response

class Login : Fragment() {

    override fun onCreateView(
        inflater: LayoutInflater, container: ViewGroup?,
        savedInstanceState: Bundle?
    ): View? {
        // Inflate the layout for this fragment
        var pref = requireActivity().getSharedPreferences("clinicaData", Context.MODE_PRIVATE)
        if(pref.getBoolean("isConnected", false)){
            //if(pref.getBoolean("isDoctor", false))
                //requireActivity().findNavController(R.id.navhost).navigate(R.id.action_choixCompte_to_accueilMedecin)
            //else
                //requireActivity().findNavController(R.id.navhost).navigate(R.id.action_choixCompte_to_accueilPatient2)
        }

        return inflater.inflate(R.layout.fragment_login, container, false)
    }
    override fun onActivityCreated(savedInstanceState: Bundle?) {
        super.onActivityCreated(savedInstanceState)

        val logoAnimator = ObjectAnimator.ofFloat(logoLogin,View.TRANSLATION_Y, 30f)
        logoAnimator.repeatCount = Animation.INFINITE
        logoAnimator.repeatMode = ObjectAnimator.REVERSE
        logoAnimator.duration = 1500
        logoAnimator.start()

        btnLogin.setOnClickListener {
            val compte = Account(phoneNumber.editText?.text.toString(), password.editText?.text.toString())
            val call = RetrofitService.endpoint.signIn(compte)
            call.enqueue(object: Callback<User> {
                override fun onFailure(call: Call<User>, t: Throwable) {
                    Toast.makeText(context, "Une erreur s'est produite", Toast.LENGTH_SHORT)
                        .show()
                }

                override fun onResponse(call: Call<User>, response: Response<User>) {
                    if(response.isSuccessful){
                        if(response.body()?.type == 0){
                            val patient = response.body()
                            val bundle = bundleOf(
                                "id" to patient!!._id,
                                "firstName" to patient.firstName,
                                "lastName" to patient.lastName,
                                "address" to patient.address,
                                "numtel" to patient.phoneNumber)
                            var pref = requireActivity().getSharedPreferences("clinicaData", Context.MODE_PRIVATE)
                            pref.edit()
                                .putBoolean("isConnected", true)
                                .putBoolean("isDoctor",false)
                                .putString("jwt", patient.jwt)
                                .putString("id", patient._id)
                                .putString("firstName", patient.firstName)
                                .putString("lastName", patient.lastName)
                                .putString("address", patient.address)
                                .putString("phoneNumber", patient.phoneNumber)
                                .apply()
                            //requireActivity().findNavController(R.id.navhost).navigate(R.id.action_login_to_accueilPatient2, bundle)
                        }
                        else{
                            val doctor = response.body()
                            val bundle = bundleOf(
                                "id" to doctor!!._id,
                                "firstName" to doctor.firstName,
                                "lastName" to doctor.lastName,
                                "speciality" to doctor.speciality,
                                "numtel" to doctor.phoneNumber
                            )
                            var pref = requireActivity().getSharedPreferences("clinicaData", Context.MODE_PRIVATE)
                            pref.edit()
                                .putBoolean("isConnected", true)
                                .putBoolean("isDoctor", true)
                                .putString("jwt", doctor.jwt)
                                .putString("id", doctor._id)
                                .putString("firstName", doctor.firstName)
                                .putString("lastName", doctor.lastName)
                                .putString("address", doctor.speciality)
                                .putString("phoneNumber", doctor.phoneNumber)
                                .apply()
                            //requireActivity().findNavController(R.id.navhost)
                                //.navigate(R.id.action_loginMedecin_to_accueilMedecin, bundle)
                        }
                    }
                }

            })
        }

        btnSignUp.setOnClickListener {
            requireActivity().findNavController(R.id.navhost).navigate(R.id.action_login_to_signUp)
        }
    }

}
