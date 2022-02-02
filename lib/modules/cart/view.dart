import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:iti_project/models/cart_item_model.dart';
import 'package:iti_project/modules/address/addres_screen.dart';
import 'package:iti_project/modules/home/home_screen.dart';
import 'package:iti_project/shared/component/components.dart';
import 'package:iti_project/shared/component/conestants.dart';

class Cart extends StatefulWidget {
  static const routeName = '/cart';
  const Cart({Key key}) : super(key: key);

  @override
  _CartState createState() => _CartState();
}

class _CartState extends State<Cart> {
  List<CartItemModel> _myProducts = [];
  Future<List<CartItemModel>> getProducts() async {
    _myProducts = [];
    await FirebaseFirestore.instance
        .collection("user")
        .doc("${userData == null ? vendorData.vId : userData.uId}")
        .collection("mycart")
        .get()
        .then((value) {
      value.docs.forEach((element) {
        _myProducts.add(CartItemModel.fromJson(element.data()));
      });
    }).catchError((error) {
      print(error);
    });
    return _myProducts;
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
            Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (ctx) => HomeScreen()));
          },
          icon: Icon(
            Icons.keyboard_backspace,
            color: Colors.black,
          ),
        ),
      ),
      floatingActionButton: Container(
        alignment: Alignment.bottomCenter,
        padding: EdgeInsets.only(left: size * .09),
        child: FloatingActionButton.extended(
          onPressed: () {
            navigateTo(
                context,
                AddressScreen(
                  myProducts: _myProducts,
                ));
            // navigateTo(context, CheckOutScreen(myProducts: _myProducts));
          },
          label: Container(
            alignment: Alignment.center,
            width: size * .7,
            child: Text("continue"),
          ),
          backgroundColor: Colors.blue,
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
                      "Cart",
                      style: TextStyle(fontSize: 30),
                    )
                  ]),
                ),
                FutureBuilder<List<CartItemModel>>(
                    future: getProducts(),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        return snapshot.data.isEmpty
                            ? Container(height: MediaQuery.of(context).size.height * 0.6, child: Center(child: Text('There is no products found')))
                            : InkWell(
                                onTap: () {},
                                child: ListView.builder(
                                    physics: NeverScrollableScrollPhysics(),
                                    shrinkWrap: true,
                                    itemCount: snapshot.data.length,
                                    itemBuilder: (context, i) {
                                      return Dismissible(
                                        onDismissed: (diretion) async {
                                          await FirebaseFirestore.instance
                                              .collection("user")
                                              .doc("${userData == null ? vendorData.vId : userData.uId}")
                                              .collection("mycart")
                                              .doc("${snapshot.data[i].itemId}")
                                              .delete()
                                              .then((value) {
                                            setState(() {});
                                          }).catchError((error) {
                                            print(error);
                                          });

                                          setState(() {});
                                        },
                                        key: UniqueKey(),
                                        child: Container(
                                          margin: EdgeInsets.all(10),
                                          height: 130,
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
                                                  leading: Image.network("${snapshot.data[i].product.imageUrl}"),
                                                  title: Text("${snapshot.data[i].product.name}"),
                                                  subtitle: Column(
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    children: [
                                                      Row(
                                                          crossAxisAlignment: CrossAxisAlignment.start,
                                                          children: [Text("${snapshot.data[i].product.category}")]),
                                                      Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                                                        Text(
                                                          "${snapshot.data[i].totalPrice}",
                                                          style: TextStyle(color: Colors.blue),
                                                        )
                                                      ]),
                                                      if (snapshot.data[i].color != null)
                                                        Container(
                                                            alignment: AlignmentDirectional.centerStart,
                                                            height: 20,
                                                            width: 20,
                                                            decoration: BoxDecoration(
                                                                color: Color(int.parse('${snapshot.data[i].color}')), shape: BoxShape.circle)),
                                                      if (snapshot.data[i].size != null) Text('${snapshot.data[i].size}'),
                                                      Row(
                                                        mainAxisAlignment: MainAxisAlignment.start,
                                                        children: [
                                                          IconButton(
                                                              onPressed: () async {
                                                                await FirebaseFirestore.instance
                                                                    .collection("user")
                                                                    .doc("${userData == null ? vendorData.vId : userData.uId}")
                                                                    .collection("mycart")
                                                                    .doc("${snapshot.data[i].itemId}")
                                                                    .update(CartItemModel(
                                                                      itemCount: snapshot.data[i].itemCount > 1 ? snapshot.data[i].itemCount -= 1 : 1,
                                                                      totalPrice:
                                                                          double.parse(snapshot.data[i].product.price) * snapshot.data[i].itemCount,
                                                                      itemId: snapshot.data[i].itemId,
                                                                      product: snapshot.data[i].product,
                                                                      color: snapshot.data[i].color,
                                                                      size: snapshot.data[i].size,
                                                                    ).toMap())
                                                                    .then((value) {
                                                                  setState(() {});
                                                                }).catchError((error) {
                                                                  print(error);
                                                                });
                                                              },
                                                              icon: Icon(Icons.remove)),
                                                          Text("${snapshot.data[i].itemCount}"),
                                                          IconButton(
                                                              onPressed: () async {
                                                                if (snapshot.data[i].product.count <= snapshot.data[i].itemCount) {
                                                                  AwesomeDialog(
                                                                      autoHide: Duration(seconds: 3),
                                                                      context: context,
                                                                      dialogType: DialogType.INFO,
                                                                      title: "Note",
                                                                      body: Text("Out of count"))
                                                                    ..show();
                                                                } else {
                                                                  await FirebaseFirestore.instance
                                                                      .collection("user")
                                                                      .doc("${userData == null ? vendorData.vId : userData.uId}")
                                                                      .collection("mycart")
                                                                      .doc("${snapshot.data[i].itemId}")
                                                                      .update(CartItemModel(
                                                                        itemCount: snapshot.data[i].itemCount += 1,
                                                                        itemId: snapshot.data[i].itemId,
                                                                        totalPrice:
                                                                            double.parse(snapshot.data[i].product.price) * snapshot.data[i].itemCount,
                                                                        product: snapshot.data[i].product,
                                                                        color: snapshot.data[i].color,
                                                                        size: snapshot.data[i].size,
                                                                      ).toMap())
                                                                      .then((value) {
                                                                    setState(() {});
                                                                  }).catchError((error) {
                                                                    print(error);
                                                                  });
                                                                }
                                                              },
                                                              icon: Icon(Icons.add)),
                                                        ],
                                                      ),
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
                                                          .doc("${userData == null ? vendorData.vId : userData.uId}")
                                                          .collection("mycart")
                                                          .doc("${snapshot.data[i].itemId}")
                                                          .delete()
                                                          .then((value) {
                                                        setState(() {});
                                                      }).catchError((error) {
                                                        print(error);
                                                      });
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
                                      );
                                    }));
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
