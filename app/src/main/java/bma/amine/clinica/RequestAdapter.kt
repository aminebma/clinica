package bma.amine.clinica

import android.content.Context
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import android.widget.ImageView
import android.widget.TextView
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
            Glide.with(context).load("http://192.168.43.191:3000/images/${data[position].picture}")
                .timeout(Int.MAX_VALUE)
                .diskCacheStrategy(DiskCacheStrategy.RESOURCE)
                .into(holder.picture)
        else
            holder.picture.setImageResource(R.drawable.patient)
        holder.fullName.text = "${data[position].firstName} ${data[position].lastName}"
        holder.date.text = "${data[position].date}"
        holder.symptoms.text = "Symptômes:"
        for(symptom in data[position].symptoms)
            holder.symptoms.text = holder.symptoms.text.toString() + "\n- ${symptom}"
        holder.treatments.text = "Traitements actuels: ${data[position].treatements}"
        holder.answerBtn.setOnClickListener { view ->

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