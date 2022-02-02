import 'dart:math';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

import 'package:firebase_auth/firebase_auth.dart';
import 'package:iti_project/models/product_model.dart';
import 'package:iti_project/modules/MyProducts/view.dart';
import 'package:iti_project/modules/vendor/vendor_mainPage.dart';
import 'package:iti_project/shared/component/components.dart';
import 'package:iti_project/shared/component/conestants.dart';
import 'package:path/path.dart';
import 'package:carousel_pro/carousel_pro.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';

class EditeProduct extends StatefulWidget {
  final ProductModel productModel;
  EditeProduct({Key key, this.productModel}) : super(key: key);

  @override
  _EditeProductState createState() => _EditeProductState();
}

class _EditeProductState extends State<EditeProduct> {
  var name, description, price, discount, imageurl;
  GlobalKey<FormState> formstate = new GlobalKey<FormState>();
  var selectcatogry;
  
  File _image;

  int _counter;

  var picker = ImagePicker();
   List<dynamic> colors = [];
  List<dynamic> sizes = [];

   @override
  void initState() {
    
    super.initState();
    selectcatogry=widget.productModel.category;
    _counter=widget.productModel.count;
    sizes=widget.productModel.size??[];
    colors=widget.productModel.colors??[];
  }

  editeProduct(context) async {
    var formdata = formstate.currentState;
    if (_image == null) {
      if (formdata.validate()) {
        showLoading(context);
        formdata.save();
        /* await firebase_storage.FirebaseStorage.instance
        .ref()
        .child('products/${Uri.file(_image.path).pathSegments.last}')
        .putFile(_image); */

        await FirebaseFirestore.instance
            .collection("user")
            .doc(vendorData.vId)
            .collection("myProducts")
            .doc("${widget.productModel.pId}")
            .update(ProductModel(
              pId: widget.productModel.pId,
              imageUrl: widget.productModel.imageUrl,
              description: description,
              name: name,
              price: price,
              vendorId: vendorData.vId,
              disCount: discount,
              category: selectcatogry,
              count: _counter,
              size: sizes,
              colors: colors,
            ).toMap())
            .then((value) {
         
         
        });

        await FirebaseFirestore.instance
            .collection("products")
            .doc("${widget.productModel.pId}")
            .update(ProductModel(
              pId: widget.productModel.pId,
              imageUrl: widget.productModel.imageUrl,
              description: description,
              name: name,
              price: price,
              vendorId: vendorData.vId,
              disCount: discount,
              category: selectcatogry,
              count: _counter,
              size: sizes,
              colors: colors,
            ).toMap())
            .then((value) {
          Navigator.of(context).pop();
          Navigator.of(context).pop();
               Navigator.of(context).pushReplacement( MaterialPageRoute(builder: (ctx) => MyProducts()));
        });
      }
    } else {
      var formdata = formstate.currentState;
      if (formdata.validate()) {
        showLoading(context);
        formdata.save();
        await firebase_storage.FirebaseStorage.instance
            .ref()
            .child('products/${Uri.file(_image.path).pathSegments.last}')
            .putFile(_image)
            .then((value) {
              firebase_storage.FirebaseStorage.instance.refFromURL(widget.productModel.imageUrl).delete();
          value.ref.getDownloadURL().then((value) async {
            await FirebaseFirestore.instance
                .collection("user")
                .doc(vendorData.vId)
                .collection("myProducts")
                .doc("${widget.productModel.pId}")
                .update(ProductModel(
                  pId: widget.productModel.pId,
                  imageUrl: value,
                  description: description,
                  name: name,
                  price: price,
                  vendorId: vendorData.vId,
                  disCount: discount,
                  category: selectcatogry,
                  count: _counter,
                  size: sizes,
              colors: colors,
                ).toMap())
                .then((value) {
             
            });

            await FirebaseFirestore.instance
                .collection("products")
                .doc("${widget.productModel.pId}")
                .update(ProductModel(
                  pId: widget.productModel.pId,
                  imageUrl: value,
                  description: description,
                  name: name,
                  price: price,
                  vendorId: vendorData.vId,
                  disCount: discount,
                  category: selectcatogry,
                  count: _counter,
                  size: sizes,
              colors: colors,
                ).toMap())
                .then((value) {
                   Navigator.of(context).pop();
               Navigator.of(context).pop();
               Navigator.of(context).pushReplacement( MaterialPageRoute(builder: (ctx) => MyProducts()));
            });
          });
        });
      }
    }
  }

