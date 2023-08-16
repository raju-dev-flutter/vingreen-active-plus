package com.example.vingreen_active_plus.retrofit


import com.example.vingreen_active_plus.retrofit.model.CallResponse
import okhttp3.MultipartBody
import okhttp3.RequestBody
import retrofit2.http.*

class Api {
    object BaseUrl {
//        var base_url = "192.168.1.7/l9/active+/"

        var base_url = "https://active-plus.vingreentech.com/"
//        var base_url = "192.168.1.7/l9/active+/"
    }

    @Multipart
    @POST("api/timeline_add")
    fun uploadFile(
        @PartMap params: java.util.HashMap<String, RequestBody>,
        @Part file: MultipartBody.Part?,
    ) = CallResponse
//     
//    @FormUrlEncoded
//    @POST("api/mobile/app_message_log.php")
//    fun updateSMS(@FieldMap params: HashMap<String?, String?>?) =  SmsResponse()
//
//    @FormUrlEncoded
//    @POST("office/api/mobile/incoming_test.php")
//    fun updateIncomingCalls(@FieldMap params: HashMap<String?, String?>?) = CallResponse

}