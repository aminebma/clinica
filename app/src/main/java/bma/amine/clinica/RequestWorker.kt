package bma.amine.clinica

import android.annotation.SuppressLint
import android.content.Context
import android.widget.Toast
import androidx.work.ListenableWorker
import androidx.work.WorkerParameters
import androidx.work.impl.utils.futures.SettableFuture
import com.google.common.util.concurrent.ListenableFuture
import okhttp3.MediaType
import okhttp3.MultipartBody
import okhttp3.RequestBody
import retrofit2.Call
import retrofit2.Callback
import retrofit2.Response
import java.io.File

class RequestWorker (val context: Context, val workParameters: WorkerParameters): ListenableWorker(context, workParameters){
    lateinit var future: SettableFuture<Result>

    @SuppressLint("RestrictedApi")
    override fun startWork(): ListenableFuture<Result> {
        future = SettableFuture.create<Result>()
        addRequest()
        return future
    }

    private fun addRequest(){
        var requestBody: RequestBody
        var picturePart: MultipartBody.Part
        if(inputData.getString("picturePath") != ""){
            val picture = File(inputData.getString("picturePath"))
            requestBody = RequestBody.create(MediaType.parse("image/jpeg"), picture)
            picturePart = MultipartBody.Part.createFormData("picture", picture.name, requestBody)
        }
        else{
            val picture = " "
            requestBody = RequestBody.create(MediaType.parse("image/jpeg"), picture)
            picturePart = MultipartBody.Part.createFormData("picture", " ", requestBody)
        }
        val patientId = RequestBody.create(MediaType.parse("multipart/form-data"), inputData.getString("patientId"))
        val doctorId = RequestBody.create(MediaType.parse("multipart/form-data"), inputData.getString("doctorId"))
        val patientFirstName = RequestBody.create(MediaType.parse("multipart/form-data"), inputData.getString("patientFirstName"))
        val patientLastName = RequestBody.create(MediaType.parse("multipart/form-data"), inputData.getString("patientLastName"))
        val date = RequestBody.create(MediaType.parse("multipart/form-data"), inputData.getString("date"))
        val symptoms = ArrayList<RequestBody>()
        for(symptom in inputData.getStringArray("symptoms")!!)
            symptoms.add(RequestBody.create(MediaType.parse("multipart/form-data"), symptom))
        val treatments = RequestBody.create(MediaType.parse("multipart/form-data"), inputData.getString("treatments"))

        val call = RetrofitService.endpoint.newRequest(
            picturePart,
            date,
            patientId,
            doctorId,
            patientFirstName,
            patientLastName,
            symptoms,
            treatments
        )
        call.enqueue(object: Callback<String> {
            @SuppressLint("RestrictedApi")
            override fun onFailure(call: Call<String>, t: Throwable) {
                Toast.makeText(context, "Une erreur s'est produite.", Toast.LENGTH_SHORT)
                        .show()
            }

            @SuppressLint("RestrictedApi")
            override fun onResponse(call: Call<String>, response: Response<String>) {
                if(response.isSuccessful){
                    Toast.makeText(context, "Demande envoyée !", Toast.LENGTH_SHORT)
                        .show()
                    RoomService.appDatabase.getRequestDAO().deleteTmpRequest(inputData.getLong("tmpRequestId",-1))
                    future.set(Result.success())
                }
                else{
                    future.set(Result.retry())
                }
            }

        })
    }

}