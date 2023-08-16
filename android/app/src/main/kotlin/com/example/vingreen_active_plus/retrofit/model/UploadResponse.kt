package com.example.vingreen_active_plus.retrofit.model

import com.google.gson.annotations.SerializedName

object UploadResponse {

    @SerializedName("error")
    private var error = false

    @SerializedName("message")
    private var message: String? = null

    @SerializedName("url")
    private var url: String? = null

    @SerializedName("status")
    private var status: String? = null

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

    fun setUrl(url: String?) {
        this.url = url
    }

    fun getUrl(): String? {
        return url
    }

    fun setStatus(status: String?) {
        this.status = status
    }

    fun getStatus(): String? {
        return status
    }
}