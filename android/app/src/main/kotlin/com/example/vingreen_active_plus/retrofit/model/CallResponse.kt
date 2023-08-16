package com.example.vingreen_active_plus.retrofit.model

import com.google.gson.annotations.SerializedName

object CallResponse {

    @SerializedName("status")
    private var status: String? = null

    @SerializedName("error")
    private var error = false

    @SerializedName("message")
    private var message: String? = null

    fun setStatus(status: String?) {
        this.status = status
    }

    fun getStatus(): String? {
        return status
    }


    fun setError(error: Boolean) {
        this.error = error
    }

    fun isError(): Boolean {
        return error
    }

    fun setMessage(message: String?) {
        this.message = message
    }

    fun getMessage(): String? {
        return message
    }

}