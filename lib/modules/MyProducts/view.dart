import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:iti_project/models/product_model.dart';
import 'package:iti_project/modules/Addproducts/view.dart';
import 'package:iti_project/modules/edit_product/view.dart';
import 'package:iti_project/modules/itemdetails/view.dart';
import 'package:iti_project/shared/component/components.dart';
import 'package:iti_project/shared/component/conestants.dart';

class MyProducts extends StatefulWidget {
  final docid;

  const MyProducts({Key key, this.docid}) : super(key: key);

  @override
  _CartState createState() => _CartState();
}

class _CartState extends State<MyProducts> {
  List<ProductModel> _myProducts = [];
  Future<List<ProductModel>> getProducts() async {
    _myProducts = [];
    await FirebaseFirestore.instance.collection("user").doc(vendorData.vId).collection("myProducts").get().then((value) {
      value.docs.forEach((element) {
        _myProducts.add(ProductModel.fromJson(element.data()));
      });
    }).catchError((error) {
      print(error);
    });
    return _myProducts;
  }

  @override
  void initState() {
    // getProducts();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size.width;
    return SafeArea(
        child: Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          icon: Icon(
            Icons.keyboard_backspace,
            color: Colors.black,
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          navigateTo(context, AddProduct());
        },
        child: Icon(Icons.add),
      ),

      body: ListView(
        children: [
          Container(
              padding: EdgeInsets.all(10),
              child: Column(children: [
                Container(
                  padding: EdgeInsets.all(10),
                  child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Text(
                      "MyProducts",
                      style: TextStyle(fontSize: 30),
                    )
                  ]),
                ),
                ///////
                FutureBuilder<List<ProductModel>>(
                    future: getProducts(),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        return snapshot.data.isEmpty
                            ? Container(height: MediaQuery.of(context).size.height * 0.6, child: Center(child: Text('There is no products found')))
                            : InkWell(
                                onTap: () {
                                  Navigator.of(context).push(MaterialPageRoute(builder: (context) {
                                    return ItemDetails();
                                  }));
                                },
                                child: ListView.builder(
                                    physics: NeverScrollableScrollPhysics(),
                                    shrinkWrap: true,
                                    itemCount: snapshot.data.length,
                                    itemBuilder: (context, i) {
                                      return Dismissible(
                                        onDismissed: () async {
                                          await FirebaseFirestore.instance
                                              .collection("user")
                                              .doc(vendorData.vId)
                                              .collection("myProducts")
                                              .doc(snapshot.data[i].pId)
                                              .delete();
                                          await FirebaseFirestore.instance.collection("products").doc(snapshot.data[i].pId).delete();
                                          await FirebaseStorage.instance.refFromURL(snapshot.data[i].imageUrl).delete().then((value) => AwesomeDialog(
                                              autoHide: Duration(seconds: 3),
                                              context: context,
                                              dialogType: DialogType.SUCCES,
                                              title: "Success",
                                              body: Text("Delete Success"))
                                            ..show());

                                          setState(() {});
                                        },
                                        key: UniqueKey(),
                                        child: InkWell(
                                          onTap: () {
                                            Navigator.of(context).push(MaterialPageRoute(builder: (context) {
                                              return ItemDetails(
                                                productModel: snapshot.data[i],
                                              );
                                            }));
                                          },
                                          child: Container(
                                            margin: EdgeInsets.all(10),
                                            height: 100,
                                            width: 50,
                                            decoration: BoxDecoration(
                                              color: Colors.white,
                                              boxShadow: [
                                                BoxShadow(
                                                  color: Colors.grey.withOpacity(0.5),
                                                  spreadRadius: 5,
                                                  blurRadius: 7,
                                                  offset: Offset(0, 3), // changes position of shadow
                                                ),
                                              ],
                                            ),
                                            child: Container(
                                              color: Colors.white,
                                              child: Row(
                                                children: [
                                                  Expanded(
                                                      child: ListTile(
                                                    isThreeLine: true,
                                                    leading: Image.network("${snapshot.data[i].imageUrl}"),
                                                    title:

                                                        ///catogry
                                                        Text("${snapshot.data[i].name}"),
                                                    subtitle: Column(
                                                      children: [
                                                        Row(
                                                            crossAxisAlignment: CrossAxisAlignment.start,
                                                            children: [Text("${snapshot.data[i].category}")]),
                                                        Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                                                          Text(
                                                            "${snapshot.data[i].price}",
                                                            style: TextStyle(color: Colors.blue),
                                                          )
                                                        ]),
                                                        SizedBox(
                                                          height: size * .03,
                                                        ),
                                                        Row(
                                                          crossAxisAlignment: CrossAxisAlignment.start,
                                                          children: [
                                                            InkWell(
                                                              onTap: () {
                                                                Navigator.of(context).push(MaterialPageRoute(builder: (context) {
                                                                  return EditeProduct(
                                                                    productModel: snapshot.data[i],
                                                                  );
                                                                }));
                                                              },
                                                              child: Container(
                                                                alignment: Alignment.center,
                                                                height: size * .08,
                                                                width: size * .1,
                                                                decoration: BoxDecoration(color: Colors.blue, borderRadius: BorderRadius.circular(5)),
                                                                child: Text(
                                                                  "Edit",
                                                                  style: TextStyle(fontWeight: FontWeight.bold),
                                                                ),
                                                              ),
                                                            ),
                                                          ],
                                                        )
                                                      ],
                                                    ),
                                                  )),
                                                  Container(
                                                    height: double.infinity,
                                                    color: Colors.blue,
                                                    child: IconButton(
                                                      onPressed: () async {
                                                        await FirebaseFirestore.instance
                                                            .collection("user")
                                                            .doc(vendorData.vId)
                                                            .collection("myProducts")
                                                            .doc(snapshot.data[i].pId)
                                                            .delete();
                                                        await FirebaseFirestore.instance.collection("products").doc(snapshot.data[i].pId).delete();
                                                        await FirebaseStorage.instance.refFromURL(snapshot.data[i].imageUrl).delete().then((value) =>
                                                            AwesomeDialog(
                                                                dialogType: DialogType.SUCCES,
                                                                autoHide: Duration(seconds: 3),
                                                                context: context,
                                                                title: "Success",
                                                                body: Text("Delete Success"))
                                                              ..show());
                                                        setState(() {});
                                                      },
                                                      icon: Icon(
                                                        Icons.close,
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                      );
                                    }),
                              );
                      }
                      return Center(
                        child: CircularProgressIndicator(),
                      );
                    })
              ])),
        ],
      ),
    ));
  }
}
