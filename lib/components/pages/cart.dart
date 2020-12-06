import 'package:felimma/helpers/style.dart';
import 'package:felimma/models/cart_item.dart';
import 'package:felimma/provider/app.dart';
import 'package:felimma/provider/user.dart';
import 'package:felimma/services/order.dart';
import 'package:felimma/widgets/custom_text.dart';
import 'package:felimma/widgets/loading.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

const CHANNEL = "com.example.felimma";
const KEY_NATIVE = "showFelimma";

class CartScreen extends StatefulWidget {
  @override
  _CartScreenState createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  final _key = GlobalKey<ScaffoldState>();
  OrderServices _orderServices = OrderServices();

  static const platform = const MethodChannel(CHANNEL);
  static const platformFromKotlin = const MethodChannel('channelFromKotlin');

  Future<Null> showNativeView(
      {
      //user
      userId,
      userFullName,
      email,
      phone,
      // item
      productDetails,
      totalCart,
      deliveryFee}) async {
    await platform.invokeMethod(KEY_NATIVE, {
      "productDetails": productDetails,
      "totalCart": totalCart,
      "deliveryFee": deliveryFee,
      "userId": userId,
      "userFullName": userFullName,
      "email": email,
      "phone": phone,
    });
  }

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);
    final appProvider = Provider.of<AppProvider>(context);

    platformFromKotlin.setMethodCallHandler((call){
      print("Hello from ${call.arguments}");
      return null;
    });

    return Scaffold(
      key: _key,
      appBar: AppBar(
        iconTheme: IconThemeData(color: black),
        backgroundColor: white,
        elevation: 0.0,
        title: CustomText(text: "Shopping Cart"),
        leading: IconButton(
            icon: Icon(Icons.close),
            onPressed: () {
              Navigator.pop(context);
            }),
      ),
      backgroundColor: white,
      body: appProvider.isLoading
          ? Loading()
          : ListView.builder(
              itemCount: userProvider.userModel.cart.length,
              itemBuilder: (_, index) {
                return Padding(
                  padding: const EdgeInsets.all(16),
                  child: Container(
                    height: 120,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: white,
                        boxShadow: [
                          BoxShadow(
                              color: red.withOpacity(0.2),
                              offset: Offset(3, 2),
                              blurRadius: 30)
                        ]),
                    child: Row(
                      children: <Widget>[
                        ClipRRect(
                          borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(20),
                            topLeft: Radius.circular(20),
                          ),
                          child: Image.network(
                            userProvider.userModel.cart[index].image,
                            height: 120,
                            width: 140,
                            fit: BoxFit.fill,
                          ),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Expanded(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              RichText(
                                text: TextSpan(children: [
                                  TextSpan(
                                      text: userProvider
                                              .userModel.cart[index].name +
                                          "\n",
                                      style: TextStyle(
                                          color: black,
                                          fontSize: 12,
                                          fontWeight: FontWeight.bold)),
                                  TextSpan(
                                      text:
                                          "RP${userProvider.userModel.cart[index].price} \n\n",
                                      style: TextStyle(
                                          color: green,
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold)),
                                ]),
                              ),
                              IconButton(
                                  icon: Icon(
                                    Icons.delete,
                                    color: Colors.red,
                                  ),
                                  onPressed: () async {
                                    appProvider.changeIsLoading();
                                    bool success =
                                        await userProvider.removeFromCart(
                                            cartItem: userProvider
                                                .userModel.cart[index]);
                                    if (success) {
                                      userProvider.reloadUserModel();
                                      print("Item added to cart");
                                      _key.currentState.showSnackBar(SnackBar(
                                          content: Text("Removed from Cart!")));
                                      appProvider.changeIsLoading();
                                      return;
                                    } else {
                                      appProvider.changeIsLoading();
                                    }
                                  })
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                );
              }),
      bottomNavigationBar: Container(
        height: 70,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              RichText(
                text: TextSpan(children: [
                  TextSpan(
                      text: "Total: ",
                      style: TextStyle(
                          color: grey,
                          fontSize: 22,
                          fontWeight: FontWeight.w400)),
                  TextSpan(
                      text: "RP${userProvider.userModel.totalCartPrice}",
                      style: TextStyle(
                          color: green,
                          fontSize: 22,
                          fontWeight: FontWeight.bold)),
                ]),
              ),
              Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20), color: black),
                child: FlatButton(
                    onPressed: () {
                      if (userProvider.userModel.totalCartPrice == 0) {
                        showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return Dialog(
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20.0)),
                                //this right here
                                child: Container(
                                  height: 200,
                                  child: Padding(
                                    padding: const EdgeInsets.all(12.0),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: <Widget>[
                                            Text(
                                              'Your cart is empty',
                                              textAlign: TextAlign.center,
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            });
                        return;
                      }
                      showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return Dialog(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20.0)),
                              //this right here
                              child: Container(
                                height: 200,
                                child: Padding(
                                  padding: const EdgeInsets.all(12.0),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'You will be charged RP${userProvider.userModel.totalCartPrice}!',
                                        textAlign: TextAlign.center,
                                      ),
                                      SizedBox(
                                        width: 320.0,
                                        child: RaisedButton(
                                          onPressed: () async {
                                            Navigator.pop(context);
                                            var productDetails = [];
                                            for (int i = 0;
                                                i <
                                                    userProvider
                                                        .userModel.cart.length;
                                                i++) {
                                              productDetails.add({
                                                "id": userProvider
                                                    .userModel.cart[i].id
                                                    .toString(),
                                                "name": userProvider
                                                    .userModel.cart[i].name
                                                    .replaceAll(" ", "_"),
                                                "price": userProvider
                                                    .userModel.cart[i].price
                                                    .toString(),
                                                "qty": 1.toString(),
                                                "deliveryFee": userProvider
                                                        .userModel
                                                        .cart[i]
                                                        .price
                                              });
                                            }
                                            showNativeView(
                                                userId:
                                                    userProvider.userModel.id,
                                                userFullName:
                                                    userProvider.userModel.name,
                                                email: userProvider
                                                    .userModel.email,
                                                phone: userProvider
                                                    .userModel.phoneNumber,
                                                productDetails: productDetails,
                                                totalCart: userProvider
                                                    .userModel.totalCartPrice,
                                                deliveryFee: userProvider
                                                        .userModel
                                                        .totalCartPrice);

                                            // _key.currentState.showSnackBar(
                                            //     SnackBar(
                                            //         content: Text(
                                            //             "Order!")));
                                          },
                                          child: Text(
                                            "Accept",
                                            style:
                                                TextStyle(color: Colors.white),
                                          ),
                                          color: Colors.green,
                                        ),
                                      ),
                                      SizedBox(
                                        width: 320.0,
                                        child: RaisedButton(
                                            onPressed: () {
                                              Navigator.pop(context);
                                            },
                                            child: Text(
                                              "Reject",
                                              style: TextStyle(
                                                  color: Colors.white),
                                            ),
                                            color: Colors.red),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            );
                          });
                    },
                    child: CustomText(
                      text: "Check out",
                      size: 20,
                      color: white,
                      weight: FontWeight.normal,
                    )),
              )
            ],
          ),
        ),
      ),
    );
  }
}
