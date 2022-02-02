import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:iti_project/models/cart_item_model.dart';
import 'package:iti_project/models/product_model.dart';
import 'package:iti_project/modules/cart/view.dart';
import 'package:iti_project/shared/component/conestants.dart';

class MyOrder extends StatefulWidget {
  MyOrder({Key key}) : super(key: key);

  @override
  _MyOrderState createState() => _MyOrderState();
}

class _MyOrderState extends State<MyOrder> {
  List<CartItemModel> _myProducts = [];
  Future<List<CartItemModel>> getProducts() async {
    _myProducts = [];
    await FirebaseFirestore.instance
        .collection("user")
        .doc("${userData==null?vendorData.vId:userData.uId}")
        .collection("myorder")
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
                  child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "My orders",
                          style: TextStyle(fontSize: 30),
                        )
                      ]),
                ),
                FutureBuilder<List<CartItemModel>>(
                    future: getProducts(),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        return snapshot.data.isEmpty
                            ? Container(
                                height:
                                    MediaQuery.of(context).size.height * 0.6,
                                child: Center(
                                    child: Text('There is no products found')))
                            : ListView.builder(
                                physics: NeverScrollableScrollPhysics(),
                                shrinkWrap: true,
                                itemCount: snapshot.data.length,
                                itemBuilder: (context, i) {
                                  return Container(
                                    margin: EdgeInsets.all(10),
                                    height: 140,
                                    width: 50,
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.grey.withOpacity(0.5),
                                          spreadRadius: 5,
                                          blurRadius: 7,
                                          offset: Offset(0,
                                              3), // changes position of shadow
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
                                            leading: Image.network(
                                                "${snapshot.data[i].product.imageUrl}"),
                                            title: Text(
                                                "${snapshot.data[i].product.name}"),
                                            subtitle: Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Row(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Text(
                                                          "${snapshot.data[i].product.category}")
                                                    ]),
                                                Row(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Text(
                                                        "${snapshot.data[i].totalPrice}",
                                                        style: TextStyle(
                                                            color: Colors.blue),
                                                      )
                                                    ]),
                                                    if(snapshot.data[i].color!=null)
                                                      Container(
                                      alignment: AlignmentDirectional.centerStart,
                                      height: 20,
                                      width: 20,
                                      decoration: BoxDecoration(color: Color(int.parse('${snapshot.data[i].color}')), shape: BoxShape.circle)),
                                       if(snapshot.data[i].size!=null)
                                       Text('${snapshot.data[i].size}'),



                                                Row(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    ElevatedButton(
                                                      onPressed: () {
                                                        FirebaseFirestore
                                                            .instance
                                                            .collection("user")
                                                            .doc(
                                                                "${userData==null?vendorData.vId:userData.uId}")
                                                            .collection(
                                                                "mycart")
                                                            .doc(
                                                                "${snapshot.data[i].itemId}")
                                                            .set(snapshot
                                                                .data[i]
                                                                .toMap())
                                                            .then((value) {
                                                          Navigator.of(context).push(
                                                              MaterialPageRoute(
                                                                  builder:
                                                                      (context) {
                                                            return Cart(
                                                                //list: snapshot.data.docs[i],
                                                                );
                                                          })).catchError(
                                                              (error) {
                                                            print(error);
                                                          });
                                                        });
                                                      },
                                                      child: Text(
                                                        "Order Again",
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          )),
                                        ],
                                      ),
                                    ),
                                  );
                                });
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
