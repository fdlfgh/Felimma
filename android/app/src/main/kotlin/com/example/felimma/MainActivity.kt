package com.example.felimma

import android.util.Log
import android.widget.Toast
import androidx.annotation.NonNull
import com.google.android.gms.common.internal.service.Common.CLIENT_KEY
import com.midtrans.sdk.corekit.BuildConfig.BASE_URL
import com.midtrans.sdk.corekit.callback.TransactionFinishedCallback
import com.midtrans.sdk.corekit.core.MidtransSDK
import com.midtrans.sdk.corekit.core.PaymentMethod
import com.midtrans.sdk.corekit.core.themes.CustomColorTheme
import com.midtrans.sdk.corekit.models.snap.TransactionResult
import com.midtrans.sdk.uikit.SdkUIFlowBuilder
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugins.GeneratedPluginRegistrant


class MainActivity: FlutterActivity(), TransactionFinishedCallback{

    companion object{
        const val CHANNEL = "com.example.felimma";
        const val KEY_NATIVE = "showFelimma";
    }

    override fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine) {
        GeneratedPluginRegistrant.registerWith(flutterEngine);

        MethodChannel(flutterEngine.dartExecutor, CHANNEL).setMethodCallHandler { call, result ->
            if (call.method == KEY_NATIVE) {

                val product = (""+call.argument("productDetails"))
                val totalCart = (""+call.argument("totalCart"))

                val userId = (""+call.argument("userId"))
                val userFullName = (""+call.argument("userFullName"))
                val phone = (""+call.argument("phone"))
                val email = (""+call.argument("email"))

                Log.d("PRODUCT", product)

                initMidtransSdk()
                MidtransSDK.getInstance().transactionRequest = DataCustomer.transactionRequest(
                        product, totalCart, userId, userFullName, email, phone
                )

                MidtransSDK.getInstance().startPaymentUiFlow(this)

            }else{
                result.notImplemented()
            }
        }
    }

    private fun initMidtransSdk(){
        Log.d("MERCHANT", BuildConfig.MERCHANT_BASE_URL)
        SdkUIFlowBuilder.init()
                .setClientKey(BuildConfig.MERCHANT_CLIENT_KEY) // client_key is mandatory
                .setContext(this.context) // context is mandatory
                .setTransactionFinishedCallback(this) // set transaction finish callback (sdk callback)
                .setMerchantBaseUrl(BuildConfig.MERCHANT_BASE_URL) //set merchant url (required)
                .enableLog(true) // enable sdk log (optional)
                .setColorTheme(CustomColorTheme("#FFE51255", "#B61548", "#FFE51255")) // set theme. it will replace theme on snap theme on MAP ( optional)
                .buildSDK()
    }

    override fun onTransactionFinished(p0: TransactionResult?) {
        val channel = MethodChannel(flutterEngine?.dartExecutor?.binaryMessenger, "channelFromKotlin")

        if (p0?.response != null){
            when(p0.status){
                TransactionResult.STATUS_SUCCESS -> {
                    channel.invokeMethod("success", p0.response.transactionId)
                }

                TransactionResult.STATUS_PENDING -> {
                    channel.invokeMethod("pending", p0.response.transactionId)
                }

                TransactionResult.STATUS_FAILED -> {
                    channel.invokeMethod("failed", p0.response.transactionId)
                }

            }
            p0.response.validationMessages
        }else if(p0!!.isTransactionCanceled){
            channel.invokeMethod("canceled", "")
        }else{
            if(p0!!.status.equals(TransactionResult.STATUS_INVALID, ignoreCase = true)){
                channel.invokeMethod("invalid", "")
            }else{
                Toast.makeText(
                        this,
                        "Transaction Finished with failure", Toast.LENGTH_LONG)
                        .show()
            }
        }
    }
}