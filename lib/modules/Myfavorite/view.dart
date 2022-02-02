import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:iti_project/models/product_model.dart';
import 'package:iti_project/modules/Addproducts/view.dart';
import 'package:iti_project/modules/edit_product/view.dart';
import 'package:iti_project/modules/home/home_screen.dart';
import 'package:iti_project/modules/itemdetails/view.dart';
import 'package:iti_project/shared/component/components.dart';
import 'package:iti_project/shared/component/conestants.dart';

class Myfavorite extends StatefulWidget {
  final docid;

  const Myfavorite({Key key, this.docid}) : super(key: key);

  @override
  _CartState createState() => _CartState();
}

class _CartState extends State<Myfavorite> {
  List<ProductModel> _myProducts = [];
  Future<List<ProductModel>> getProducts() async {
    _myProducts = [];
    await FirebaseFirestore.instance
        .collection("user")
        .doc(vendorData == null ? userData.uId : vendorData.vId)
        .collection("myFevorites")
        .get()
        .then((value) {
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
            userData!=null?
            navigateAndfinish(context, HomeScreen()):Navigator.of(context).pop();
          },
          icon: Icon(
            Icons.keyboard_backspace,
            color: Colors.black,
          ),
        ),
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
                      "Favorites",
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
                                        onDismissed: (diretion) async {
                                          await FirebaseFirestore.instance
                                              .collection("user")
                                              .doc(vendorData == null ? userData.uId : vendorData.vId)
                                              .collection("myFevorites")
                                              .doc(snapshot.data[i].pId)
                                              .delete()
                                              .then((value) => AwesomeDialog(
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
                                          
                                            Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) {
                                              return ItemDetails(
                                                productModel: snapshot.data[i],
                                              );
                                            }));
                                          },
                                          child: Container(
                                            margin: EdgeInsets.all(10),
                                            height: size * .35,
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
                                            child: Row(
                                              children: [
                                                Container(
                                                  height: double.infinity,
                                                  width: size * .3,
                                                  padding: EdgeInsets.all(5),
                                                  child: Image.network(snapshot.data[i].imageUrl),
                                                ),
                                                Expanded(
                                                  child: Column(
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    children: [
                                                      SizedBox(
                                                        height: 8,
                                                      ),
                                                      Row(children: [
                                                        Text(
                                                            "${snapshot.data[i].name}",
                                                            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                                                          ),
                                                        
                                                      ]),
                                                      SizedBox(
                                                        height: 8,
                                                      ),
                                                      Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                                                        Expanded(
                                                          child: Text(
                                                          "${snapshot.data[i].category}",
                                                          style: TextStyle(
                                                            fontSize: 18,
                                                            //  fontWeight: FontWeight.bold
                                                          ),
                                                        )
                                                        ),
                                                      ]),
                                                      SizedBox(
                                                        height: 7,
                                                      ),
                                                      Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                                                        Text(
                                                          "price ",
                                                          style: TextStyle(
                                                            fontSize: 16,
                                                            //  fontWeight: FontWeight.bold
                                                          ),
                                                        ),
                                                        Text(
                                                          "${snapshot.data[i].price}",
                                                          style: TextStyle( color: Colors.blue),
                                                        )
                                                      ]),
                                                      SizedBox(
                                                        height: 4,
                                                      ),
                                                      /* Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                                                        Text(
                                                          "disc ",
                                                          style: TextStyle(
                                                            fontSize: 16,
                                                            //  fontWeight: FontWeight.bold
                                                          ),
                                                        ),
                                                        Text(
                                                          "${snapshot.data[i].disCount}",
                                                          style: TextStyle(color: Colors.blue),
                                                        )
                                                      ]),
                                                      SizedBox(
                                                          // height: size * .03,
                                                          ), */
                                                    ],
                                                  ),
                                                ),
                                                Container(
                                                  height: double.infinity,
                                                  color: Colors.blue,
                                                  child: IconButton(
                                                    onPressed: () async {
                                                      await FirebaseFirestore.instance
                                                          .collection("user")
                                                          .doc(vendorData == null ? userData.uId : vendorData.vId)
                                                          .collection("myFevorites")
                                                          .doc(snapshot.data[i].pId)
                                                          .delete()
                                                          .then((value) => AwesomeDialog(
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
                                            /*
                                      Container(
                                        color: Colors.green,
                                        child: 
                                        
                                        Row(
                                          children: [
                                            Expanded(
                                                child: ListTile(
                                              isThreeLine: true,
                                              leading: Image.network(
                                                  "${snapshot.data[i].imageUrl}"),
                                              title:

                                                  ///catogry
                                                  Text(
                                                      "${snapshot.data[i].category}"),
                                              subtitle: Column(
                                                children: [
                                                  Row(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Text(
                                                            "${snapshot.data[i].name}")
                                                      ]),
                                                  Row(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Text(
                                                          "${snapshot.data[i].price}",
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.blue),
                                                        )
                                                      ]),
                                                  SizedBox(
                                                    height: size * .03,
                                                  ),
                                                  Row(
                                                   // crossAxisAlignment:
                                                       // CrossAxisAlignment
                                                         //   .start,
                                                     
                                                    children: [
                                                      InkWell(
                                                        onTap: () {
                                                          Navigator.of(context).push(
                                                              MaterialPageRoute(
                                                                  builder:
                                                                      (context) {
                                                            return EditeProduct(
                                                              productModel:
                                                                  snapshot
                                                                      .data[i],
                                                            );
                                                          }));
                                                        },
                                                        child: Container(
                                                          alignment:
                                                              Alignment.center,
                                                          height: size * .08,
                                                          width: size * .1,
                                                          decoration: BoxDecoration(
                                                              color:
                                                                  Colors.blue,
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          5)),
                                                          child: Text(
                                                            "buy",
                                                            style: TextStyle(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold),
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
                                                  await FirebaseFirestore
                                                      .instance
                                                      .collection("user")
                                                      .doc(vendorData.vId)
                                                      .collection("myFevorites")
                                                      .doc(snapshot.data[i].pId)
                                                      .delete()
                                                  
                                                      .then((value) =>
                                                          AwesomeDialog(
                                                            dialogType: DialogType.SUCCES,
                                                              autoHide:
                                                                  Duration(
                                                                      seconds:
                                                                          3),
                                                              context: context,
                                                              title: "Success",
                                                              body: Text(
                                                                  "Delete Success"))
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
                                      ),*/
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
