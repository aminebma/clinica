package bma.amine.clinica

import android.os.Bundle
import androidx.fragment.app.Fragment
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import androidx.navigation.findNavController
import com.google.android.material.snackbar.Snackbar
import kotlinx.android.synthetic.main.fragment_answer_request.*
import retrofit2.Call
import retrofit2.Callback
import retrofit2.Response

class AnswerRequest : Fragment() {

    override fun onCreateView(
        inflater: LayoutInflater, container: ViewGroup?,
        savedInstanceState: Bundle?
    ): View? {
        // Inflate the layout for this fragment
        return inflater.inflate(R.layout.fragment_answer_request, container, false)
    }

    override fun onActivityCreated(savedInstanceState: Bundle?) {
        super.onActivityCreated(savedInstanceState)

        requestPatientFullName.text = "${arguments?.getString("firstName","")} ${arguments?.getString("lastName","")}"
        for(symptom in arguments?.getStringArray("symptoms")!!)
            requestSymptoms.text = "${requestSymptoms.text}\n- ${symptom}"
        requestTreatments.text = "Traitements:\n${arguments?.getString("treatments", "")}"
        answerRequestAppBar.setOnMenuItemClickListener { menuItem ->
            when (menuItem.itemId) {
                R.id.validateAnswer -> {
                    val requestAnswer = Answer(arguments?.getString("patientId","")!!, answer.editText?.text.toString())
                    val call = RetrofitService.endpoint.answerRequest(requestAnswer)
                    call.enqueue(object: Callback<String> {
                        override fun onFailure(call: Call<String>, t: Throwable) {
                            Snackbar.make(requireView(), "Une erreur s'est produite.", Snackbar.LENGTH_INDEFINITE)
                                .setAction("D'accord"){}
                                .show()
                        }

                        override fun onResponse(call: Call<String>, response: Response<String>) {
                            if(response.isSuccessful){
                                requireActivity().findNavController(R.id.navhost).navigate(R.id.action_answerRequest_to_homeDoctor)
                            }
                        }
                    })
                    true
                }
                else -> false
            }
        }
    }
}
