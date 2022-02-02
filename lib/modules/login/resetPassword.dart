import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:iti_project/models/product_model.dart';
import 'package:iti_project/models/userClass.dart';
import 'package:iti_project/models/vendorModel.dart';
import 'package:iti_project/modules/home/home_screen.dart';

import 'package:email_validator/email_validator.dart';
import 'package:iti_project/modules/login/loginUser.dart';


import 'package:iti_project/modules/vendor/vendor_mainPage.dart';
import 'package:iti_project/shared/component/components.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:iti_project/shared/component/conestants.dart';

class ResetPassword extends StatefulWidget {
 

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<ResetPassword> {

  bool validEmaill ;
   TextEditingController emailController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  void resetPass() {
    
loading(context);
    FirebaseAuth.instance

        .sendPasswordResetEmail(email: emailController.text)
        .then((value) {
          print("joooooooooo");
          Navigator.of(context).pop();
          navigateTo(context,LoginUser());
        })
        .catchError((error) {
      print(error);
       print("jooooooooooerrorrrrrrrrr");
       Navigator.of(context).pop();
    });  
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
            onPressed: () {
              Navigator.of(context).pop();
            },
            icon: Icon(Icons.arrow_back_sharp),
          ),
        ),
        body: Form(
           key: _formKey,
                  child: GestureDetector(
            onTap: () {
              FocusScope.of(context).unfocus();
            },
            child: Container(
              // color: Colors.tealAccent,
              padding: EdgeInsets.all(15),
              child: SingleChildScrollView(
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
                          " ResetPassword ",
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
                      controller: emailController,
                      // cursorColor: Colors.red,
                      keyboardType: TextInputType.text,
                      style: TextStyle(color: Colors.black,fontSize: 22),
                        validator: (String value) {
                           validEmaill = EmailValidator.validate(emailController.text);
                  
                          if (value.isEmpty || value==null||!validEmaill) {
                            return 'Please Enter password';
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
                      height: 40,
                    ),
                  
                 
                    Row(
                      children: [
                        Expanded(
                          child: InkWell(
                            onTap: () {
                               validEmaill = EmailValidator.validate(emailController.text);
                  
                              if(_formKey.currentState.validate())
                           resetPass();
                              //navigateTo(context, HomeScreen());
                              print("onnnnnn");
                            
                     ScaffoldMessenger.of(context)
                      .showSnackBar( SnackBar(content: Text('check your mail',style: TextStyle(
                       
                       fontSize: 25,
                       
                       ) ),
                     
                     )
                     );
                            },
                             
                          
                            child: Container(
                              padding: EdgeInsets.all(10),
                              margin: EdgeInsets.fromLTRB(20, 10, 20, 10),
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
                                borderRadius:
                                    BorderRadius.all(Radius.circular(5)),
                                border: Border.all(color: Colors.grey, width: 1),
                              ),
                              child: Text("SendRequest",
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
