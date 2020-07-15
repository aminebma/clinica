package bma.amine.clinica

import okhttp3.MultipartBody
import okhttp3.RequestBody
import org.json.JSONObject
import retrofit2.Call
import retrofit2.http.*

interface Endpoint {

    @GET("/medecin")
    fun getMedecins(): Call<ArrayList<Doctor>>

    @GET("/{id}")
    fun getDemandes(@Path("id") id:String): Call<List<bma.amine.clinica.Request>>

    @GET("/{id}/all")
    fun getToutesDemandes(@Path("id") id:String): Call<List<bma.amine.clinica.Request>>

    @Multipart
    @POST("/ajouter_conseil")
    fun ajouterConseil(@Part image: MultipartBody.Part,
                       @Part("Idp") Idp:RequestBody,
                       @Part("Idm") Idm:RequestBody,
                       @Part("nomPatient") nomPatient:RequestBody,
                       @Part("prenomPatient") prenomPatient:RequestBody,
                       @Part("date") date:RequestBody,
                       @Part("symptomes") symptomes:Array<RequestBody>,
                       @Part("traitements") traitements:RequestBody): Call<String>

    @POST("/reponse")
    fun repondre(@Body reponse: Reponse): Call<String>

    @POST("/api/accounts/sign-in")
    fun signIn(@Body account: Account): Call<User>

    @POST("/sign_in/medecin")
    fun connexionMedecin(@Body account: Account): Call<Doctor>

    @POST("/sign_up")
    fun inscription(@Body patient: Patient): Call<String>

    @POST("/sign_up/confirm")
    fun confirmInscription(@Body account: Account): Call<String>

}