package com.example.vingreen_active_plus.retrofit


import retrofit2.Retrofit
import android.annotation.SuppressLint
import retrofit2.converter.gson.GsonConverterFactory


@SuppressLint("NotConstructor")
object RetrofitClient{
    private var instance: RetrofitClient? = null
    private var myApi: Api? = null

    private fun retrofitClient(): RetrofitClient {

        val retrofit: Retrofit = Retrofit.Builder().baseUrl(Api.BaseUrl.base_url)
            .addConverterFactory(GsonConverterFactory.create())
            .build()
        myApi = retrofit.create(Api::class.java)
        return RetrofitClient
    }

    @Synchronized
    fun getInstance(): RetrofitClient? {
        if (instance == null) {
            instance = retrofitClient()
        }
        return instance
    }

    fun getMyApi(): Api? {
        return myApi
    }
}