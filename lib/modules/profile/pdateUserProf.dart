import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:iti_project/models/userClass.dart';
import 'package:iti_project/models/vendorModel.dart';
import 'package:iti_project/modules/profile/userProfile.dart';
import 'package:iti_project/shared/component/components.dart';
import 'package:iti_project/shared/component/conestants.dart';

class UpdateUserProf extends StatefulWidget {
  // MyHomePage({Key? key, required this.title}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<UpdateUserProf> {
  TextEditingController addressController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();

  @override
  void initState() {
    super.initState();
    setDataToFields();
  }

  void setDataToFields() {
    nameController.text = userData.name;
    phoneController.text = userData.phone;
    addressController.text = userData.address;
    emailController.text = userData.email;
  }

  void updateProfile() {
    // loading(context);

    UserModel updateModel = UserModel(
        address: addressController.text,
        name: nameController.text,
        phone: phoneController.text,
        email: userData.email,
        uId: userData.uId);
    FirebaseFirestore.instance
        .collection("user")
        .doc(userData.uId)
        .update(updateModel.toMap())
        .then((value) {
      print("yousef  Data updatedddddd");
      FirebaseFirestore.instance
          .collection("user")
          .doc(userData.uId)
          .get()
          .then((value) {
        userData = UserModel.fromJson(value.data());
        print("yousef  Data get");
        print(userData.name);
      }).catchError((error) {
        print(error);

        showDialog(
            context: context,
            builder: (context) => AlertDialog(
                  title: Text(
                    'An Error with get data',
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
              navigateTo(context, UserProfile());
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
              child: Column(
                //  mainAxisAlignment: MainAxisAlignment.center,

                children: <Widget>[
                  SizedBox(
                    height: 2,
                  ),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        " UpdateProfil ",
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
                    // initialValue: name,
                    controller: nameController,

                    style: TextStyle(color: Colors.blue, fontSize: 18),

                    decoration: InputDecoration(
                        labelText: "Name",
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide:
                                BorderSide(color: Colors.black, width: 5))),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  TextFormField(
                    // initialValue: userData.phone,
                    // readOnly: true,
                    controller: phoneController,
                    // obscureText: true,

                    style: TextStyle(color: Colors.blue, fontSize: 18),

                    decoration: InputDecoration(
                        labelText: "Phone",
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide:
                                BorderSide(color: Colors.black, width: 5))),
                  ),

                  SizedBox(
                    height: 15,
                  ),
                  TextFormField(
                    controller: addressController,

                    //initialValue:'${userData.phone}',
                    style: TextStyle(color: Colors.blue, fontSize: 18),

                    decoration: InputDecoration(
                      hintText: "Enter your password",
                      labelText: "address",
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide:
                              BorderSide(color: Colors.black, width: 5)),
                      //  obscureText: true,

                     /*  suffixIcon: GestureDetector(
                        onTap: () {},
                        child: Icon(
                          Icons.location_on_outlined,
                          color: Colors.black38,
                          size: 35,
                        ),
                      ), */
                    ),
                  ),

                  SizedBox(
                    height: 15,
                  ),
                  TextFormField(
                    // readOnly: true,
                    controller: emailController,

                    style: TextStyle(color: Colors.blue, fontSize: 18),

                    decoration: InputDecoration(
                        /*
                        prefixIcon: Padding(
                          // padding: EdgeInsets.only(left: 40),
                          padding:  EdgeInsetsDirectional.only(start: 5.0),// add padding to adjust icon
                          child: Icon(Icons.location_on_outlined,size: 35,),
                        ),
                      */
                        labelText: "Email",
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide:
                                BorderSide(color: Colors.black, width: 5))),
                  ),

                 /*  SizedBox(
                    height: 10,
                  ),
                  TextFormField(
                    // obscureText: true,
                    initialValue: "*********",
                    readOnly: true,
                    // controller: controller,

                    style: TextStyle(color: Colors.blue, fontSize: 18),

                    decoration: InputDecoration(
                        labelText: "Password",
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide:
                                BorderSide(color: Colors.black, width: 5))),
                  ),

                  SizedBox(height: 15),
                  Row(
                    // mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Change your Password ?  ",
                        style: TextStyle(
                          color: Colors.blueGrey,
                          fontSize: 14,
                        ),
                      ),
                      InkWell(
                        onTap: () {},
                        child: Text(
                          "Reset",
                          style: TextStyle(
                            color: Colors.teal,
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ],
                  ),
 */
                  // SvgPicture.asset("assets/images/nn.svg",width: 100,),
                  SizedBox(
                    height: 30,
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: InkWell(
                          onTap: () {
                            updateProfile();

                             setDataToFields();
                            setState(() {});
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
                              borderRadius:
                                  BorderRadius.all(Radius.circular(8)),
                              border: Border.all(color: Colors.grey, width: 1),
                            ),
                            child: Text("Save",
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
        )
        // This trailing comma makes auto-formatting nicer for build methods.
        );
  }
}
