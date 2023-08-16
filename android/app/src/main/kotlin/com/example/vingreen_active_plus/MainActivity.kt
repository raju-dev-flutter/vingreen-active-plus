package com.example.vingreen_active_plus

import android.content.Context
import android.content.Intent
import android.os.Build
import android.widget.Toast
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity: FlutterActivity() {

    private val channel = "flutter/call_recorder"
    private val myPreferences = "MyPrefs"

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, channel).setMethodCallHandler {
                call, result ->
            val argument: Map<String, Any> = call.arguments()!!

            when (call.method) {
                "run" -> {
                    startService(Intent(this, TServices::class.java))
                    result.success("Success")
                    val userId = argument["userId"] as String
                    val mobileNo = argument["mobileNo"] as String
                    val userName = argument["userName"] as String
                    val emailId = argument["emailId"] as String

                    val sharedPreference = getSharedPreferences(myPreferences, Context.MODE_PRIVATE)
                    val editor = sharedPreference.edit()
                    editor.putString("user_id", userId)
                    editor.putString("mobile_no", mobileNo)
                    editor.putString("user_name", userName)
                    editor.putString("email_id", emailId)
                    if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.GINGERBREAD) {
                        editor.apply()
                    }
                    showToast(context,"Service Start")
                }
                "get_details" -> {
                    println("Get Service Details")
                    result.success("Success")
                    val sharedPreference = getSharedPreferences(myPreferences, Context.MODE_PRIVATE)
                    println("userId : == :${sharedPreference.getString("user_id",null)}" +
                            "\n mobileNo : == :${sharedPreference.getString("mobile_no",null)}" +
                            "\n userName : == :${sharedPreference.getString("user_name",null)}" +
                            "\n emailId : == :${sharedPreference.getString("email_id",null)}"
                    )
                }
                "stop" -> {
                    println(" Service Stop")
                    stopService(Intent(this, TServices::class.java))
                    showToast(context,"Service Stop")
                    result.success("Success")
                }
                else -> result.notImplemented()
            }
        }
    }
    private fun showToast(context: Context, message: String){
        Toast.makeText(context, message, Toast.LENGTH_SHORT).show()
    }
}
