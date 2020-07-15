package bma.amine.clinica

import android.animation.ObjectAnimator
import android.content.Context
import android.os.Bundle
import androidx.fragment.app.Fragment
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import android.view.animation.Animation
import android.widget.Toast
import androidx.core.os.bundleOf
import androidx.navigation.findNavController
import kotlinx.android.synthetic.main.fragment_validate_account.*
import org.json.JSONObject
import retrofit2.Call
import retrofit2.Callback
import retrofit2.Response

class ValidateAccount : Fragment() {

    override fun onCreateView(
        inflater: LayoutInflater, container: ViewGroup?,
        savedInstanceState: Bundle?
    ): View? {
        // Inflate the layout for this fragment
        return inflater.inflate(R.layout.fragment_validate_account, container, false)
    }

    override fun onActivityCreated(savedInstanceState: Bundle?) {
        super.onActivityCreated(savedInstanceState)

        val logoAnimator = ObjectAnimator.ofFloat(logoConfirmAccount, View.TRANSLATION_Y, 30f)
        logoAnimator.repeatCount = Animation.INFINITE
        logoAnimator.repeatMode = ObjectAnimator.REVERSE
        logoAnimator.duration = 1500
        logoAnimator.start()

        btnValidateAccount.setOnClickListener {
            val compte = AccountValidation(
                arguments?.getString("phoneNumber", "")!!,
                Integer.parseInt(activationCode.editText?.text.toString()),
                arguments?.getString("sid", "")!!
            )
            val call = RetrofitService.endpoint.validateAccount(compte)
            call.enqueue(object : Callback<String> {
                override fun onFailure(call: Call<String>, t: Throwable) {
                    Toast.makeText(context, "Une erreur s'est produite", Toast.LENGTH_SHORT)
                        .show()
                }

                override fun onResponse(call: Call<String>, response: Response<String>) {
                    if (response.isSuccessful) {
                        val bundle = bundleOf(
                            "id" to response.body(),
                            "firstName" to arguments?.getString("firstName"),
                            "lastName" to arguments?.getString("lastName"),
                            "address" to arguments?.getString("address"),
                            "phoneNumber" to arguments?.getString("phoneNumber")
                        )
                        val pref =
                            requireActivity().getSharedPreferences("appData", Context.MODE_PRIVATE)
                        pref.edit()
                            .putBoolean("isConnected", true)
                            .putBoolean("isMedecin", false)
                            .putString("id", response.body())
                            .putString("firstName", arguments?.getString("firstName"))
                            .putString("lastName", arguments?.getString("lastName"))
                            .putString("address", arguments?.getString("address"))
                            .putString("phoneNumber", arguments?.getString("phoneNumber"))
                            .apply()
                        //requireActivity().findNavController(R.id.navhost).navigate(R.id.action_confirmInscription_to_accueilPatient2, bundle)
                    }
                }
            })
        }
    }
}
