package com.example.vingreen_active_plus.helper

import android.content.Context
import android.content.SharedPreferences

class SharedHelper {
    private var sharedPreferences: SharedPreferences? = null
    private var editor: SharedPreferences.Editor? = null

    fun putKey(context: Context, Key: String?, Value: String?) {
        sharedPreferences = context.getSharedPreferences("Cache", Context.MODE_PRIVATE)
        editor = sharedPreferences!!.edit()
        editor?.putString(Key, Value)
        editor?.commit()
    }

    fun getKey(contextGetKey: Context, Key: String?): String? {
        sharedPreferences = contextGetKey.getSharedPreferences("Cache", Context.MODE_PRIVATE)
        return sharedPreferences!!.getString(Key, "")
    }

    fun clearSharedPreferences(context: Context) {
        sharedPreferences = context.getSharedPreferences("Cache", Context.MODE_PRIVATE)
        sharedPreferences!!.edit().clear().commit()
    }
}