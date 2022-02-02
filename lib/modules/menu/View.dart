import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:iti_project/modules/MyOrders/View.dart';
import 'package:iti_project/modules/Myfavorite/view.dart';
import 'package:iti_project/modules/cart/view.dart';
import 'package:iti_project/modules/login/loginUser.dart';
import 'package:iti_project/modules/product/product_screen.dart';
import 'package:iti_project/modules/profile/userProfile.dart';
import 'package:iti_project/modules/profile/vendorProfile.dart';
import 'package:iti_project/shared/component/components.dart';
import 'package:iti_project/shared/component/conestants.dart';

class Menu extends StatefulWidget {
  Menu({Key key}) : super(key: key);

  @override
  _MenuState createState() => _MenuState();
}

class _MenuState extends State<Menu> {
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size.width;
    return Container(
      width: size * 0.7,
      color: Colors.white,
      child: Stack(
        children: [
          Container(
            margin: EdgeInsets.only(top: size * .4, bottom: size * .4),
            alignment: Alignment.center,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
               /*  InkWell(
                  child: Text(
                    "Home",
                    style: TextStyle(fontSize: 20),
                  ),
                  onTap: () {},
                ), */
                InkWell(
                  child: Text("Profile", style: TextStyle(fontSize: 20)),
                  onTap: () {
                    Navigator.of(context).pop();
                    if (userData == null) {
                      navigateTo(context, VendorProf());
                    } else
                      navigateTo(context, UserProfile());
                  },
                ),
                InkWell(
                  child: Text("My Cart", style: TextStyle(fontSize: 20)),
                  onTap: () {
                    Navigator.of(context).pop();
                    navigateTo(context, Cart());
                  },
                ),
                InkWell(
                  child: Text("Favorite", style: TextStyle(fontSize: 20)),
                  onTap: () {
                    Navigator.of(context).pop();
                    navigateTo(
                        context,
                       Myfavorite(
                         
                        ));
                  },
                ),
                InkWell(
                  child: Text("My Orders", style: TextStyle(fontSize: 20)),
                  onTap: () {
                    Navigator.of(context).pop();
                    navigateTo(context, MyOrder());
                  },
                ),
                /* InkWell(
                  child: Text("Settings", style: TextStyle(fontSize: 20)),
                  onTap: () {},
                ), */
                InkWell(
                  child: Text("Logout", style: TextStyle(fontSize: 20)),
                  onTap: () {
                    FirebaseAuth.instance.signOut().then((value) {
                      userData = null;
                      vendorData = null;
                      navigateAndfinish(context, LoginUser());
                    });
                  },
                ),
              ],
            ),
          ),
          Container(
            margin: EdgeInsets.only(bottom: size * .04, right: size * .04),
            alignment: Alignment.bottomRight,
            child: IconButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              icon: Icon(Icons.highlight_off),
            ),
          ),
        ],
      ),
    );
  }
}