  /////////////
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
                    var pickedFile =
                        await picker.getImage(source: ImageSource.gallery);

                    if (pickedFile != null) {
                      _image = File(pickedFile.path);
                     
                      
                      Navigator.of(context).pop();
                      setState(() {
                        
                      });
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
                    var pickedFile =
                        await picker.getImage(source: ImageSource.camera);

                    if (pickedFile != null) {
                      _image = File(pickedFile.path);
                      
                      Navigator.of(context).pop();
                      setState(() {
                        
                      });
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

////////
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size.width;
    return Scaffold(
      body: Form(
        key: formstate,
        child: ListView(
          children: [
            Container(
              padding: EdgeInsets.all(15),
              child: Column(
                children: [
                  Container(
                    height: size * .5,
                    width: double.infinity,
                    child: Center(
                        child: _image != null
                            ? Image.file(_image)
                            : Image.network("${widget.productModel.imageUrl}")
                        // _image == null
                        //     ? Image.network("${widget.list['imageurl']}")
                        //     : Image.file(_image),
                        ),
                  ),
                  ElevatedButton(
                      onPressed: () {
                        showbottomsheet(context);
                      },
                      child: Text("Pick Image")),
                  TextFormField(
                      initialValue: widget.productModel.name,
                      validator: (val) {
                        if (val.isEmpty) {
                          return " You must enter name";
                        } else
                          return null;
                      },
                      onSaved: (val) {
                        name = val;
                      },
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
                  Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Description :",
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: size * .06),
                        ),
                        SizedBox(height: size * .05),
                        TextFormField(
                          initialValue:widget.productModel.description,
                          validator: (val) {
                            if (val.isEmpty) {
                              return " You must enter description";
                            } else
                              return null;
                          },
                          onSaved: (val) {
                            description = val;
                          },
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
                            Text("Price :",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: size * .05)),
                            Spacer(),
                            SizedBox(
                              height: size * .1,
                              width: size * .3,
                              child: TextFormField(
                                initialValue: widget.productModel.price,
                                validator: (val) {
                                  if (val.isEmpty) {
                                    return " You must enter price";
                                  } else
                                    return null;
                                },
                                onSaved: (val) {
                                  price = val;
                                },
                                decoration: InputDecoration(
                                    border: OutlineInputBorder()),
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
                            Text("Discount :",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: size * .05)),
                            Spacer(),
                            SizedBox(
                              height: size * .1,
                              width: size * .3,
                              child: TextFormField(
                                initialValue: widget.productModel.disCount,
                                validator: (val) {
                                  if (val.isEmpty) {
                                    return " You must enter discount";
                                  } else
                                    return null;
                                },
                                onSaved: (val) {
                                  discount = val;
                                },
                                decoration: InputDecoration(
                                    border: OutlineInputBorder()),
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
                            Text("Count :",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: size * .05)),
                            Spacer(),
                            Row(
                              children: [
                                IconButton(
                                    onPressed: () {
                                      setState(() {
                                        if (_counter > 1) {
                                          _counter--;
                                        } else
                                          return null;
                                      });
                                    },
                                    icon: Icon(Icons.remove)),
                                Text('$_counter'),
                                IconButton(
                                    onPressed: () {
                                      setState(() {
                                        _counter++;
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
                                  decoration: BoxDecoration(color: Color(int.parse(e)), shape: BoxShape.circle),
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
                                decoration: BoxDecoration(
                                    color: Colors.blue,
                                    borderRadius: BorderRadius.circular(5)),
                                child: MaterialButton(
                                  //function
                                  onPressed: () async {
                                    await editeProduct(context);
                                  },
                                  child: Text(
                                    "Save",
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
      ),
    );
  }
}
