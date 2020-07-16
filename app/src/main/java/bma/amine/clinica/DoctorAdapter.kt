package bma.amine.clinica

import android.content.Context
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import android.widget.ImageView
import android.widget.TextView
import androidx.core.os.bundleOf
import androidx.navigation.findNavController
import androidx.recyclerview.widget.RecyclerView
import com.bumptech.glide.Glide
import com.bumptech.glide.load.engine.DiskCacheStrategy
import com.google.android.material.button.MaterialButton

class DoctorAdapter (var context: Context, var data:ArrayList<Doctor>): RecyclerView.Adapter<DoctorViewHolder>(){
    override fun onCreateViewHolder(parent: ViewGroup, viewType: Int): DoctorViewHolder {
        return DoctorViewHolder(LayoutInflater.from(context).inflate(R.layout.doctor_layout, parent, false))
    }

    override fun getItemCount() = data.size

    override fun onBindViewHolder(holder: DoctorViewHolder, position: Int) {
        if(data[position].picture != null)
            Glide.with(context).load("${ServerUrl.url}/images/${data[position].picture}")
                .timeout(Int.MAX_VALUE)
                .diskCacheStrategy(DiskCacheStrategy.RESOURCE)
                .into(holder.picture)
        else
            holder.picture.setImageResource(R.drawable.patient)
        holder.fullName.text = "${data[position].firstName} ${data[position].lastName}"
        holder.speciality.text = "${data[position].speciality}"
        holder.phoneNumber.text = "${data[position].phoneNumber}"
        holder.askBtn.setOnClickListener { view ->
            val bundle = bundleOf(
                "doctorId" to data[position]._id,
                "firstName" to data[position].firstName,
                "lastName" to data[position].lastName,
                "doctorPicture" to data[position].picture,
                "speciality" to data[position].speciality,
                "phoneNumber" to data[position].phoneNumber
            )
            view.findNavController().navigate(R.id.action_homePatient_to_newRequest, bundle)
        }
    }

}

class DoctorViewHolder(view: View): RecyclerView.ViewHolder(view) {
    val picture = view.findViewById(R.id.doctorPicture) as ImageView
    val fullName = view.findViewById(R.id.doctorFullName) as TextView
    val speciality = view.findViewById(R.id.doctorSpeciality) as TextView
    val phoneNumber = view.findViewById(R.id.doctorPhoneNumber) as TextView
    val askBtn = view.findViewById(R.id.btnAskDiagnostic) as MaterialButton
}