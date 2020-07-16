package bma.amine.clinica

import android.content.Context
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import android.widget.ImageView
import android.widget.TextView
import androidx.appcompat.app.AppCompatActivity
import androidx.core.os.bundleOf
import androidx.navigation.findNavController
import androidx.recyclerview.widget.RecyclerView
import com.bumptech.glide.Glide
import com.bumptech.glide.load.engine.DiskCacheStrategy
import com.google.android.material.button.MaterialButton


class RequestAdapter (var context: Context, var data:List<Request>): RecyclerView.Adapter<RequestViewHolder>(){
    override fun onCreateViewHolder(parent: ViewGroup, viewType: Int): RequestViewHolder {
        return RequestViewHolder(LayoutInflater.from(context).inflate(R.layout.request_layout, parent, false))
    }

    override fun getItemCount() = data.size

    override fun onBindViewHolder(holder: RequestViewHolder, position: Int) {
        if(data[position].picture != null)
            Glide.with(context).load("${ServerUrl.url}/images/${data[position].picture}")
                .timeout(Int.MAX_VALUE)
                .diskCacheStrategy(DiskCacheStrategy.RESOURCE)
                .into(holder.picture)
        else
            holder.picture.setImageResource(R.drawable.patient)
        holder.fullName.text = "${data[position].patientFirstName} ${data[position].patientLastName}"
        holder.date.text = "${data[position].date.subSequence(0,10)}"
        holder.symptoms.text = "Symptômes:"
        for(symptom in data[position].symptoms)
            holder.symptoms.text = holder.symptoms.text.toString() + "\n- ${symptom}"
        holder.treatments.text = "Traitements actuels: ${data[position].treatments}"
        holder.answerBtn.setOnClickListener { view ->
            val bundle = bundleOf(
                "requestId" to data[position]._id,
                "patientId" to data[position].patientId,
                "firstName" to data[position].patientFirstName,
                "lastName" to data[position].patientLastName,
                "symptoms" to data[position].symptoms,
                "treatments" to data[position].treatments,
                "requestPicture" to data[position].picture
            )
            (context as AppCompatActivity).findNavController(R.id.navhost).navigate(R.id.action_homeDoctor_to_answerRequest, bundle)
        }
    }
}

class RequestViewHolder(view: View):RecyclerView.ViewHolder(view) {
    val picture = view.findViewById(R.id.requestPicture) as ImageView
    val fullName = view.findViewById(R.id.patientFullName) as TextView
    val date = view.findViewById(R.id.requestDate) as TextView
    val symptoms = view.findViewById(R.id.requestSymptoms) as TextView
    val treatments = view.findViewById(R.id.requestTreatments) as TextView
    val answerBtn = view.findViewById(R.id.btnAnswerRequest) as MaterialButton
}