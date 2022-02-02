import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:iti_project/models/userClass.dart';
import 'package:iti_project/models/vendorModel.dart';
import 'package:iti_project/modules/home/home_screen.dart';
import 'package:iti_project/modules/login/loginUser.dart';
import 'package:iti_project/modules/vendor/vendor_mainPage.dart';
import 'package:iti_project/shared/component/components.dart';
import 'package:iti_project/shared/component/conestants.dart';

class SplashScreen extends StatefulWidget {
  // MyHomePage({Key? key, required this.title}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  int counter = 0;

  @override
  void initState() {
    super.initState();

    Future.delayed(Duration(seconds: 3), () {
      if (FirebaseAuth.instance.currentUser == null) {
        Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => LoginUser()));
      } else {
        final String uid = FirebaseAuth.instance.currentUser.uid;
        FirebaseMessaging.instance.getToken().then((value) {
          final String fcmId = value;
          FirebaseFirestore.instance.collection("user").doc(uid).get().then((value) {
            if (value.data()['vendor']) {
              print('vendor');
              vendorData = VendorModel.fromJson(value.data());
              FirebaseFirestore.instance
                  .collection("user")
                  .doc(uid)
                  .update(VendorModel(
                    address: vendorData.address,
                    email: vendorData.email,
                    vId: vendorData.vId,
                    fcmId: fcmId,
                    imageProfile: vendorData.imageProfile,
                    phone: vendorData.phone,
                    shopName: vendorData.shopName,
                    verfiedEmail: vendorData.verfiedEmail,
                  ).toMap())
                  .then((value) {
                vendorData.fcmId = fcmId;
                // print(vendorData.fcmId);

                Navigator.of(context).pop();
                navigateAndfinish(context, VendorPage());
              });
            } else {
              print('user');
              userData = UserModel.fromJson(value.data());
              FirebaseFirestore.instance
                  .collection("user")
                  .doc(uid)
                  .update(UserModel(
                    address: userData.address,
                    email: userData.email,
                    name: userData.name,
                    uId: userData.uId,
                    fcmId: fcmId,
                    phone: userData.phone,
                    verfiedEmail: userData.verfiedEmail,
                  ).toMap())
                  .then((value) {
                userData.fcmId = fcmId;
                // print(userData.fcmId);

                Navigator.of(context).pop();
                navigateAndfinish(context, HomeScreen());
              });
            }
          }).catchError((error) {
            print(error);
            Navigator.of(context).pop();
            showDialog(
                context: context,
                builder: (context) => AlertDialog(
                      title: Text(
                        'An Error',
                        style: TextStyle(
                          color: Colors.red,
                        ),
                      ),
                      content: Text(error.toString()),
                      actions: [
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: Text('تم'),
                        )
                      ],
                    ));
          });
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
      decoration: BoxDecoration(image: DecorationImage(image: AssetImage("assets/images/Logo2.png"), fit: BoxFit.cover)),
      child: Center(
        child: Image(
          image: AssetImage("assets/images/Logo1.png"),
        ),
      ),
    ));

    /* Container(
        // color: Colors.tealAccent,
        padding: EdgeInsets.all(15),
        child: Column(
          //  mainAxisAlignment: MainAxisAlignment.center,

          children: <Widget>[
            SizedBox(height: 80,),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  " Welcom to ",
                  style: TextStyle(
                     //color: Colors.teal,
                    fontSize: 18,
                  ),
                )
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  " Eshtery ",
                  style: TextStyle(
                    //color: Colors.teal,
                    fontSize: 40,
                  ),
                )
              ],
            ),

            SizedBox(height: 80,),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  // color: Colors.red,
                  // padding: EdgeInsets.all(50),
                  margin: EdgeInsets.all(1),
                  // padding: EdgeInsets.all(50),
                  child: Image.asset(
                    "assets/images/logo.png",
                    width: MediaQuery.of(context).size.width * .9,
                  ),
                ),
              ],
            ),
            // SvgPicture.asset("assets/images/nn.svg",width: 100,),
           /* Spacer(),
            Row(
              children: [
                Expanded(
                  child: InkWell(
                    onTap: () {
                     
                   navigateTo(context, LoginUser());
                  
                    },
                    child: Container(
                      padding: EdgeInsets.all(10),
                      margin: EdgeInsets.fromLTRB(40, 10, 40, 10),
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        boxShadow: <BoxShadow>[
                          BoxShadow(
                              color: Colors.grey.withOpacity(0.5),
                              blurRadius: 10,
                              offset: Offset(15,20)

                          )
                        ],

                            gradient: LinearGradient(
                              begin: Alignment.topRight,
                              end: Alignment.bottomLeft,
                              colors: [
                                Colors.lightBlueAccent,
                                Colors.blue,
                              ],
                            ),

                          borderRadius: BorderRadius.all(Radius.circular(5)),
                        border: Border.all(color: Colors.grey, width: 1),
                      ),
                      child: Text("Login",
                          style: TextStyle(
                            color: Colors.white,
                            //backgroundColor: Colors.black12,
                            fontSize: 25,
                          )),
                    ),
                  ),
                )
              ],
            ),
                  SizedBox(height: 30,), */
            /* Row(
              children: [
                Expanded(
                  child: InkWell(
                    onTap: () {

                      navigateTo(context, RigsterUser());
                    },
                    child: Container(
                      padding: EdgeInsets.all(10),
                     // margin: EdgeInsets.fromLTRB(40, 10, 40, 10),
                      alignment: Alignment.center,

                      child: Text("Signup",
                          style: TextStyle(
                            color: Colors.green,

                            fontSize: 16,
                          )),
                    ),
                  ),
                )
              ],
            ), */




          ],
        ),
      ),
      // This trailing comma makes auto-formatting nicer for build methods.
    ); */
  }
}
