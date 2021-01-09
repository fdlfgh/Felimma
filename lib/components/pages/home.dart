import 'package:felimma/helpers/common.dart';
import 'package:felimma/helpers/style.dart';
import 'package:felimma/provider/service.dart';
import 'package:felimma/provider/user.dart';
import 'package:felimma/components/pages/service_search.dart';
import 'package:felimma/components/pages/map.dart';
import 'package:felimma/services/service.dart';
import 'package:felimma/widgets/custom_text.dart';
import 'package:felimma/widgets/featured_services.dart';
import 'package:felimma/widgets/service_card.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'service_search.dart';
import 'cart.dart';
import 'order.dart';
import 'user_profile.dart';


class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _key = GlobalKey<ScaffoldState>();
  ServiceServices _serviceServices = ServiceServices();

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);
    final serviceProvider = Provider.of<ServiceProvider>(context);

    return Scaffold(
      key: _key,
      backgroundColor: white,
      endDrawer: Drawer(
        child: ListView(
          children: <Widget>[
            UserAccountsDrawerHeader(
              decoration: BoxDecoration(color: Colors.white),
              accountName: CustomText(
                text: userProvider.userModel?.name ?? "username lading...",
                color: Colors.deepPurple,
                weight: FontWeight.bold,
                size: 25,
              ),
              accountEmail: CustomText(
                text: userProvider.userModel?.email ?? "email loading...",
                color: black,
              ),
            ),
            ListTile(
              onTap: () async {
                changeScreen(context, UserProfileScreen());
              },
              leading: Icon(Icons.person, color: Colors.black),
              title: CustomText(text: "Profile"),
            ),
            ListTile(
              onTap: () async {
                await userProvider.getOrders();
                changeScreen(context, OrdersScreen());
              },
              leading: Icon(Icons.bookmark_border, color: Colors.black),
              title: CustomText(text: "My orders"),
            ),
            ListTile(
              onTap: () async {
                changeScreen(context, CartScreen());
              },
              leading: Icon(Icons.shopping_cart, color: Colors.black),
              title: CustomText(text: "Cart"),
            ),
            ListTile(
              onTap: () {
                userProvider.signOut();
              },
              leading: Icon(Icons.exit_to_app, color: Colors.red),
              title: CustomText(text: "Log out"),
            ),
          ],
        ),
      ),
      body: SafeArea(
        child: ListView(
          children: <Widget>[
//           Custom App bar
            Stack(
              children: <Widget>[
                Positioned(
                  top: 10,
                  right: 20,
                  child: Align(
                      alignment: Alignment.topRight,
                      child: GestureDetector(
                          onTap: () {
                            _key.currentState.openEndDrawer();
                          },
                          child: Icon(Icons.menu))),
                ),
                Positioned(
                  top: 10,
                  right: 60,
                  child: Align(
                      alignment: Alignment.topRight,
                      child: GestureDetector(
                          onTap: () {
                            changeScreen(context, CartScreen());
                          },
                          child: Icon(Icons.shopping_cart))),
                ),
                Positioned(
                  top: 10,
                  right: 100,
                  child: Align(
                      alignment: Alignment.topRight,
                      child: GestureDetector(
                          onTap: () {
                            changeScreen(context, UserProfileScreen());
                          },
                          child: Icon(Icons.person))),
                ),
                Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Text(
                    '\nFelimma',
                    style: TextStyle(
                        shadows: [
                          Shadow(
                            blurRadius: 1.0,
                            color: Colors.grey,
                            offset: Offset(1.0, 1.0),
                          ),
                        ],
                        fontSize: 60,
                        color: Colors.black,
                        fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),

//          Search Text field
            //Search(),

            Container(
              decoration: BoxDecoration(
                  color: white,
                  borderRadius: BorderRadius.only(
                      bottomRight: Radius.circular(15),
                      bottomLeft: Radius.circular(15))),
              child: Padding(
                padding: const EdgeInsets.only(
                    top: 1, left: 8, right: 8, bottom: 10),
                child: Container(
                  decoration: BoxDecoration(
                    color: grey.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: ListTile(
                    leading: Icon(
                      Icons.search,
                      color: Colors.black,
                    ),
                    title: TextField(
                      textInputAction: TextInputAction.search,
                      onSubmitted: (pattern) async {
                        await serviceProvider.search(serviceName: pattern);
                        changeScreen(context, ServiceSearchScreen());
                      },
                      decoration: InputDecoration(
                        hintText: "Photographers, Models, MUA...",
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                ),
              ),
            ),

//            featured services
            Row(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(14.0),
                  child: Container(
                      alignment: Alignment.centerLeft,
                      child: new Text('Featured services',
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 20,
                              fontWeight: FontWeight.w800))),
                ),
              ],
            ),
            FeaturedServices(),

//          recent services
            Row(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(14.0),
                  child: Container(
                    alignment: Alignment.centerLeft,
                    child: new Text('Recent services',
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 20,
                            fontWeight: FontWeight.w800)),
                  ),
                ),
              ],
            ),


            Column(
              children: serviceProvider.services
                  .map((item) => GestureDetector(
                        child: ServiceCard(
                          service: item,
                        ),
                      ))
                  .toList(),
            ),
            SizedBox(
                height: 75
            ),
          ],
        ),
      ),


      /*floatingActionButton: FloatingActionButton.extended(
        icon: Icon(Icons.search, color: Colors.deepPurple,),
        backgroundColor: Colors.white,
        onPressed: () {
          changeScreen(context, MapScreen());
        },
        label: Text('Search Service',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
      ),*/
      floatingActionButtonLocation:
      FloatingActionButtonLocation.endFloat,
    );
  }
}
