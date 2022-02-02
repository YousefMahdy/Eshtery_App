import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:iti_project/models/cart_item_model.dart';
import 'package:iti_project/modules/Confirmation/view.dart';
import 'package:iti_project/shared/component/components.dart';
import 'package:iti_project/shared/component/conestants.dart';

class CheckOutScreen extends StatefulWidget {
  final List<CartItemModel> myProducts;
  final String address;
  CheckOutScreen({this.myProducts, this.address});

  @override
  _CheckOutScreenState createState() => _CheckOutScreenState();
}

class _CheckOutScreenState extends State<CheckOutScreen> {
  double subTotal = 0.0;

  int discount = 0;
  double total = 0.0;
  @override
  void initState() {
    super.initState();
    widget.myProducts.forEach((element) {
      subTotal += element.totalPrice;
    });
    if (subTotal > 100) {
      discount = 5;
    }
    if (subTotal > 200) {
      discount = 10;
    }
    print(discount);

    total = subTotal - (subTotal * (discount / 100)) + 10;
  }

  @override
  Widget build(BuildContext context) {
    final _size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        actions: [
          InkWell(onTap: () {}, child: Image.asset('assets/images/Notofication.png')),
        ],
      ),
      body: LayoutBuilder(
        builder: (context, constrains) => SingleChildScrollView(
          child: ConstrainedBox(
            constraints: BoxConstraints(
              minHeight: constrains.maxHeight,
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(children: [
                    Row(
                      children: [
                        Text(
                          'CheckOut',
                          style: TextStyle(fontSize: 25),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    ListView.separated(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemBuilder: (context, index) => _buildCheckOutItem(_size, widget.myProducts[index]),
                        separatorBuilder: (context, index) => SizedBox(
                              height: 20,
                            ),
                        itemCount: widget.myProducts.length),
                    SizedBox(
                      height: 20,
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            '${widget.address}',
                            style: TextStyle(
                              fontSize: 18,
                            ),
                          ),
                        ),
                        Icon(
                          Icons.circle,
                          size: 12,
                          color: Colors.blue,
                        )
                      ],
                    ),
                    SizedBox(
                      height: 40,
                    ),
                    buildPaymentItem('Subtotal', '\$$subTotal'),
                    SizedBox(
                      height: 10,
                    ),
                    buildPaymentItem('Discount', '$discount%'),
                    SizedBox(
                      height: 10,
                    ),
                    buildPaymentItem('Sipping', '\$10.00'),
                    SizedBox(
                      height: 10,
                    ),
                    Divider(
                      thickness: 1.5,
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    buildPaymentItem('Total', '\$ $total'),
                    SizedBox(
                      height: _size.width * 0.15,
                    ),
                  ]),
                  defultAppButton(_size, 'Buy', () {
                    final dio = Dio();
                    widget.myProducts.forEach((element) {
                      //if(element.product.count>element.itemCount)
                      element.product.count = element.product.count - element.itemCount;
                      element.address=widget.address;
                      element.phone=userData == null ? vendorData.phone : userData.phone;
                      FirebaseFirestore.instance
                          .collection("user")
                          .doc("${userData == null ? vendorData.vId : userData.uId}")
                          .collection("myorder")
                          .doc("${element.itemId}")
                          .set(element.toMap())
                          .then((value) {});

                      FirebaseFirestore.instance
                          .collection("user")
                          .doc("${element.product.vendorId}")
                          .collection("myProducts")
                          .doc("${element.product.pId}")
                          .update(element.product.toMap())
                          .then((value) {});

                      FirebaseFirestore.instance.collection("products").doc("${element.product.pId}").update(element.product.toMap()).then((value) {});

                      FirebaseFirestore.instance.collection("owner").doc("${element.itemId}").set(element.toMap()).then((value) {});
                    });

                    ///////
                    FirebaseFirestore.instance
                        .collection("user")
                        .doc("${userData == null ? vendorData.vId : userData.uId}")
                        .collection("mycart")
                        .get()
                        .then((value) {
                      value.docs.forEach((element) async {
                        await element.reference.delete();
                      });

                      navigateTo(context, Confirmation());
                    });
                    List<String> vendorsIds = [];
                    widget.myProducts.forEach((element) {
                      if (!vendorsIds.contains(element.product.vendorId)) vendorsIds.add(element.product.vendorId);
                    });
                    print(vendorsIds);
                    vendorsIds.forEach((vendorId) {
                      FirebaseFirestore.instance.collection('user').doc('$vendorId').get().then((value) {
                        List<CartItemModel> selledProducts = widget.myProducts.where((cartItem) => cartItem.product.vendorId == vendorId).toList();
                        List<String> selledPoductsName = [];
                        selledProducts.forEach((element) {
                          selledPoductsName.add(element.product.name);
                        });
                        //print(value.data());
                        dio.post('https://fcm.googleapis.com/fcm/send',
                            options: Options(
                              headers: {
                                'Content-Type': 'application/json',
                                'Authorization':
                                    'key=AAAAWb64Ov4:APA91bFhLm2lnzpt06qQQEdJrwSqn5agcA4lAO3f0EsKPhnU47SptXdOiGJjPMTA6wHq2J7PL2BcN-h-m6fgOBAuafo7o07nUoG2eTgSQyeNqMHQZs3tBon007Eg8VwsR2Bg2WAS0oeR',
                              },
                            ),
                            data: {
                              "to": "${value.data()['fcmId']}",
                              "notification": {"body": "your product has been sell", "title": "Congratulations"},
                              'android': {
                                'priority': 'HIGH',
                                'notification': {
                                  'notification_priority': 'PRIORITY_MAX',
                                  'sound': 'default',
                                  'default_sound': true,
                                  'default_viberate_timings': true,
                                  'default_light_settings': true
                                }
                              },
                              "data": {
                                "click_action": "FLUTTER_NOTIFICATION_CLICK",
                                "selledProducts": selledPoductsName,
                              }
                            });
                      });
                    });
                  }),
                  SizedBox(
                    height: 10,
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

Widget _buildCheckOutItem(Size size, CartItemModel productModel) => Card(
      elevation: 5.0,
      clipBehavior: Clip.antiAliasWithSaveLayer,
      child: Container(
        height: size.width * 0.34,
        width: double.infinity,
        child: Padding(
          padding: const EdgeInsetsDirectional.only(start: 15),
          child: Row(
            children: [
              Image(
                image: NetworkImage(productModel.product.imageUrl),
                height: size.width * 0.25,
                width: size.width * 0.25,
                fit: BoxFit.cover,
              ),
              SizedBox(
                width: 6,
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text(
                            productModel.product.name,
                            style: TextStyle(fontSize: 18),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 6,
                      ),
                      Text(
                        productModel.product.category,
                        style: TextStyle(color: Colors.grey),
                      ),
                      SizedBox(
                        height: 6,
                      ),
                      Text(
                        '\$${productModel.totalPrice}',
                        style: TextStyle(color: Colors.blueAccent),
                      ),
                      if (productModel.color != null)
                        Container(
                            alignment: AlignmentDirectional.centerStart,
                            height: 20,
                            width: 20,
                            decoration: BoxDecoration(color: Color(int.parse('${productModel.color}')), shape: BoxShape.circle)),
                      if (productModel.size != null) Text('${productModel.size}'),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
