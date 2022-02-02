import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:iti_project/models/userClass.dart';
import 'package:iti_project/models/vendorModel.dart';
import 'package:iti_project/shared/component/components.dart';
import 'package:iti_project/shared/component/conestants.dart';

class VendorProf extends StatefulWidget {
  // MyHomePage({Key? key, required this.title}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<VendorProf> {
  TextEditingController addressController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController shopNameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  String imageProfile =
      "https://firebasestorage.googleapis.com/v0/b/eshtery-5c660.appspot.com/o/vendors%2Fimage_picker8738134844125703500.jpg?alt=media&token=aef900b0-e377-49b8-b8d4-9d84cd1853b8";
  File image;

  final picker = ImagePicker();
  bool readOnly = true;

  Future getImage() async {
    final pickedFile = await picker.getImage(source: ImageSource.gallery);

    setState(() {
      if (pickedFile != null) {
        image = File(pickedFile.path);
        print("image piked");
      } else {
        print('No image selected.');
      }
    });
  }

  @override
  void initState() {
    super.initState();
    setDataToFields();
  }

  void setDataToFields() {
    shopNameController.text = vendorData.shopName;
    phoneController.text = vendorData.phone;
    addressController.text = vendorData.address;
    emailController.text = vendorData.email;
    imageProfile = vendorData.imageProfile;
  }

  Future<void> updateProfile() async {
    if (image == null) {
      loading(context);
      VendorModel updatModel = VendorModel(
          shopName: shopNameController.text,
          phone: phoneController.text,
          address: addressController.text,
          imageProfile: imageProfile,
          email: vendorData.email,
          vId: vendorData.vId);

      await FirebaseFirestore.instance
          .collection("user")
          .doc(vendorData.vId)
          .update(updatModel.toMap())
          .then((value) async {
        await FirebaseFirestore.instance
            .collection("user")
            .doc(vendorData.vId)
            .get()
            .then((value) {
          vendorData = VendorModel.fromJson(value.data());
          print("yousef  Data get");
          print(vendorData.shopName);
          print(vendorData.imageProfile);
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
    } else {
      await firebase_storage.FirebaseStorage.instance
          .ref()
          .child('vendors/${Uri.file(image.path).pathSegments.last}')
          .putFile(image)
          .then((value) async {
        await value.ref.getDownloadURL().then((value) {
          // print(value);
          imageProfile = value;
          print(imageProfile);
          print("uplodeddddddddddddddddddddddddddd");
        }).catchError((error) {});
      }).catchError((error) {
        print(error);
      }).then((value) async {
        loading(context);
        VendorModel updatModel = VendorModel(
            shopName: shopNameController.text,
            phone: phoneController.text,
            address: addressController.text,
            imageProfile: imageProfile,
            email: vendorData.email,
            vId: vendorData.vId);

        await FirebaseFirestore.instance
            .collection("user")
            .doc(vendorData.vId)
            .update(updatModel.toMap())
            .then((value) async {
          await FirebaseFirestore.instance
              .collection("user")
              .doc(vendorData.vId)
              .get()
              .then((value) {
            vendorData = VendorModel.fromJson(value.data());
            print("yousef  Data get");
            print(vendorData.shopName);
            print(vendorData.imageProfile);
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
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          elevation: 0,
          automaticallyImplyLeading: false,
          backgroundColor: Colors.white10,
          //centerTitle: true,
          titleSpacing: 0,
          title: Text('YourProfile',
              style: TextStyle(
                color: Colors.blueGrey,
                fontWeight: FontWeight.bold,
                // backgroundColor: Colors.black12,
                fontSize: 25,
              )),

          iconTheme: IconThemeData(color: Colors.black),
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back_sharp,
            ),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          actions: [
            //IconButton(icon: Icon(Icons.account_circle), onPressed: () => {}),
            Container(
              padding: EdgeInsets.only(top: 15, right: 0, left: 0),
              child: InkWell(
                onTap: () {
                  readOnly = !readOnly;
                  setState(() {});
                },
                child: Text("Edite",
                    style: TextStyle(
                      color: Colors.blue,
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                      decoration: TextDecoration.underline,
                    )),
              ),
            ),
            IconButton(
              icon: new Icon(Icons.edit),
              alignment: Alignment.center,
              padding: new EdgeInsets.all(0.0),
              onPressed: () {},
            ),
            // defaultText
          ],
        ),
        body: GestureDetector(
          onTap: () {
            FocusScope.of(context).unfocus();
          },
          child: Container(
            padding: EdgeInsets.all(15),
            child: SingleChildScrollView(
              child: Column(
                //  mainAxisAlignment: MainAxisAlignment.center,

                children: <Widget>[
                  Stack(children: [
                    Container(
                      //color: Colors.lightGreen,
                      height: 140,
                      width: double.infinity,
                      decoration: BoxDecoration(
                          boxShadow: <BoxShadow>[
                            BoxShadow(
                                color: Colors.grey.withOpacity(0.5),
                                blurRadius: 1,
                                offset: Offset(2, 7))
                          ],
                          border: Border.all(width: 2, color: Colors.grey),
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(8),
                            topRight: Radius.circular(8),
                          ),
                          color: Colors.white70,
                          image: DecorationImage(
                              image: image == null
                                  ? NetworkImage(imageProfile)
                                  //AssetImage("assets/images/clothes.jpg")
                                  : FileImage(image),
                              fit: BoxFit.cover)),
                    ),
                    PositionedDirectional(
                      bottom: 3,
                      end: 3,
                      child: InkWell(
                        onTap: () {
                          getImage();
                          print("yes");
                        },
                        child: Container(
                          padding: EdgeInsets.all(5),
                          decoration: BoxDecoration(
                              color: Colors.blue, shape: BoxShape.circle),
                          child: Icon(
                            Icons.camera_alt,
                            color: Colors.white,
                            size: 25,
                          ),
                        ),
                      ),
                    )
                  ]),
                  SizedBox(
                    height: 2,
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  TextFormField(
                    readOnly: true,
                    controller: shopNameController,
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
                    readOnly: readOnly,
                    controller: phoneController,

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
                    readOnly: readOnly,
                    style: TextStyle(color: Colors.blue, fontSize: 18),
                    decoration: InputDecoration(
                      labelText: "address",
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide:
                              BorderSide(color: Colors.black, width: 5)),
                      //  obscureText: true,

                      /* suffixIcon: GestureDetector(
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
                    readOnly: readOnly,
                    controller: emailController,
                    // obscureText: true,

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
                  ), */
                 /*  TextFormField(
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
                  ), */
                  SizedBox(
                    height: 30,
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: InkWell(
                          onTap: () async {
                            await updateProfile();

                            print("okkkkkkkkkkk");

                            setState(() {});
                            Navigator.of(context).pop();
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
