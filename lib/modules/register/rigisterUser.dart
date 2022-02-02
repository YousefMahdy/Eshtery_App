import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:email_auth/email_auth.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:iti_project/models/userClass.dart';
import 'package:iti_project/modules/home/home_screen.dart';
import 'package:iti_project/shared/component/components.dart';
import 'package:iti_project/shared/component/conestants.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/tap_bounce_container.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

class RigsterUser extends StatefulWidget {
  // MyHomePage({Key? key, required this.title}) : super(key: key);

  @override
  _RigsterUserState createState() => _RigsterUserState();
}

class _RigsterUserState extends State<RigsterUser> {
  int counter = 0;
  bool valuefirst = false;
  bool valuesecond = false;
  bool _passwordVisible = false;
  final _formKey = GlobalKey<FormState>();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController otp = TextEditingController();

  void register() {
    loading(context);
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
              actions: [
                TextButton(
                  onPressed: () async {
                    var res = await EmailAuth.validate(receiverMail: emailController.text, userOTP: otp.text);
                    // print(otp.text);
                    if (res) {
                      topsnackbar(context, "Your account is verified");
                      FirebaseAuth.instance
                          .createUserWithEmailAndPassword(email: emailController.text, password: passwordController.text)
                          .then((value) {
                        UserModel model = UserModel(
                          name: nameController.text,
                          email: value.user.email,
                          uId: value.user.uid,
                          phone: phoneController.text,
                          verfiedEmail: true,
                        );
                        FirebaseFirestore.instance.collection("user").doc(value.user.uid).set(model.toMap()).then((value) {
                          Navigator.of(context).pop();
                          userData = model;
                          navigateAndfinish(context, HomeScreen());
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
                                ));
                      });
                    } else
                      topsnackbar(context, "Verification faild. Please try again");
                  },
                  child: Text("Ok"),
                ),
                TextButton(
                  onPressed: () async {
                    EmailAuth.sessionName = "Sample";
                    var res = await EmailAuth.sendOtp(receiverMail: emailController.text);
                    if (res) {
                      topsnackbar(context, " Please check your email");
                    } else
                      print("error");
                  },
                  child: Text("Resend"),
                ),
              ],
              title: Text("Thanks for signing up we just need you to verify your email address"),
              content: TextFormField(
                controller: otp,
                decoration: InputDecoration(hintText: "Enter OTP"),
              ));
        });

    //   UserModel model = UserModel(
    //       name: nameController.text,
    //       email: value.user.email,
    //       uId: value.user.uid,
    //       phone: phoneController.text);
    //   FirebaseFirestore.instance
    //       .collection("user")
    //       .doc(value.user.uid)
    //       .set(model.toMap())
    //       .then((value) {
    //     // Navigator.of(context).pop();
    //     // Navigator.of(context).pop();
    //   }).catchError((error) {
    //     Navigator.of(context).pop();
    //     showDialog(
    //         context: context,
    //         builder: (context) => AlertDialog(
    //               title: Text(
    //                 'An Error',
    //                 style: TextStyle(
    //                   color: Colors.red,
    //                 ),
    //               ),
    //               content: Text(error.toString()),
    //               actions: [
    //                 TextButton(
    //                   onPressed: () {
    //                     Navigator.of(context).pop();
    //                   },
    //                   child: Text('تم'),
    //                 )
    //               ],
    //             ));
    //   });
    // }).catchError((error) {
    //   Navigator.of(context).pop();
    //   showDialog(
    //       context: context,
    //       builder: (context) => AlertDialog(
    //             title: Text(
    //               'An Error',
    //               style: TextStyle(
    //                 color: Colors.red,
    //               ),
    //             ),
    //             content: Text(error.toString()),
    //             actions: [
    //               TextButton(
    //                 onPressed: () {
    //                   Navigator.of(context).pop();
    //                 },
    //                 child: Text('تم'),
    //               )
    //             ],
    //           ));
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
          leading: IconButton(
            icon: Icon(Icons.arrow_back_sharp),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
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
                    SizedBox(
                      height: 30,
                    ),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                          " SignUp ",
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
                    TextFormField(
                      controller: nameController,
                      // cursorColor: Colors.red,
                      keyboardType: TextInputType.text,
                      style: TextStyle(color: Colors.black),
                      validator: (String value) {
                        if (value.isEmpty) {
                          return 'Please Enter name';
                        }
                        return null;
                      },
                      decoration: InputDecoration(
                        hintText: "Enter your Name ",
                        labelText: "Name",
                        // border: InputBorder.none,
                      ),
                    ),
                    TextFormField(
                      controller: emailController,
                      // onChanged: ,
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
                        hintText: "Enter your Email",
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
                        hintText: "Enter your password",
                        labelText: "Password",
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

                    TextFormField(
                      keyboardType: TextInputType.text,
                      //  controller: _userPasswordController,
                      obscureText: true,
                      //This will obscure text dynamically
                      validator: (String value) {
                        if (value != passwordController.text) {
                          return 'Password not match';
                        }
                        return null;
                      },
                      decoration: InputDecoration(
                        labelText: 'ConfirmPassword',
                        hintText: 'Re Enter your Password',
                        // Here is key idea
                        /*   suffixIcon: IconButton(
                          icon: Icon(
                            // Based on passwordVisible state choose the icon
                            _passwordVisible
                                ? Icons.visibility
                                : Icons.visibility_off,
                            // color: Theme.of(context).primaryColorDark,
                          ),
                          onPressed: () {
                            setState(() {
                              _passwordVisible = !_passwordVisible;
                            });
                          }
                        ),*/
                      ),
                    ),
                    TextFormField(
                      controller: phoneController,
                      // cursorColor: Colors.red,
                      keyboardType: TextInputType.text,
                      style: TextStyle(color: Colors.black),
                      validator: (String value) {
                        if (value.isEmpty) {
                          return 'Please Enter phone';
                        }
                        return null;
                      },
                      decoration: InputDecoration(
                        hintText: "Enter your phone",
                        labelText: "phone",
                        // border: InputBorder.none,
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    //  TextField(),

                    // SvgPicture.asset("assets/images/nn.svg",width: 100,),
                    SizedBox(
                      height: 40,
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: InkWell(
                            onTap: () async {
                              if (_formKey.currentState.validate()) {
                                EmailAuth.sessionName = "Sample";
                                var res = await EmailAuth.sendOtp(receiverMail: emailController.text);

                                register();
                              }

                              //print(emailController.text);
                              ////  setState(() {});
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
                                borderRadius: BorderRadius.all(Radius.circular(8)),
                                border: Border.all(color: Colors.grey, width: 1),
                              ),
                              child: Text("SignUp",
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
                    SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Already have an account ?  ",
                          style: TextStyle(
                            color: Colors.blueGrey,
                            fontSize: 14,
                          ),
                        ),
                        InkWell(
                          onTap: () {
                            Navigator.of(context).pop();
                          },
                          child: Text(
                            "Sign in",
                            style: TextStyle(
                              color: Colors.teal,
                              fontSize: 14,
                            ),
                          ),
                        ),
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
