package bma.amine.clinica

import okhttp3.MultipartBody
import okhttp3.RequestBody
import retrofit2.Call
import retrofit2.http.*

interface Endpoint {

    @GET("/api/doctors/")
    fun getDoctors(): Call<ArrayList<Doctor>>

    @GET("/{id}")
    fun getRequests(@Path("id") id:String): Call<List<Request>>

    @GET("/api/requests/{id}/all")
    fun getAllRequests(@Path("id") id:String): Call<List<Request>>

    @Multipart
    @POST("/api/requests/new")
    fun ajouterConseil(@Part image: MultipartBody.Part,
                       @Part("Idp") Idp:RequestBody,
                       @Part("Idm") Idm:RequestBody,
                       @Part("nomPatient") nomPatient:RequestBody,
                       @Part("prenomPatient") prenomPatient:RequestBody,
                       @Part("date") date:RequestBody,
                       @Part("symptomes") symptomes:Array<RequestBody>,
                       @Part("traitements") traitements:RequestBody): Call<String>

    @POST("/api/requests/response")
    fun answerRequest(@Body answer: Answer): Call<String>

    @POST("/api/accounts/sign-in")
    fun signIn(@Body account: Account): Call<User>

    @POST("/api/accounts/sign-up")
    fun signUp(@Body patient: Patient): Call<String>

    @POST("/api/accounts/sign-up/verify")
    fun validateAccount(@Body account: AccountValidation): Call<String>

}