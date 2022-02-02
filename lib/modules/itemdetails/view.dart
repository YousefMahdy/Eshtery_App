import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:carousel_pro/carousel_pro.dart';
import 'package:iti_project/models/cart_item_model.dart';
import 'package:iti_project/models/product_model.dart';
import 'package:iti_project/models/userClass.dart';
import 'package:iti_project/modules/address/addres_screen.dart';
import 'package:iti_project/modules/cart/view.dart';
import 'package:iti_project/shared/component/components.dart';
import 'package:iti_project/shared/component/conestants.dart';

class ItemDetails extends StatefulWidget {
  final ProductModel productModel;
  ItemDetails({Key key, this.productModel}) : super(key: key);

  @override
  _nameState createState() => _nameState();
}

class _nameState extends State<ItemDetails> {
  var rng = Random();
  bool favorite = true;
  int selectedindex = 0;
  String selectedSize;

  String selectColor;
  bool changebutton = false;

  bool change = false;
  double sideLength = 20;
  String vname = '';

  //////
  CollectionReference product = FirebaseFirestore.instance.collection("products");
  void deleteFavorite() async {
    await FirebaseFirestore.instance
        .collection("user")
        .doc(vendorData == null ? userData.uId : vendorData.vId)
        .collection("myFevorites")
        .doc(widget.productModel.pId)
        .delete();
  }

  void addFavorite() {
    // int id = rng.nextInt(4294967296);
    showLoading(context);

    FirebaseFirestore.instance
        .collection("user")
        .doc(vendorData == null ? userData.uId : vendorData.vId)
        .collection("myFevorites")
        .doc(widget.productModel.pId)
        .set(ProductModel(
          category: widget.productModel.category,
          count: widget.productModel.count,
          description: widget.productModel.description,
          disCount: widget.productModel.disCount,
          imageUrl: widget.productModel.imageUrl,
          name: widget.productModel.name,
          pId: widget.productModel.pId,
          price: widget.productModel.price,
          vendorId: vendorData == null ? userData.uId : vendorData.vId,
          colors: widget.productModel.colors,
          size: widget.productModel.size,
        ).toMap())
        .then((value) {
      Navigator.of(context).pop();

      //  Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (ctx) => MyProducts()));
    }).catchError((error) {
      print(error);
    });
  }

