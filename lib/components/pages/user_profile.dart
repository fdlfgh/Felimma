import 'package:felimma/helpers/common.dart';
import 'package:felimma/helpers/style.dart';
import 'package:felimma/models/user.dart';
import 'package:felimma/provider/app.dart';
import 'package:felimma/provider/user.dart';
import 'package:felimma/widgets/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';

class UserProfileScreen extends StatefulWidget {
  final UserModel user;

  const UserProfileScreen({Key key, this.user}) : super(key: key);

  @override
  _UserProfileScreensState createState() => _UserProfileScreensState();
}

class _UserProfileScreensState extends State<UserProfileScreen> {
  final _key = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    //_duration = widget.service.duration[0];
  }

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);
    final appProvider = Provider.of<AppProvider>(context);

    return Scaffold(
      key: _key,
        appBar: AppBar(
          iconTheme: IconThemeData(color: black),
          backgroundColor: white,
          elevation: 0.0,
          title: CustomText(
              text: "User Profile",
              weight: FontWeight.bold,
          ),
          leading: IconButton(
              icon: Icon(Icons.close),
              onPressed: () {
                Navigator.pop(context);
              }),
        ),
        backgroundColor: Colors.white,
        body: SafeArea(
          child: Column(

            children: [
              Container(
                decoration: BoxDecoration(
                    image: DecorationImage(
                        image: NetworkImage(
                            ""
                        ),
                        fit: BoxFit.cover
                    )
                ),
                child: Container(
                  width: double.infinity,
                  height: 200,
                  child: Container(
                    alignment: Alignment(0.0,2.5),
                    child: CircleAvatar(
                      backgroundImage: NetworkImage(
                          ""
                      ),
                      radius: 60.0,
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 60,
              ),
              Text(
                '${userProvider.userModel.name}'
                ,style: TextStyle(
                  fontSize: 25.0,
                  color:Colors.black,
                  letterSpacing: 2.0,
                  fontWeight: FontWeight.w700
              ),
              ),
              SizedBox(
                height: 10,
              ),
              Text(
                '${userProvider.userModel.email}'
                ,textAlign: TextAlign.left,
                style: TextStyle(
                  fontSize: 20.0,
                  color:Colors.black,
                  fontWeight: FontWeight.w300
              ),
              ),
              SizedBox(
                height: 20,
              ),
              Text(
                '${userProvider.userModel.phoneNumber}'
                ,style: TextStyle(
                  fontSize: 20.0,
                  color:Colors.black,
                  letterSpacing: 2.0,
                  fontWeight: FontWeight.w500
                ),
              ),
              Text(
                '${userProvider.userModel.address}'
                ,style: TextStyle(
                  fontSize: 17.0,
                  color:Colors.black,
                  fontWeight: FontWeight.w300
                ),
              ),
              Text(
                'Postal Code: ${userProvider.userModel.postalCode}'
                ,style: TextStyle(
                  fontSize: 17.0,
                  color:Colors.black,
                  fontWeight: FontWeight.w300
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Text(
                '${userProvider.userModel.city}'
                ,style: TextStyle(
                  fontSize: 18.0,
                  color:Colors.black,
                  letterSpacing: 2.0,
                  fontWeight: FontWeight.w500
                ),
              ),
              SizedBox(
                height: 50,
              ),
            ],
          ),
        )
    );
  }
}
