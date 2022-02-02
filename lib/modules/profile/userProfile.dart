import 'package:flutter/material.dart';
import 'package:iti_project/shared/component/components.dart';
import 'package:iti_project/shared/component/conestants.dart';

import 'pdateUserProf.dart';

class UserProfile extends StatefulWidget {
  // MyHomePage({Key? key, required this.title}) : super(key: key);

  @override
  _UserProfileState createState() => _UserProfileState();
}

class _UserProfileState extends State<UserProfile> {
  
   @override
  void initState() {
    // TODO: implement initState
    super.initState();
  setState(() { });
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
            onPressed: (){
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
            padding: EdgeInsets.all(20),
            child: SingleChildScrollView(
              child: Column(
               

                children: <Widget>[
                  
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        " Profile ",
                        style: TextStyle(
                          //color: Colors.teal,
                          fontSize: 33,
                          //  fontWeight: FontWeight.bold,
                        ),
                      )
                    ],
                  ),
                  SizedBox(height: 20),
                  Row(
                    children: [
                      Text(
                        "Name",
                        style: TextStyle(
                          color: Colors.grey,
                          fontSize: 20,
                        ),
                      )
                    ],
                  ),
                  Row(
                    children: [
                      Text(
                        userData.name,
                        style: TextStyle(
                          // color: Colors.grey,
                          fontSize: 18,
                        ),
                      )
                    ],
                  ),

                  Divider(
                    color: Colors.black,
                    height: 30,
                    thickness: .1,
                  ),
                  Row(
                    children: [
                      Text(
                        "Phone",
                        style: TextStyle(
                          color: Colors.grey,
                          fontSize: 20,
                        ),
                      )
                    ],
                  ),
                  Row(
                    children: [
                      Text(
                        userData.phone,
                        style: TextStyle(
                          // color: Colors.grey,
                          fontSize: 18,
                        ),
                      )
                    ],
                  ),

                  Divider(
                    color: Colors.black,
                    height: 30,
                    thickness: .1,
                  ),
                  Row(
                    children: [
                      Text(
                        "Adress",
                        style: TextStyle(
                          color: Colors.grey,
                          fontSize: 20,
                        ),
                      )
                    ],
                  ),
                  Row(
                    children: [
                      Text(
                        userData.address,
                        style: TextStyle(
                          // color: Colors.grey,
                          fontSize: 18,
                        ),
                      )
                    ],
                  ),

                  Divider(
                    color: Colors.black,
                    height: 30,
                    thickness: .1,
                  ),

                  Row(
                    children: [
                      Text(
                        "Email",
                        style: TextStyle(
                          color: Colors.grey,
                          fontSize: 20,
                        ),
                      )
                    ],
                  ),
                  Row(
                    children: [
                      Text(
                        userData.email,
                        style: TextStyle(
                          // color: Colors.grey,
                          fontSize: 18,
                        ),
                      )
                    ],
                  ),

                  /* Divider(
                    color: Colors.black,
                    height: 30,
                    thickness: .1,
                  ),
                  Row(
                    children: [
                      Text(
                        "Password",
                        style: TextStyle(
                          color: Colors.grey,
                          fontSize: 20,
                        ),
                      )
                    ],
                  ),
                  Row(
                    children: [
                      Text(
                        "*********",
                        style: TextStyle(
                          // color: Colors.grey,
                          fontSize: 18,
                        ),
                      )
                    ],
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Row(
                    //mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "ChangePassword ?    ",
                        style: TextStyle(
                          color: Colors.blueGrey,
                          fontSize: 14,
                        ),
                      ),
                      InkWell(
                        onTap: () {},
                        child: Text(
                          "reset ",
                          style: TextStyle(
                            color: Colors.teal,
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ],
                  ), */
                  // SvgPicture.asset("assets/images/nn.svg",width: 100,),
                  SizedBox(
                    height: 80,
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: InkWell(
                          onTap: () {
                             Navigator.of(context).pop();
                            navigateTo(context, UpdateUserProf());
                              
                          },
                          child: Container(
                            padding: EdgeInsets.all(10),
                            margin: EdgeInsets.fromLTRB(60, 10, 60, 10),
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
                                  BorderRadius.all(Radius.circular(8)),
                              border: Border.all(color: Colors.grey, width: 1),
                            ),
                            child: Text("EditeProfile",
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
                ],
              ),
            ),
          ),
        )
        // This trailing comma makes auto-formatting nicer for build methods.
        );
  }
}
