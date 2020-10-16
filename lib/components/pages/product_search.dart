import 'package:felimma/helpers/common.dart';
import 'package:felimma/helpers/style.dart';
import 'package:felimma/provider/product.dart';
import 'package:felimma/components/pages/product_details.dart';
import 'package:felimma/widgets/custom_text.dart';
import 'package:felimma/widgets/product_card.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProductSearchScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final productProvider = Provider.of<ProductProvider>(context);

    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: black),
        backgroundColor: white,
        leading: IconButton(icon: Icon(Icons.close), onPressed: (){
          Navigator.pop(context);
        }),
        title: CustomText(text: "Services", size: 20,),
        elevation: 0.0,
        centerTitle: true,
        actions: <Widget>[
          IconButton(icon: Icon(Icons.shopping_cart), onPressed: (){})
        ],
      ),
      body: productProvider.productsSearched.length < 1? Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Icon(Icons.search, color: grey, size: 30,),
            ],
          ),
          SizedBox(
            height: 15,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              CustomText(text: "No services Found", color: grey, weight: FontWeight.w300, size: 22,),
            ],
          )
        ],
      ) : ListView.builder(
          itemCount: productProvider.productsSearched.length,
          itemBuilder: (context, index){
            return GestureDetector(
                onTap: ()async{
                  changeScreen(context, ProductDetails(product: productProvider.productsSearched[index]));
                },
                child: ProductCard(product:  productProvider.productsSearched[index]));
          }),
    );
  }
}
