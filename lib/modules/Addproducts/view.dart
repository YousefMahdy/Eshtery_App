import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:iti_project/models/product_model.dart';
import 'package:iti_project/modules/MyProducts/view.dart';
import 'package:iti_project/shared/component/components.dart';
import 'package:iti_project/shared/component/conestants.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

class AddProduct extends StatefulWidget {
  AddProduct({Key key}) : super(key: key);

  @override
  _AddProductState createState() => _AddProductState();
}

class _AddProductState extends State<AddProduct> {
  var selectcatogry;
  int counter = 1;
  var rng = Random();
  final _nameController = TextEditingController();
  final _desciptionController = TextEditingController();
  final _priceController = TextEditingController();
  final _discountController = TextEditingController();

  File _image;
  final picker = ImagePicker();
  List<String> colors = [];
  List<String> sizes = [];

  /* Future getImage() async {
    final pickedFile = await picker.getImage(source: ImageSource.gallery);

    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      } else {
        print('No image selected.');
      }
    });
  } */

  void addProduct() {
    print(colors);
    int id = rng.nextInt(4294967296);
    showLoading(context);

    firebase_storage.FirebaseStorage.instance.ref().child('products/${Uri.file(_image.path).pathSegments.last}').putFile(_image).then((value) {
      value.ref.getDownloadURL().then((value) {
        FirebaseFirestore.instance
            .collection("user")
            .doc(vendorData.vId)
            .collection("myProducts")
            .doc("$id")
            .set(ProductModel(
                    category: selectcatogry,
                    count: counter,
                    description: _desciptionController.text,
                    disCount: _discountController.text,
                    imageUrl: value,
                    name: _nameController.text,
                    pId: id.toString(),
                    price: _priceController.text,
                    vendorId: vendorData.vId,
                    colors: colors,
                    size: sizes
                    )
                .toMap())
            .then((value) {})
            .catchError((error) {
          print(error);
        });
        FirebaseFirestore.instance
            .collection("products")
            .doc("$id")
            .set(ProductModel(
                    category: selectcatogry,
                    count: counter,
                    description: _desciptionController.text,
                    disCount: _discountController.text,
                    imageUrl: value,
                    name: _nameController.text,
                    pId: id.toString(),
                    price: _priceController.text,
                    vendorId: vendorData.vId,
                    colors: colors,
                    size: sizes,
                    )
                .toMap())
            .then((value) {
          Navigator.of(context).pop();
          Navigator.of(context).pop();
          Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (ctx) => MyProducts()));
        }).catchError((error) {
          print(error);
        });
      }).catchError((error) {
        print(error.toString());
      });
    }).catchError((error) {
      print(error.toString());
    });
  }

  showbottomsheet(context) async {
    return showModalBottomSheet(
        context: context,
        builder: (context) {
          return Container(
            padding: EdgeInsets.all(20),
            height: 180,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Edite image",
                  style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                ),
                InkWell(
                  onTap: () async {
                    var pickedFile = await picker.getImage(source: ImageSource.gallery);

                    if (pickedFile != null) {
                      _image = File(pickedFile.path);

                      Navigator.of(context).pop();
                      setState(() {});
                    }
                  },
                  child: Container(
                    width: double.infinity,
                    padding: EdgeInsets.all(10),
                    child: Row(
                      children: [
                        Icon(
                          Icons.collections,
                          size: 30,
                        ),
                        SizedBox(
                          width: 20,
                        ),
                        Text(
                          "From Gallery",
                          style: TextStyle(fontSize: 20),
                        )
                      ],
                    ),
                  ),
                ),
                InkWell(
                  onTap: () async {
                    var pickedFile = await picker.getImage(source: ImageSource.camera);

                    if (pickedFile != null) {
                      _image = File(pickedFile.path);

                      Navigator.of(context).pop();
                      setState(() {});
                    }
                  },
                  child: Container(
                    width: double.infinity,
                    padding: EdgeInsets.all(10),
                    child: Row(
                      children: [
                        Icon(
                          Icons.photo_camera,
                          size: 30,
                        ),
                        SizedBox(
                          width: 20,
                        ),
                        Text(
                          "From camera",
                          style: TextStyle(fontSize: 20),
                        )
                      ],
                    ),
                  ),
                )
              ],
            ),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size.width;
    return Scaffold(
      body: ListView(
        children: [
          Container(
            padding: EdgeInsets.all(15),
            child: Column(
              children: [
                Container(
                  height: size * .5,
                  width: double.infinity,
                  child: Center(
                    child: _image == null ? Text('No image selected.') : Image.file(_image),
                  ),
                ),
                ElevatedButton(
                    onPressed: () {
                      showbottomsheet(context);
                    },
                    child: Text("Pick Image")),
                TextFormField(
                    controller: _nameController,
                    decoration: InputDecoration(
                      labelText: "name",
                    )),
                SizedBox(
                  height: size * .02,
                ),
                DropdownButton(
                  hint: Text("Catogry"),
                  items: catogry
                      .map((e) => DropdownMenuItem(
                            child: Text("$e"),
                            value: e,
                          ))
                      .toList(),
                  onChanged: (val) {
                    setState(() {
                      selectcatogry = val;
                    });
                  },
                  value: selectcatogry,
                ),
                SizedBox(
                  height: size * .02,
                ),
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text(
                    "Description :",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: size * .06),
                  ),
                  SizedBox(height: size * .05),
                  TextFormField(
                    controller: _desciptionController,
                    maxLines: null,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                  SizedBox(height: size * .03),
                  Row(
                    children: [
                      Text("Price :", style: TextStyle(fontWeight: FontWeight.bold, fontSize: size * .05)),
                      Spacer(),
                      SizedBox(
                        height: size * .1,
                        width: size * .3,
                        child: TextFormField(
                          controller: _priceController,
                          decoration: InputDecoration(border: OutlineInputBorder()),
                          keyboardType: TextInputType.number,
                        ),
                      ),
                    ],
                  ),
                  Divider(
                    color: Colors.black,
                    height: size * .08,
                    thickness: .2,
                  ),
                  Row(
                    children: [
                      Text("Discount :", style: TextStyle(fontWeight: FontWeight.bold, fontSize: size * .05)),
                      Spacer(),
                      SizedBox(
                        height: size * .1,
                        width: size * .3,
                        child: TextFormField(
                          controller: _discountController,
                          decoration: InputDecoration(border: OutlineInputBorder()),
                          keyboardType: TextInputType.number,
                        ),
                      ),
                    ],
                  ),
                  Divider(
                    color: Colors.black,
                    height: size * .08,
                    thickness: .2,
                  ),
                  Row(
                    children: [
                      Text("Count :", style: TextStyle(fontWeight: FontWeight.bold, fontSize: size * .05)),
                      Spacer(),
                      Row(
                        children: [
                          IconButton(
                              onPressed: () {
                                setState(() {
                                  if (counter > 1) {
                                    counter--;
                                  } else
                                    return null;
                                });
                              },
                              icon: Icon(Icons.remove)),
                          Text("$counter"),
                          IconButton(
                              onPressed: () {
                                setState(() {
                                  counter++;
                                });
                              },
                              icon: Icon(Icons.add)),
                        ],
                      ),
                    ],
                  ),
                  Divider(
                    color: Colors.black,
                    height: size * .08,
                    thickness: .2,
                  ),
                  Row(
                    children: [
                      Text("Colors :", style: TextStyle(fontWeight: FontWeight.bold, fontSize: size * .05)),
                      Expanded(
                          child: Row(
                        children: colors
                            .map((e) => Container(
                                  margin: const EdgeInsetsDirectional.only(start: 10),
                                  height: 30,
                                  width: 30,
                                  decoration: BoxDecoration(color:Color(int.parse(e)), shape: BoxShape.circle),
                                ))
                            .toList(),
                      )),
                      Offstage(
                        offstage: colors.isEmpty,
                        child: InkWell(
                            onTap: () {
                              colors.removeLast();
                              setState(() {});
                            },
                            child: Icon(Icons.clear)),
                      ),
                      IconButton(
                          icon: Icon(Icons.add),
                          onPressed: () {
                            showDialog(
                                context: context,
                                builder: (context) => Dialog(
                                      child: Container(
                                        alignment: Alignment.center,
                                        height: MediaQuery.of(context).size.width * 0.2,
                                        child: Container(
                                          width: 200,
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                            children: productColors
                                                .map((e) => InkWell(
                                                      onTap: () {
                                                        if (!colors.contains(e)) colors.add(e);
                                                        Navigator.of(context).pop();
                                                        setState(() {});
                                                      },
                                                      child: Container(
                                                        height: 30,
                                                        width: 30,
                                                        decoration: BoxDecoration(color: Color(int.parse(e)), shape: BoxShape.circle),
                                                      ),
                                                    ))
                                                .toList(),
                                          ),
                                        ),
                                      ),
                                    ));
                          }),
                    ],
                  ),
                 
                   Divider(
                    color: Colors.black,
                    height: size * .08,
                    thickness: .2,
                  ),
                  Row(
                    children: [
                      Text("Size :", style: TextStyle(fontWeight: FontWeight.bold, fontSize: size * .05)),
                      Expanded(
                          child: Row(
                        children: sizes
                            .map((e) => Container(
                                  margin: const EdgeInsetsDirectional.only(start: 10),
                                  child: Text('$e',
                                  style: TextStyle(
                                    fontSize: 20
                                  ),),
                                ))
                            .toList(),
                      )),
                      Offstage(
                        offstage: sizes.isEmpty,
                        child: InkWell(
                            onTap: () {
                              sizes.removeLast();
                              setState(() {});
                            },
                            child: Icon(Icons.clear)),
                      ),
                      IconButton(
                          icon: Icon(Icons.add),
                          onPressed: () {
                            showDialog(
                                context: context,
                                builder: (context) => Dialog(
                                      child: Container(
                                        alignment: Alignment.center,
                                        height: MediaQuery.of(context).size.width * 0.2,
                                        child: Container(
                                          width: 200,
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                            children: productsize
                                                .map((e) => InkWell(
                                                      onTap: () {
                                                        if (!sizes.contains(e)) sizes.add(e);
                                                        Navigator.of(context).pop();
                                                        setState(() {});
                                                      },
                                                      child: Text('$e'),
                                                    ))
                                                .toList(),
                                          ),
                                        ),
                                      ),
                                    ));
                          }),
                    ],
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Container(
                          width: double.infinity,
                          decoration: BoxDecoration(color: Colors.blue, borderRadius: BorderRadius.circular(5)),
                          child: MaterialButton(
                            //function
                            onPressed: () {
                              addProduct();
                            },
                            child: Text(
                              "ADD",
                              style: TextStyle(color: Colors.white),
                            ),
                          )),
                    ],
                  )
                ]),
              ],
            ),
          )
        ],
      ),
    );
  }
}
