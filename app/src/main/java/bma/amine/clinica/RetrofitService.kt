package bma.amine.clinica

import retrofit2.Retrofit
import retrofit2.converter.gson.GsonConverterFactory

object RetrofitService {
    val endpoint: Endpoint by lazy{
        Retrofit.Builder().baseUrl("http://bf367318acb0.ngrok.io")
            .addConverterFactory(GsonConverterFactory.create())
            .build().create(Endpoint::class.java)
    }
}