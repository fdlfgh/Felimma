package com.example.felimma

import android.util.Log
import com.midtrans.sdk.corekit.core.LocalDataHandler
import com.midtrans.sdk.corekit.core.TransactionRequest
import com.midtrans.sdk.corekit.models.BankType
import com.midtrans.sdk.corekit.models.ItemDetails
import com.midtrans.sdk.corekit.models.UserAddress
import com.midtrans.sdk.corekit.models.UserDetail
import com.midtrans.sdk.corekit.models.snap.CreditCard
import org.json.JSONArray
import org.json.JSONObject


object DataCustomer {
    fun customerDetails(userId: String, userFullName: String, email: String, phone: String){
        var userDetail = LocalDataHandler.readObject("user_details", UserDetail::class.java)
        if (userDetail == null) {
            userDetail = UserDetail()
            userDetail.userFullName = userFullName;
            userDetail.email = email
            userDetail.phoneNumber = phone
            userDetail.userId = userId

            val userAddresses: ArrayList<UserAddress> = ArrayList()
            val userAddress = UserAddress()
            userAddress.address = "xxxx"
//            userAddress.city = "Jakarta"
//            userAddress.addressType = Constants.ADDRESS_TYPE_BOTH
//            userAddress.zipcode = "12345"
//            userAddress.country = "IDN"
            userAddresses.add(userAddress)
            userDetail.userAddresses = userAddresses

            LocalDataHandler.saveObject("user_details", userDetail)
        }
    }

    fun transactionRequest(
            productDetail: String,
            totalCart: String,
            userId: String,
            userFullName: String,
            email: String,
            phone: String)
            : TransactionRequest {

        // set request
        val request = TransactionRequest(System.currentTimeMillis().toString() + " ", totalCart.toDouble())

        // set user detail
        customerDetails(userId, userFullName, email, phone)

        //set item details
        val itemDetails = ArrayList<ItemDetails>()
        val product = JSONArray(productDetail)
        Log.d("PRODUCTARRAY", product.toString())
        for (i in 0 until product.length()) {
            val details = ItemDetails(
                    product.getJSONObject(i).getString("id"),
                    product.getJSONObject(i).getString("price").toDouble(),
                    product.getJSONObject(i).getString("qty").toInt(),
                    product.getJSONObject(i).getString("name")
            )
            itemDetails.add(details)
        }

        request.itemDetails = itemDetails

        // set credit card
        val creditCardOptions = CreditCard()
        creditCardOptions.isSaveCard = false
        creditCardOptions.isSecure
        creditCardOptions.bank = BankType.BCA
        creditCardOptions.channel = CreditCard.MIGS
        request.creditCard = creditCardOptions

        return  request
    }
}