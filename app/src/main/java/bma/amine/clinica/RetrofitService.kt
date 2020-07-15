package bma.amine.clinica

import com.google.gson.GsonBuilder
import retrofit2.Retrofit
import retrofit2.converter.gson.GsonConverterFactory

object RetrofitService {
    val endpoint: Endpoint by lazy{
        Retrofit.Builder().baseUrl("http://192.168.1.9:3000")
            .addConverterFactory(GsonConverterFactory.create(GsonBuilder().setLenient().create()))
            .build().create(Endpoint::class.java)
    }
}