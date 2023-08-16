@file:Suppress("DEPRECATION")

package com.example.vingreen_active_plus

import android.annotation.SuppressLint
import android.app.Notification
import android.app.NotificationChannel
import android.app.NotificationManager
import android.app.Service
import android.content.*
import android.graphics.Color
import android.net.Uri
import android.os.Build
import android.os.IBinder
import android.provider.CallLog
import android.telephony.PhoneStateListener
import android.telephony.TelephonyManager
import android.widget.Toast
import androidx.core.app.NotificationCompat
import java.io.File
import java.text.SimpleDateFormat
import java.util.*

val contentResolver: ContentResolver? = null

class TServices : Service() {

    //    var sharedPref: SharedPreferences? = null
//    private val myPreferences = "MyPrefs"
    private var telephonyManager: TelephonyManager? = null

    //    private var lastState: Int = TelephonyManager.CALL_STATE_IDLE  
//    private var callStartTime: String? = null
//    private var callEndTime: String? = null 
    private var br_call: CallBr = CallBr()


    override fun onBind(intent: Intent?): IBinder? {
        return null
    }

    override fun onCreate(){
        super.onCreate()

        if(Build.VERSION.SDK_INT > Build.VERSION_CODES.O){
            startMyForground()
        }else{
            startForeground(1, Notification())
        }
    }
    private fun startMyForground(){
        val notificationChannelId = "VGT"
        val channelName = "Vin-green_Active_Plus_App"
        val channel = if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            NotificationChannel(
                notificationChannelId,channelName, NotificationManager.IMPORTANCE_NONE
            )
        } else {
            TODO("VERSION.SDK_INT < O")
        }
        Color.BLUE.also { channel.lightColor = it }
        channel.lockscreenVisibility = Notification.VISIBILITY_PRIVATE
        val manager = getSystemService(Context.NOTIFICATION_SERVICE) as NotificationManager
        manager.createNotificationChannel(channel)
        val builder = NotificationCompat.Builder(this, notificationChannelId)
        builder
            .setOngoing(true)
            .setOnlyAlertOnce(true)
            .setContentTitle("Vin-green_Active_Plus_App")
            .setContentText("Forground Service is running")
            .setCategory(Notification.CATEGORY_SERVICE)
        startForeground(2, builder.build())
    }


    @Suppress("DEPRECATION")
    override fun onDestroy() {
        super.onDestroy()
        unRegRec()
        telephonyManager?.listen(
            CallBr() as PhoneStateListener?,
            PhoneStateListener.LISTEN_NONE
        )
    }

    private fun unRegRec(){
        try {
            unregisterReceiver(br_call)
            println("=====Receiver Destroyed")
        }catch (e: Exception){
            println("=====Error when Destroy$e")
        }
    }

    override fun onStartCommand(intent: Intent?, flags:Int, startId:Int): Int {
        val filter = IntentFilter()
        filter.addAction(ACTION_OUT)
        filter.addAction(ACTION_IN)
        br_call = CallBr()
        this.registerReceiver(br_call, filter)
        return START_STICKY
    }

    @Suppress("DEPRECATION")
    class CallBr: BroadcastReceiver() {


        override fun onReceive(context: Context, intent: Intent) {
            try {

                if (intent.action.equals(Intent.ACTION_NEW_OUTGOING_CALL)) {
                    val phoneNumber = intent.getStringExtra(Intent.EXTRA_PHONE_NUMBER)
                    Toast.makeText(context, phoneNumber, Toast.LENGTH_SHORT).show()
                    savedNumber =
                        intent.getStringExtra("android.intent.extra.PHONE_NUMBER").toString()
                    print("\n Save Number: =====$savedNumber")

                    val editor = sharedpreferences?.edit()
                    editor?.putString("saved_number", savedNumber)
                    editor?.apply()

                } else {
                    val tm =
                        context.getSystemService(Context.TELEPHONY_SERVICE) as TelephonyManager
//                    val phoneListener = MyPhoneStateListener(context)
//                    tm.listen(phoneListener, PhoneStateListener.LISTEN_CALL_STATE);

                    val phoneNumber = intent.getStringExtra(Intent.EXTRA_PHONE_NUMBER).toString()
                    when (tm.callState) {
                        TelephonyManager.CALL_STATE_RINGING -> {
                            Toast.makeText(context,
                                "CALL_STATE_RINGING $phoneNumber",
                                Toast.LENGTH_SHORT).show()
                            callstate = TelephonyManager.CALL_STATE_RINGING
                            println("CALL_STATE_RINGING")
                        }
                        TelephonyManager.CALL_STATE_OFFHOOK -> {
                            Toast.makeText(context, "CALL_STATE_OFF-HOOK", Toast.LENGTH_SHORT)
                                .show()
                            callstate = TelephonyManager.CALL_STATE_OFFHOOK
                            println("CALL_STATE_OFF-HOOK")
                        }
                        TelephonyManager.CALL_STATE_IDLE -> {
                            Toast.makeText(context, "CALL_STATE_IDLE", Toast.LENGTH_SHORT).show()
                            callstate = TelephonyManager.CALL_STATE_IDLE
                            println("CALL_STATE_IDLE")
                        }
                    }
                    onCallStateChanged(context, callstate, savedNumber)
                }
            } catch (e: java.lang.Exception) {
                println("=====Head Exception Acquired=====$e")
            }
        }

        @SuppressLint("SimpleDateFormat")
        private fun onCallStateChanged(context: Context, state: Int, savedNumber: String) {
            if (lastState == state)
                return
            when (state) {
                TelephonyManager.CALL_STATE_RINGING -> {
                    isIncoming = true
                    println("Incoming Call:========")
                }
                TelephonyManager.CALL_STATE_OFFHOOK -> {
                    (lastState == TelephonyManager.CALL_STATE_RINGING).also { isIncoming = it }
                    SimpleDateFormat("yyyy-MM-dd hh:mm:ss").format(Date()).also { callStartTime = it }
                }
                TelephonyManager.CALL_STATE_IDLE -> {
                    callEndTime = SimpleDateFormat("yyyy-MM-dd hh:mm:ss").format(Date())
                    val incoming_no: List<String> = getContactNumber()
//                    val duration: List<String> = getContactDuration()
                }
            }
            lastState = state
        }
        fun getContactNumber(): List<String> {
            val contacts: MutableList<String> = ArrayList()
            val uriCallLogs = Uri.parse("content://call_log/calls")
            val cr: ContentResolver = contentResolver!!
            val cursor = cr.query(uriCallLogs, null, null, null, null)
            if (cursor!!.moveToFirst()) {
                do {
                    @SuppressLint("Range") val name =
                        cursor.getString(cursor.getColumnIndex(CallLog.Calls.NUMBER))
                    contacts.add(name)
                } while (cursor.moveToNext())
            }
            cursor.close()
            return contacts
        }

        private fun getContactDuration(): List<String> {
            val duration: MutableList<String> = ArrayList()
            val uriCallLogs = Uri.parse("content://call_log/calls")
            val cr: ContentResolver = contentResolver!!
            val cursor = cr.query(uriCallLogs, null, null, null, null)
            if (cursor!!.moveToFirst()) {
                do {
                    @SuppressLint("Range") val call_duration =
                        cursor.getString(cursor.getColumnIndex(CallLog.Calls.DURATION))
                    duration.add(call_duration)
                } while (cursor.moveToNext())
            }
            cursor.close()
            return duration
        }

        fun getLastModifiedFile(directory: File): File? {
            val files = directory.listFiles()!!
            if (files.isEmpty()) return null
            Arrays.sort(files) { o1, o2 ->
                o2.lastModified().compareTo(o1.lastModified())
            }
            return files[0]
        }

    } 
    private fun showException(s: String) {
        println("===== Exception =====$s")
    }


    companion object {

        private var savedNumber = ""
        private var lastState: Int = TelephonyManager.CALL_STATE_IDLE
        private const val ACTION_IN = "android.intent.action.PHONE_STATE"
        private const val ACTION_OUT = "android.intent.action.NEW_OUTGOING_CALL"
        private var fileUtils: FileUtils = FileUtils()
        private var callStartTime: String? = null
        private var callEndTime: String? = null
        private var isIncoming = false
        private var callstate: Int = 0
        private var sharedpreferences: SharedPreferences? = null
    }

 

}