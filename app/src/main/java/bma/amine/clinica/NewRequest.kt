package bma.amine.clinica

import android.annotation.SuppressLint
import android.app.Activity
import android.content.Context
import android.content.Intent
import android.net.Uri
import android.os.Bundle
import android.provider.MediaStore
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import androidx.annotation.NonNull
import androidx.annotation.Nullable
import androidx.fragment.app.Fragment
import androidx.navigation.findNavController
import androidx.work.*
import com.bumptech.glide.Glide
import com.bumptech.glide.load.engine.DiskCacheStrategy
import com.google.android.material.chip.Chip
import com.google.android.material.chip.ChipGroup
import com.google.android.material.dialog.MaterialAlertDialogBuilder
import kotlinx.android.synthetic.main.fragment_new_request.*
import java.io.File
import java.io.FileOutputStream
import java.io.IOException
import java.io.OutputStream
import java.text.SimpleDateFormat
import java.util.*
import kotlin.collections.ArrayList

class NewRequest : Fragment() {

    var picturePath: String? = ""
    var uri: String? = ""

    companion object {
        private const val IMAGE_PICK_CODE = 6219
    }

    override fun onCreateView(
        inflater: LayoutInflater, container: ViewGroup?,
        savedInstanceState: Bundle?
    ): View? {
        // Inflate the layout for this fragment
        return inflater.inflate(R.layout.fragment_new_request, container, false)
    }

    @SuppressLint("RestrictedApi")
    override fun onActivityCreated(savedInstanceState: Bundle?) {
        super.onActivityCreated(savedInstanceState)

        if(arguments?.getString("doctorPicture", "") != " ")
            Glide.with(requireActivity()).load("${ServerUrl.url}/images/${arguments?.getString("doctorPicture")}")
                .timeout(Int.MAX_VALUE)
                .diskCacheStrategy(DiskCacheStrategy.RESOURCE)
                .into(requestDoctorPicture)
        else
            requestDoctorPicture.setImageResource(R.drawable.doctor)
        requestDoctorFullName.text = "${arguments?.getString("firstName","")} ${arguments?.getString("lastName","")}"
        requestDoctorSpeciality.text = arguments?.getString("speciality","")
        requestDoctorPhoneNumber.text = arguments?.getString("phoneNumber", "")

        btnUpload.setOnClickListener {
            openGallery()
        }

        newRequestAppBar.setNavigationOnClickListener {
            requireActivity().findNavController(R.id.navhost).navigate(R.id.action_newRequest_to_homePatient)
        }

        newRequestAppBar.setOnMenuItemClickListener { menuItem ->
            when (menuItem.itemId) {
                R.id.validateRequest -> {
                    val selectedSymptoms = getCheckedChipIds(symptomsChips)
                    if(selectedSymptoms.size==0 && otherSymptoms.editText?.text.toString() == "")
                        MaterialAlertDialogBuilder(requireActivity())
                            .setTitle("Symptômes manquants")
                            .setMessage("Veuillez mentionner au moins un symptôme.")
                            .setPositiveButton("D'accord") { dialog, which -> }
                            .show()
                    else{
                        val tmpSymptoms = ArrayList<String>()
                        for(symptom in selectedSymptoms){
                            val symptomChip: Chip = symptomsChips.findViewById(symptom)
                            tmpSymptoms.add(symptomChip.text.toString())
                        }
                        if(otherSymptoms.editText?.text.toString() != "")
                            tmpSymptoms.add(otherSymptoms.editText?.text.toString())
                        else
                            tmpSymptoms.add(" ")
                        var tmpTreatments : String
                        if(requestTreatments.editText?.text.toString() != "")
                            tmpTreatments = requestTreatments.editText?.text.toString()
                        else
                            tmpTreatments = " "

                        val tmpRequest = RequestTmp(
                            SimpleDateFormat("yyyy-MM-dd").format(Date()),
                            requireActivity().getSharedPreferences("clinicaData", Context.MODE_PRIVATE).getString("id","")!!,
                            arguments?.getString("doctorId")!!,
                            requireActivity().getSharedPreferences("clinicaData", Context.MODE_PRIVATE).getString("firstName","")!!,
                            requireActivity().getSharedPreferences("clinicaData", Context.MODE_PRIVATE).getString("lastName",""),
                            tmpSymptoms.toList(),
                            tmpTreatments,
                            picturePath
                        )

                        val tmpRequestId:Long = RoomService.appDatabase.getRequestDAO().addTmpRequest(tmpRequest)
                        val constraints = Constraints.Builder().setRequiredNetworkType(NetworkType.UNMETERED)
                            .build()
                        val data = Data.Builder()
                        data.putLong("tmpRequestId", tmpRequestId)
                        data.putString("picture", uri)
                        data.putString("picturePath", picturePath)
                        data.putString("date", tmpRequest.date)
                        data.putString("patientId", tmpRequest.patientId)
                        data.putString("doctorId", tmpRequest.doctorId)
                        data.putString("patientFirstName", tmpRequest.patientFirstName)
                        data.putString("patientLastName", tmpRequest.patientLastName)
                        data.putStringArray("symptoms", tmpRequest.symptoms.toTypedArray())
                        data.putString("treatments", tmpRequest.treatments)
                        val req = OneTimeWorkRequest.Builder(RequestWorker::class.java)
                            .setConstraints(constraints)
                            .setInputData(data.build())
                            .build()
                        val workManager = WorkManager.getInstance(requireActivity())
                        workManager.enqueueUniqueWork("Adding Request", ExistingWorkPolicy.REPLACE, req)
                        requireActivity().findNavController(R.id.navhost).navigate(R.id.action_newRequest_to_homePatient)
                    }
                    true
                }
                else -> false
            }
        }
    }

    override fun onActivityResult(requestCode: Int, resultCode: Int, data: Intent?) {
        super.onActivityResult(requestCode, resultCode, data)
        if(requestCode == IMAGE_PICK_CODE && resultCode == Activity.RESULT_OK){
            uri = data!!.data!!.toString()
            uploadedImage.setImageURI(data!!.data!!)
            picturePath = createCopyAndReturnRealPath(requireActivity(), data!!.data!!)
        }
    }

    fun getCheckedChipIds(chipGroup: ChipGroup): List<Int> {
        val checkedIds: ArrayList<Int> = ArrayList()
        for (i in 0 until chipGroup.childCount) {
            val child: View = chipGroup.getChildAt(i)
            if (child is Chip) {
                if (child.isChecked) {
                    checkedIds.add(child.getId())
                }
            }
        }
        return checkedIds
    }

    fun openGallery(){
        val selectImageIntent = Intent(
            Intent.ACTION_GET_CONTENT, MediaStore.Images.Media
            .EXTERNAL_CONTENT_URI)
        startActivityForResult(selectImageIntent, IMAGE_PICK_CODE)
    }

    @Nullable
    fun createCopyAndReturnRealPath(
        @NonNull context: Context, @NonNull uri: Uri?
    ): String? {
        val contentResolver = context.contentResolver ?: return null

        // Create file path inside app's data dir
        val filePath = (context.applicationInfo.dataDir + File.separator
                + System.currentTimeMillis())
        val file = File(filePath)
        try {
            val inputStream = contentResolver.openInputStream(uri!!) ?: return null
            val outputStream: OutputStream = FileOutputStream(file)
            val buf = ByteArray(1024)
            var len: Int
            while (inputStream.read(buf).also { len = it } > 0) outputStream.write(buf, 0, len)
            outputStream.close()
            inputStream.close()
        } catch (ignore: IOException) {
            return null
        }
        return file.absolutePath
    }
}
