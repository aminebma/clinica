package bma.amine.clinica

import okhttp3.MultipartBody
import okhttp3.RequestBody
import retrofit2.Call
import retrofit2.http.*

interface Endpoint {

    @GET("/api/doctors/")
    fun getDoctors(): Call<ArrayList<Doctor>>

    @GET("/api/requests/{id}")
    fun getRequests(@Path("id") id:String): Call<List<Request>>

    @GET("/api/requests/{id}/all")
    fun getAllRequests(@Path("id") id:String): Call<List<Request>>

    @Multipart
    @POST("/api/requests/new")
    fun newRequest(@Part picture: MultipartBody.Part,
                   @Part("date") date:RequestBody,
                   @Part("patientId") patientId:RequestBody,
                   @Part("doctorId") doctorId:RequestBody,
                   @Part("patientFirstName") patientFirstName:RequestBody,
                   @Part("patientLastName") patientLastName:RequestBody,
                   @Part("symptoms") symptoms:ArrayList<RequestBody>,
                   @Part("treatments") treatments:RequestBody): Call<String>

    @POST("/api/requests/response")
    fun answerRequest(@Body answer: Answer): Call<String>

    @POST("/api/accounts/sign-in")
    fun signIn(@Body account: Account): Call<User>

    @POST("/api/accounts/sign-up")
    fun signUp(@Body patient: Patient): Call<String>

    @POST("/api/accounts/sign-up/verify")
    fun validateAccount(@Body account: AccountValidation): Call<String>

}