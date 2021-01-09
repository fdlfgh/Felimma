import 'package:felimma/helpers/style.dart';
import 'package:felimma/models/order.dart';
import 'package:felimma/provider/app.dart';
import 'package:felimma/provider/user.dart';
import 'package:felimma/widgets/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class OrdersScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: black),
        backgroundColor: white,
        elevation: 0.0,
        title: CustomText(
            text: "Orders",
            weight: FontWeight.bold,
        ),
        leading: IconButton(
            icon: Icon(Icons.close),
            onPressed: () {
              Navigator.pop(context);
            }),
      ),
      backgroundColor: white,
      body: ListView.builder(
          itemCount: userProvider.orders.length,
          itemBuilder: (_, index) {
            OrderModel _order = userProvider.orders[index];
            return ListTile(
              leading: CustomText(
                text: "RP${_order.total}",
                weight: FontWeight.bold,
                color: green,
              ),
              title: Text(_order.status),
              subtitle: Text(
                  DateTime.fromMillisecondsSinceEpoch(_order.createdAt)
                      .toString()),
              trailing: FlatButton(
                child: FlatButton(
                  child: Text('Order Details'),
                  onPressed: () {
                    //changeScreen(context, OrderDetailScreen() );
                  },
                ),
              ),
            );
          }),
    );
  }
}
