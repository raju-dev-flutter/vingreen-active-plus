package com.example.vingreen_active_plus

import android.content.ContentUris
import android.content.Context
import android.database.Cursor
import android.database.DatabaseUtils
import android.net.Uri
import android.os.Build
import android.os.Environment
import android.provider.DocumentsContract
import android.provider.MediaStore
import java.io.File

class FileUtils {

    //replace this with your authority
    private val AUTHORITY = "com.cannibalisation.local storage.documents"

    fun FileUtils() {} //private constructor to enforce Singleton pattern

    val TAG = "FileUtils"
    private val DEBUG = false // Set to true to enable logging


    private fun isLocal(url: String?): Boolean {
        return (url != null) && !url.startsWith("http://") && !url.startsWith("https://")
    }

    private fun isLocalStorageDocument(uri: Uri): Boolean {
        return AUTHORITY == uri.authority
    }

    private fun isExternalStorageDocument(uri: Uri): Boolean {
        return "com.android.externalstorage.documents" == uri.authority
    }

    private fun isDownloadsDocument(uri: Uri): Boolean {
        return "com.android.providers.downloads.documents" == uri.authority
    }

    private fun isMediaDocument(uri: Uri): Boolean {
        return "com.android.providers.media.documents" == uri.authority
    }

    private fun isGooglePhotosUri(uri: Uri): Boolean {
        return "com.google.android.apps.photos.content" == uri.authority
    }

    private fun getDataColumn(
        context: Context,
        uri: Uri?,
        selection: String?,
        selectionArgs: Array<String?>?,
    ): String? {
        var cursor: Cursor? = null
        val column = "_data"
        val projection = arrayOf(
            column
        )
        try {
            cursor = uri?.let {
                context.contentResolver.query(it, projection, selection, selectionArgs,
                    null)
            }
            if (cursor != null && cursor.moveToFirst()) {
                if (DEBUG) DatabaseUtils.dumpCursor(cursor)
                val column_index: Int = cursor.getColumnIndexOrThrow(column)
                return cursor.getString(column_index)
            }
        } finally {
            cursor?.close()
        }
        return null
    }


    public fun getFile(context: Context?, uri: Uri?): File? {
        if (uri != null) {
            val path: String = getPath(context, uri)!!
            if (isLocal(path)) {
                return File(path)
            }
        }
        return null
    }


    private fun getPath(context: Context?, uri: Uri): String? {

        if (if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.KITKAT) {
                DocumentsContract.isDocumentUri(context, uri)
            } else {
                TODO("VERSION.SDK_INT < KITKAT")
            }
        ) {
            if (isLocalStorageDocument(uri)) {
                return if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.KITKAT) {
                    DocumentsContract.getDocumentId(uri)
                } else {
                    TODO("VERSION.SDK_INT < KITKAT")
                }
            } else if (isExternalStorageDocument(uri)) {
                val docId = if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.KITKAT) {
                    DocumentsContract.getDocumentId(uri)
                } else {
                    TODO("VERSION.SDK_INT < KITKAT")
                }
                val split = docId.split(":").toTypedArray()
                val type = split[0]
                if ("primary".equals(type, ignoreCase = true)) {
                    return Environment.getExternalStorageDirectory().toString() + "/" + split[1]
                }
            } else if (isDownloadsDocument(uri)) {
                val id = if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.KITKAT) {
                    DocumentsContract.getDocumentId(uri)
                } else {
                    TODO("VERSION.SDK_INT < KITKAT")
                }
                val contentUri = ContentUris.withAppendedId(
                    Uri.parse("content://downloads/public_downloads"), id.toLong())
                return getDataColumn(context!!, contentUri, null, null)
            } else if (isMediaDocument(uri)) {
                val docId = if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.KITKAT) {
                    DocumentsContract.getDocumentId(uri)
                } else {
                    TODO("VERSION.SDK_INT < KITKAT")
                }
                val split = docId.split(":").toTypedArray()
                val type = split[0]
                var contentUri: Uri? = null
                when (type) {
                    "image" -> {
                        contentUri = MediaStore.Images.Media.EXTERNAL_CONTENT_URI
                    }
                    "video" -> {
                        contentUri = MediaStore.Video.Media.EXTERNAL_CONTENT_URI
                    }
                    "audio" -> {
                        contentUri = MediaStore.Audio.Media.EXTERNAL_CONTENT_URI
                    }
                }
                val selection = "_id=?"
                val selectionArgs = arrayOf<String?>(
                    split[1]
                )
                return getDataColumn(context!!, contentUri, selection, selectionArgs)
            }
        } else if ("content".equals(uri.scheme, ignoreCase = true)) {
            return if (isGooglePhotosUri(uri)) uri.lastPathSegment else getDataColumn(context!!,
                uri,
                null,
                null)
        } else if ("file".equals(uri.scheme, ignoreCase = true)) {
            return uri.path
        }
        return null
    }


}