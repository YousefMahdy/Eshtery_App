import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:iti_project/models/userClass.dart';
import 'package:iti_project/models/vendorModel.dart';
import 'package:iti_project/modules/home/home_screen.dart';
import 'package:iti_project/modules/login/resetPassword.dart';
import 'package:iti_project/modules/register/rigisterUser.dart';
import 'package:iti_project/modules/register/vendor/vendorRigister.dart';
import 'package:iti_project/modules/vendor/vendor_mainPage.dart';
import 'package:iti_project/shared/component/components.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:iti_project/shared/component/conestants.dart';

class LoginUser extends StatefulWidget {
  // MyHomePage({Key? key, required this.title}) : super(key: key);

  @override
  _LoginUserState createState() => _LoginUserState();
}

class _LoginUserState extends State<LoginUser> {
  int counter = 0;
  bool valuefirst = false;
  bool valuesecond = false;
  bool _passwordVisible = false;
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  void loginAuth() {
    loading(context);
    FirebaseAuth.instance.signInWithEmailAndPassword(email: emailController.text, password: passwordController.text).then((value) {
      final String uid = value.user.uid;
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
    }).catchError((error) {
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
              ));
    });
    print("done");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          elevation: 0,
          automaticallyImplyLeading: false,
          backgroundColor: Colors.white10,
          centerTitle: true,
         
          iconTheme: IconThemeData(color: Colors.black),
          /* leading: IconButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            icon: Icon(Icons.arrow_back_sharp),
          ), */
        ),
        body: GestureDetector(
          onTap: () {
            FocusScope.of(context).unfocus();
          },
          child: Container(
            // color: Colors.tealAccent,
            padding: EdgeInsets.all(15),
            child: SingleChildScrollView(
              child: Form(
                key: _formKey,
                child: Column(
                  //  mainAxisAlignment: MainAxisAlignment.center,

                  children: <Widget>[
                    
                    Image.asset(
                    "assets/images/logo.png",
                    width: MediaQuery.of(context).size.width * .7,
                  ),
                  /*  SizedBox(
                      height: 30,
                    ),  */

                   /*  Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          " Login ",
                          style: TextStyle(
                            //color: Colors.teal,
                            fontSize: 30,
                          ),
                        )
                      ],
                    ), */
                    SizedBox(
                      height: 30,
                    ),
                    TextFormField(
                      controller: emailController,
                      // cursorColor: Colors.red,
                      keyboardType: TextInputType.text,
                      style: TextStyle(color: Colors.black),
                      validator: (String value) {
                        if (value.isEmpty) {
                          return 'Please Enter email';
                        }
                        return null;
                      },
                      decoration: InputDecoration(
                        hintText: "username",
                        labelText: "Email",
                        // border: InputBorder.none,
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    TextFormField(
                      controller: passwordController,
                      obscureText: !_passwordVisible,
                      // cursorColor: Colors.black,
                      style: TextStyle(color: Colors.black),
                      validator: (String value) {
                        if (value.isEmpty) {
                          return 'Please Enter password';
                        }
                        return null;
                      },
                      decoration: InputDecoration(
                        hintText: "Password",
                        labelText: "password",
                        //  obscureText: true,

                        suffixIcon: GestureDetector(
                          onTap: () {
                            setState(() {
                              _passwordVisible = !_passwordVisible;
                            });
                          },
                          child: Icon(
                            // Based on passwordVisible state choose the icon
                            _passwordVisible ? Icons.visibility_outlined : Icons.visibility_off_outlined,
                            // color: Theme.of(context).primaryColorDark,

                            color: Colors.black38,
                          ),
                        ),
                      ),
                    ),

                    SizedBox(
                      height: 20,
                    ),
                    //  TextField(),

                    Row(
                      //mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "ForgetPassword ?    ",
                          style: TextStyle(
                            color: Colors.blueGrey,
                            fontSize: 14,
                          ),
                        ),
                        InkWell(
                          onTap: () {
                            navigateTo(context,ResetPassword());
                          },
                          child: Text(
                            "reset ",
                            style: TextStyle(
                              color: Colors.teal,
                              fontSize: 14,
                            ),
                          ),
                        ),
                      ],
                    ),
                    // SvgPicture.asset("assets/images/nn.svg",width: 100,),
                    SizedBox(
                      height: 70,
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: InkWell(
                            onTap: () {
                              if (_formKey.currentState.validate()) loginAuth();
                              //navigateTo(context, HomeScreen());
                            },
                            child: Container(
                              padding: EdgeInsets.all(10),
                              margin: EdgeInsets.fromLTRB(20, 10, 20, 10),
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                boxShadow: <BoxShadow>[BoxShadow(color: Colors.grey.withOpacity(0.5), blurRadius: 10, offset: Offset(15, 20))],
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
                    //SizedBox(height: 50,),
                    Row(
                      children: [
                        Text("Dont hav an account ?"),
                        Expanded(
                          child: InkWell(
                            onTap: () {
                              if (valuefirst) {
                                navigateTo(context, RigsterVendor());
                              } else {
                                navigateTo(context, RigsterUser());
                              }
                            },
                            child: Container(
                              padding: EdgeInsets.all(10),
                              // margin: EdgeInsets.fromLTRB(40, 10, 40, 10),
                              //alignment: Alignment.center,

                              child: Text("Signup",
                                  style: TextStyle(
                                    color: Colors.green,
                                    fontSize: 16,
                                  )),
                            ),
                          ),
                        ),
                        Text("vendor"),
                        Checkbox(
                          value: this.valuefirst,
                          onChanged: (value) {
                            setState(() {
                              // this.valuefirst = value;
                              this.valuefirst = value;
                            });
                          },
                        )
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        )
        // This trailing comma makes auto-formatting nicer for build methods.
        );
  }
}
