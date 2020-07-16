package bma.amine.clinica

import android.animation.ObjectAnimator
import android.os.Bundle
import androidx.fragment.app.Fragment
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import android.view.animation.Animation
import androidx.core.os.bundleOf
import androidx.navigation.findNavController
import com.google.android.material.snackbar.Snackbar
import kotlinx.android.synthetic.main.fragment_login.topAppBar
import kotlinx.android.synthetic.main.fragment_sign_up.*
import retrofit2.Call
import retrofit2.Callback
import retrofit2.Response

class SignUp : Fragment() {

    override fun onCreateView(
        inflater: LayoutInflater, container: ViewGroup?,
        savedInstanceState: Bundle?
    ): View? {
        // Inflate the layout for this fragment
        return inflater.inflate(R.layout.fragment_sign_up, container, false)
    }

    override fun onActivityCreated(savedInstanceState: Bundle?) {
        super.onActivityCreated(savedInstanceState)

        val logoAnimator = ObjectAnimator.ofFloat(logoSignUp,View.TRANSLATION_Y, 30f)
        logoAnimator.repeatCount = Animation.INFINITE
        logoAnimator.repeatMode = ObjectAnimator.REVERSE
        logoAnimator.duration = 1500
        logoAnimator.start()

        signUpTopAppBar.setNavigationOnClickListener {
            requireActivity().findNavController(R.id.navhost).navigate(R.id.action_signUp_to_login)
        }

        btnValidateSignUp.setOnClickListener {
            val patient = Patient(
                null,
                firstName.editText?.text.toString(),
                lastName.editText?.text.toString(),
                address.editText?.text.toString(),
                phoneNumberSignUp.editText?.text.toString(),
                mail.editText?.text.toString()
            )

            val call = RetrofitService.endpoint.signUp(patient)
            call.enqueue(object: Callback<String> {
                override fun onFailure(call: Call<String>, t: Throwable) {
                    Snackbar.make(requireView(), "Une erreur s'est produite.", Snackbar.LENGTH_INDEFINITE)
                        .setAction("D'accord"){}
                        .show()
                }

                override fun onResponse(call: Call<String>, response: Response<String>) {
                    if(response.isSuccessful){
                        val bundle = bundleOf(
                            "firstName" to patient.firstName,
                            "lastName" to patient.lastName,
                            "address" to patient.address,
                            "phoneNumber" to patient.phoneNumber,
                            "sid" to response.body())
                        requireActivity().findNavController(R.id.navhost).navigate(R.id.action_signUp_to_validateAccount, bundle)
                    }
                }

            })
        }
    }
}
