package bma.amine.clinica

import android.content.Context
import android.os.Bundle
import androidx.fragment.app.Fragment
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import android.view.WindowManager
import androidx.navigation.findNavController
import com.bumptech.glide.Glide
import com.bumptech.glide.load.engine.DiskCacheStrategy
import com.google.android.material.dialog.MaterialAlertDialogBuilder
import com.google.android.material.snackbar.Snackbar
import com.google.firebase.messaging.Constants.MessagePayloadKeys.SENDER_ID
import com.google.firebase.messaging.FirebaseMessaging
import com.google.firebase.messaging.RemoteMessage
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

        if(arguments?.getString("requestPicture", "") != "")
            Glide.with(requireActivity()).load("${ServerUrl.url}/images/${arguments?.getString("requestPicture")}")
                .timeout(Int.MAX_VALUE)
                .diskCacheStrategy(DiskCacheStrategy.RESOURCE)
                .into(requestPatientImage)
        else
            requestPatientImage.setImageResource(R.drawable.patient)
        requestPatientFullName.text = "${arguments?.getString("firstName","")} ${arguments?.getString("lastName","")}"
        for(symptom in arguments?.getStringArray("symptoms")!!)
            requestSymptoms.text = "${requestSymptoms.text}\n- ${symptom}"
        requestTreatments.text = "Traitements:\n${arguments?.getString("treatments", "")}"

        answerRequestAppBar.setNavigationOnClickListener {
            requireActivity().findNavController(R.id.navhost).navigate(R.id.action_answerRequest_to_homeDoctor)
        }

        answerRequestAppBar.setOnMenuItemClickListener { menuItem ->
            when (menuItem.itemId) {
                R.id.validateAnswer -> {
                    if(answer.editText?.text.toString() == "")
                        MaterialAlertDialogBuilder(requireActivity())
                            .setTitle("Diagnostique manquant")
                            .setMessage("Veuillez rédiger un diagnostique.")
                            .setPositiveButton("D'accord") { dialog, which -> }
                            .show()
                    else{
                        val requestAnswer = Answer(arguments?.getString("requestId","")!!, answer.editText?.text.toString())
                        val call = RetrofitService.endpoint.answerRequest(requestAnswer)
                        call.enqueue(object: Callback<String> {
                            override fun onFailure(call: Call<String>, t: Throwable) {
                                Snackbar.make(requireView(), "Une erreur s'est produite.", Snackbar.LENGTH_INDEFINITE)
                                    .setAction("D'accord"){}
                                    .show()
                            }

                            override fun onResponse(call: Call<String>, response: Response<String>) {
                                if(response.isSuccessful){
                                    Snackbar.make(requireView(), "Réponse envoyée !", Snackbar.LENGTH_SHORT)
                                        .setAction("D'accord"){}
                                        .show()
//                                    val fm = FirebaseMessaging.getInstance()
//                                    fm.send(
//                                        RemoteMessage.Builder("${requireActivity().getSharedPreferences("clinicaData", Context.MODE_PRIVATE).getString("FCM","")}@fcm.googleapis.com")
//                                        .setMessageId(response.body()!!)
//                                        .addData("Message", "Vous avez reçu une réponse !")
//                                        .addData("my_action", "SAY_HELLO")
//                                        .build())
                                    requireActivity().findNavController(R.id.navhost).navigate(R.id.action_answerRequest_to_homeDoctor)
                                }
                            }
                        })
                    }
                    true
                }
                else -> false
            }
        }
    }
}
