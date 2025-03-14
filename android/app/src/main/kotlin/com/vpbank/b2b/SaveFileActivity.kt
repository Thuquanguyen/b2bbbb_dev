package com.vpbank.b2b

import android.Manifest
import android.app.Activity
import android.content.Intent
import android.content.pm.PackageManager
import android.graphics.ImageDecoder
import android.net.Uri
import android.os.Build
import android.os.Bundle
import android.os.Environment
import android.os.Parcelable
import android.provider.MediaStore
import android.util.Log
import android.widget.Toast
import java.io.*
import java.util.*


class SaveFileActivity : Activity() {
    private val REQUEST_CODE = 0x1

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.M) {
            if (checkSelfPermission(Manifest.permission.WRITE_EXTERNAL_STORAGE)
                != PackageManager.PERMISSION_GRANTED
            ) {
                requestPermissions(arrayOf(Manifest.permission.WRITE_EXTERNAL_STORAGE), REQUEST_CODE)
                return
            } else {
                handleIntent()
            }
        }
    }

    override fun onRequestPermissionsResult(requestCode: Int, permissions: Array<String>, grantResults: IntArray) {
        when (requestCode) {
            REQUEST_CODE -> {
                if (grantResults[0] == PackageManager.PERMISSION_GRANTED) {

                    // permission was granted, yay! do the
                    // calendar task you need to do.
                    handleIntent()
                } else {

                    // permission denied, boo! Disable the
                    // functionality that depends on this permission.
                    Toast.makeText(this, "No permission", Toast.LENGTH_SHORT).show()
                    finish()
                }
                return
            }
        }
    }

    private fun handleIntent() {
        when {
            intent?.action == Intent.ACTION_SEND -> {
                if ("text/plain" == intent.type || "application/pdf" == intent.type || "application/vnd.ms-excel" == intent.type) {
                    handleSendFile(intent, intent.type)
                } else if (intent.type?.startsWith("image/") == true) {
                    handleSendImage(intent) // Handle single image being sent
                }
            }
            intent?.action == Intent.ACTION_SEND_MULTIPLE
                    && intent.type?.startsWith("image/") == true -> {
                handleSendMultipleImages(intent) // Handle multiple images being sent
            }
            else -> {
                // Handle other intents, such as being started from the home screen
            }
        }
        finish()
    }

    private fun handleSendFile(intent: Intent, type: String?) {

        Log.d("handleSendFile ", "TYPE $type")

        (intent.getParcelableExtra<Parcelable>(Intent.EXTRA_STREAM) as? Uri)?.let {

            Log.d("handleSendFile", "PATH ${it.path}")

            var path: String? = it.path
            if (path.isNullOrEmpty()) {
                return
            }

            path = path.substring(path.lastIndexOf("/") + 1)

            Log.d("handleSendFile", "FILE NAME $path")

            var inputStream: InputStream? = null
            var outputStream: OutputStream? = null

            Toast.makeText(
                this,
                "Lưu tại /storage/emulated/0/Download/VPBankNeoBiz/$path",
                Toast.LENGTH_LONG
            ).show();
            try {

                Thread {
                    val folder = File("storage/emulated/0/Download/VPBankNeoBiz")
                    if (!folder.exists()) {
                        folder.mkdirs()
                    }
                    inputStream =
                        FileInputStream(File("/storage/emulated/0/Android/data/com.vpbank.b2b/files/$path"))

                    val desFile = File("/storage/emulated/0/Download/VPBankNeoBiz", path)
                    outputStream = FileOutputStream(desFile)
                    val buf = ByteArray(1024)
                    var len: Int
                    try {
                        while ((inputStream as FileInputStream).read(buf).also { len = it } > 0) {
                            (outputStream as FileOutputStream).write(buf, 0, len)
                        }
                    } catch (e: java.lang.Exception) {
                    }

                }.start()
            } catch (e: Exception) {
                Log.d("handleSendFileTxt", " Exception $e")
            } finally {
                inputStream?.close()
                outputStream?.close()
            }
        }
    }

    private fun handleSendImage(intent: Intent) {
        (intent.getParcelableExtra<Parcelable>(Intent.EXTRA_STREAM) as? Uri)?.let {
            // Update UI to reflect image being shared
            try {
                val bitmap = if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.P) {
                    ImageDecoder.decodeBitmap(ImageDecoder.createSource(contentResolver, it))
                } else {
                    MediaStore.Images.Media.getBitmap(contentResolver, it)
                }

                val savedImageURL = MediaStore.Images.Media.insertImage(
                    contentResolver,
                    bitmap,
                    "VPB_" + Date().time,
                    "Image of VPBank NEOBiz"
                )
                Toast.makeText(this, "Saved to Gallery", Toast.LENGTH_SHORT).show()
            } catch (e: Exception) {
                e.printStackTrace()
            }
        }
    }

    private fun handleSendMultipleImages(intent: Intent) {
        intent.getParcelableArrayListExtra<Parcelable>(Intent.EXTRA_STREAM)?.let {
            // Update UI to reflect multiple images being shared
        }
    }
}