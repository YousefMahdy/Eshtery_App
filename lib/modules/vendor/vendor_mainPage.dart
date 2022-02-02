import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:iti_project/modules/Addproducts/view.dart';
import 'package:iti_project/modules/MyProducts/view.dart';
import 'package:iti_project/modules/home/home_screen.dart';
import 'package:iti_project/modules/login/loginUser.dart';
import 'package:iti_project/modules/profile/vendorProfile.dart';
import 'package:iti_project/shared/component/components.dart';
import 'package:iti_project/shared/component/conestants.dart';
import 'package:lottie/lottie.dart';


class VendorPage extends StatefulWidget {
  // MyHomePage({Key? key, required this.title}) : super(key: key);
  static const routName = '/VendorPage';

  @override
  _VendorPageState createState() => _VendorPageState();
}

class _VendorPageState extends State<VendorPage> {
  int counter = 0;
  /* Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  
 // await Firebase.initializeApp();
  showDialog(context: context,
         builder: (context)=>Dialog(
           child: Container(
             alignment: Alignment.center,
             height: MediaQuery.of(context).size.width,
             child:SingleChildScrollView(
               physics: BouncingScrollPhysics(),
               child: Column(
                 children: [
                    Lottie.asset('assets/images/55867-congratulation.json'),
                    Text('Your Product Has been sell'),
                    ...json.decode(message.data['selledProducts']).map(
                      (e)=>Text('$e',style: TextStyle(
                        fontWeight: FontWeight.bold
                      ),)
                    ).toList()
                 ],
               ),
             ) ,
           ),
         )
         );
} */
  @override
    void initState() {
      
      super.initState();
      FirebaseMessaging.onMessage.listen((event) {
        //List<String>data=event.data['selledProducts'];
        showDialog(context: context,
         builder: (context)=>Dialog(
           child: Container(
             alignment: Alignment.center,
             height: MediaQuery.of(context).size.width,
             child:SingleChildScrollView(
               physics: BouncingScrollPhysics(),
               child: Column(
                 children: [
                    Lottie.asset('assets/images/55867-congratulation.json'),
                    Text('Your Product Has been sell'),
                    ...json.decode(event.data['selledProducts']).map(
                      (e)=>Text('$e',style: TextStyle(
                        fontWeight: FontWeight.bold
                      ),)
                    ).toList()
                 ],
               ),
             ) ,
           ),
         )
         );
         //
   // print('Daaaaaaaaaaata ${event.data.toString()}');
    
  });
  FirebaseMessaging.onMessageOpenedApp.listen((event) {
    showDialog(context: context,
         builder: (context)=>Dialog(
           child: Container(
             alignment: Alignment.center,
             height: MediaQuery.of(context).size.width,
             child:SingleChildScrollView(
               physics: BouncingScrollPhysics(),
               child: Column(
                 children: [
                    Lottie.asset('assets/images/55867-congratulation.json'),
                    Text('Your Product Has been sell'),
                    ...json.decode(event.data['selledProducts']).map(
                      (e)=>Text('$e',style: TextStyle(
                        fontWeight: FontWeight.bold
                      ),)
                    ).toList()
                 ],
               ),
             ) ,
           ),
         )
         );
    
  });



  // FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);
    }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          // color: Colors.tealAccent,
          padding: EdgeInsets.all(15),
          child: Column(
            //  mainAxisAlignment: MainAxisAlignment.center,

            children: <Widget>[
              SizedBox(
                height: 80,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    " Welcom  ",
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
                    "${vendorData.shopName}",
                    style: TextStyle(
                      //color: Colors.teal,
                      fontSize: 30,
                    ),
                  )
                ],
              ),

              SizedBox(
                height: 30,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    // color: Colors.red,
                    // padding: EdgeInsets.all(50),
                    width: MediaQuery.of(context).size.width * .9,
                    height: MediaQuery.of(context).size.width * .6,
                    margin: EdgeInsets.all(1),
                    // padding: EdgeInsets.all(50),
                    child: // Image.asset("assets/images/logo.png")

                        SvgPicture.asset(
                      "assets/images/logo.svg",
                    ),
                  ),
                ],
              ),
              // SvgPicture.asset("assets/images/nn.svg",width: 100,),
              SizedBox(
                height: 30,
              ),
              Row(
                children: [
                  Expanded(
                    child: InkWell(
                      onTap: () {
                        navigateTo(context, MyProducts());
                        /* FirebaseFirestore.instance
                            .collection("user")
                            .doc(vendorData.vId)
                            .collection("myProducts")
                            .get()
                            .then((value) {
                          print(value.docs[0].data());
                        }).catchError((error) {
                          print(error);
                        }); */
                      },
                      child: Container(
                        padding: EdgeInsets.all(10),
                        margin: EdgeInsets.fromLTRB(40, 10, 40, 10),
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          boxShadow: <BoxShadow>[
                            BoxShadow(
                                color: Colors.grey.withOpacity(0.5),
                                //color: Colors.blueGrey,
                                blurRadius: 5,
                                offset: Offset(15, 15))
                          ],
                          gradient: LinearGradient(
                            begin: Alignment.topRight,
                            end: Alignment.bottomLeft,
                            colors: [
                              Colors.lightBlueAccent,
                              Colors.blue,
                            ],
                          ),
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                          border: Border.all(color: Colors.grey, width: 1),
                        ),
                        child: Text("Manage Products",
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
              SizedBox(
                height: 10,
              ),
              Row(
                children: [
                  Expanded(
                    child: InkWell(
                      onTap: () {
                        navigateTo(context, HomeScreen());
                      },
                      child: Container(
                        padding: EdgeInsets.all(10),
                        margin: EdgeInsets.fromLTRB(40, 10, 40, 10),
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          boxShadow: <BoxShadow>[
                            BoxShadow(
                                color: Colors.grey.withOpacity(0.5),
                                blurRadius: 7,
                                offset: Offset(15, 17))
                          ],
                          gradient: LinearGradient(
                            begin: Alignment.topRight,
                            end: Alignment.bottomLeft,
                            colors: [
                              Colors.lightBlueAccent,
                              Colors.blue,
                            ],
                          ),
                          borderRadius: BorderRadius.all(Radius.circular(8)),
                          border: Border.all(color: Colors.grey, width: 1),
                        ),
                        child: Text("Brows as Customer",
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
              SizedBox(
                height: 10,
              ),
              Row(
                children: [
                  Expanded(
                    child: InkWell(
                      onTap: () {
                        navigateTo(context, VendorProf());
                        //   setState(() {});
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
                                offset: Offset(15, 20))
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
                        child: Text("Edite your Profile",
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
              Row(
                children: [
                  Expanded(
                    child: InkWell(
                      onTap: () {
                        FirebaseAuth.instance.signOut().then((value) {
                          vendorData = null;
                          userData = null;
                          navigateAndfinish(context, LoginUser());
                        });
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
                                offset: Offset(15, 20))
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
                        child: Text("LogOut",
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
            ],
          ),
        ),
      ),
      // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