  @override
  void initState() {
    super.initState();
    FirebaseFirestore.instance
        .collection("user")
        .doc(userData == null ? vendorData.vId : userData.uId)
        .collection("myFevorites")
        .where("pId", isEqualTo: widget.productModel.pId)
        .get()
        .then((value) {
      print(value.docs);
      if (value.docs.isNotEmpty) {
        favorite = false;
      }
      setState(() {});
    }).catchError((error) {
      print(error);
    });
    FirebaseFirestore.instance.collection("user").doc(widget.productModel.vendorId).get().then((value) {
      //print(value.docs);

      vname = value.data()['name'];
      setState(() {});
    }).catchError((error) {
      print(error);
    });
    if (widget.productModel.colors.isNotEmpty) selectColor = widget.productModel.colors[0];
    if (widget.productModel.size.isNotEmpty) selectedSize = widget.productModel.size[0];
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size.width;

    return SafeArea(
        child: Scaffold(
      appBar: AppBar(
          leading: IconButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            icon: Icon(
              Icons.keyboard_backspace,
              color: Colors.black,
            ),
          ),
          /* actions: [
            IconButton(
                onPressed: () {}, icon: Icon(Icons.search, color: Colors.black))
          ], */
          backgroundColor: Colors.transparent,
          elevation: 0),
      // bottomNav

      bottomNavigationBar: Container(
          height: 50,
          child: Row(children: [
            Expanded(
                child: InkWell(
              onTap: () {
                print(selectColor);
                int itemId = rng.nextInt(4294967296);
                FirebaseFirestore.instance
                    .collection("user")
                    .doc("${userData == null ? vendorData.vId : userData.uId}")
                    .collection("mycart")
                    .doc("$itemId")
                    .set(CartItemModel(
                            itemCount: 1,
                            totalPrice: double.parse(widget.productModel.price),
                            itemId: itemId.toString(),
                            size: selectedSize,
                            color: selectColor,
                            product: widget.productModel)
                        .toMap())
                    .then((value) {
                  Navigator.of(context).push(MaterialPageRoute(builder: (context) {
                    return Cart(
                        //list: snapshot.data.docs[i],
                        );
                  }));
                });

                setState(() {
                  changebutton = true;
                });
              },
              child: Container(
                color: changebutton ? Colors.blue : Colors.grey,
                alignment: Alignment.center,
                child: Text(
                  "ADD CART",
                  style: TextStyle(color: changebutton ? Colors.white : Colors.black),
                ),
              ),
            )),

            ///
            Expanded(
                child: InkWell(
              onTap: () {
                int itemId = rng.nextInt(4294967296);
                navigateTo(
                    context,
                    AddressScreen(
                      myProducts: [
                        CartItemModel(
                            itemCount: 1,
                            totalPrice: double.parse(widget.productModel.price),
                            itemId: itemId.toString(),
                            size: selectedSize,
                            color: selectColor,
                            product: widget.productModel)
                      ],
                    ));
                setState(() {
                  changebutton = false;
                });
              },
              child: Container(
                color: changebutton ? Colors.grey : Colors.blue,
                alignment: Alignment.center,
                child: Text("BUY NOW", style: TextStyle(color: changebutton ? Colors.black : Colors.white)),
              ),
            )),
          ])),

      body: ListView(
        children: [
          Container(
            padding: EdgeInsets.all(15),
            child: Column(
              children: [
                Container(
                  height: size * .5,
                  width: double.infinity,
                  child: Carousel(
                    boxFit: BoxFit.contain,
                    autoplay: true,
                    animationCurve: Curves.fastOutSlowIn,
                    dotSize: 6.0,
                    dotIncreasedColor: Colors.blue,
                    dotBgColor: Colors.transparent,
                    dotPosition: DotPosition.bottomLeft,
                    dotVerticalPadding: 10.0,
                    showIndicator: true,
                    indicatorBgPadding: 7.0,
                    images: [Image.network("${widget.productModel.imageUrl}")],
                  ),
                ),
                SizedBox(height: size * .04),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Text(
                        "${widget.productModel.name}",
                        style: TextStyle(fontSize: size * .06),
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        if (favorite == true) {
                          favorite = !favorite;
                          addFavorite();
                          setState(() {});
                        } else {
                          favorite = !favorite;
                          deleteFavorite();
                          setState(() {});
                        }
                      },
                      child: Container(
                        padding: EdgeInsets.only(right: 40),
                        child: favorite
                            ? Icon(
                                Icons.favorite_border,
                              )
                            : Icon(
                                Icons.favorite,
                                color: Colors.red,
                              ),
                      ),
                    )
                  ],
                ),
                SizedBox(height: size * .04),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("${widget.productModel.price}", style: TextStyle(fontSize: size * .05, color: Colors.blue)),
                    SizedBox(
                      width: size * .03,
                    ),
                    Text("${widget.productModel.disCount}", style: TextStyle(decoration: TextDecoration.lineThrough))
                  ],
                ),
                Divider(
                  color: Colors.black,
                  height: size * .08,
                  thickness: .2,
                ),
                Row(children: [
                  Container(
                    alignment: Alignment.center,
                    width: size * .2,
                    height: size * .1,
                    decoration: BoxDecoration(
                      color: Colors.blue,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      "4.5",
                      style: TextStyle(fontSize: 20, color: Colors.white),
                    ),
                  ),
                  SizedBox(
                    width: size * .04,
                  ),
                  Text("$vname", style: TextStyle(fontSize: 15)),
                ]),
                Divider(
                  color: Colors.black,
                  height: size * .08,
                  thickness: .2,
                ),
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text("Description"),
                  SizedBox(height: size * .05),
                  SelectableText("${widget.productModel.description}", enableInteractiveSelection: true)
                ]),
                Divider(
                  color: Colors.black,
                  height: size * .08,
                  thickness: .2,
                ),
                Offstage(
                  offstage: widget.productModel.colors.isEmpty && widget.productModel.size.isEmpty,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      InkWell(
                        onTap: () {
                          setState(() {
                            change = true;
                          });
                        },
                        child: Text(
                          "Select Size",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                      SizedBox(
                        width: size * .03,
                      ),
                      InkWell(
                        onTap: () {
                          setState(() {
                            change = false;
                          });
                        },
                        child: Text(
                          "Select Color",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                ),
                Offstage(
                  offstage: widget.productModel.colors.isEmpty && widget.productModel.size.isEmpty,
                  child: Divider(
                    color: Colors.black,
                    height: size * .08,
                    thickness: .2,
                  ),
                ),
                Visibility(
                  visible: change,
                  child: Container(
                      height: size * .15,
                      child: Container(
                        height: size * .14,
                        child: ListView.separated(
                            scrollDirection: Axis.horizontal,
                            itemBuilder: (context, index) => InkWell(
                                  onTap: () {
                                    setState(() {
                                      selectedSize = widget.productModel.size[index];
                                    });
                                  },
                                  child: Container(
                                    alignment: Alignment.center,
                                    height: size * .14,
                                    width: size * .14,
                                    color: widget.productModel.size[index] == selectedSize ? Colors.blue : Colors.grey[200],
                                    child: Text(
                                      '${widget.productModel.size[index]}',
                                      style: TextStyle(color: widget.productModel.size[index] == selectedSize ? Colors.white : Colors.black),
                                    ),
                                  ),
                                ),
                            separatorBuilder: (context, index) => SizedBox(width: 10),
                            itemCount: widget.productModel.size.length),
                      )),
                  replacement: Container(
                      width: double.infinity,
                      height: size * .15,
                      child: Container(
                        height: size * .14,
                        child: ListView.separated(
                            scrollDirection: Axis.horizontal,
                            itemBuilder: (context, index) => InkWell(
                                  onTap: () {
                                    setState(() {
                                      selectColor = widget.productModel.colors[index];
                                    });
                                  },
                                  child: Container(
                                    padding: const EdgeInsets.all(2),
                                    decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        border: widget.productModel.colors[index] == selectColor ? Border.all(color: Colors.black, width: 2) : null),
                                    child: Container(
                                      alignment: Alignment.center,
                                      height: 30,
                                      width: 30,
                                      decoration: BoxDecoration(color: Color(int.parse(widget.productModel.colors[index])), shape: BoxShape.circle),
                                    ),
                                  ),
                                ),
                            separatorBuilder: (context, index) => SizedBox(width: 10),
                            itemCount: widget.productModel.colors.length),
                      )),
                ),
              ],
            ),
          ),
        ],
      ),
    ));
  }
}
