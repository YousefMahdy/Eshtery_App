import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:iti_project/models/cart_item_model.dart';
// import 'package:iti_project/modules/creat_address/create_address_screen.dart';
import 'package:iti_project/modules/map/map_screen.dart';
import 'package:iti_project/modules/payment/payment.dart';
import 'package:iti_project/shared/component/components.dart';
import 'package:iti_project/shared/component/conestants.dart';

class AddressScreen extends StatefulWidget {
  final List<CartItemModel> myProducts;
  AddressScreen({this.myProducts});

  @override
  _AddressScreenState createState() => _AddressScreenState();
}

class _AddressScreenState extends State<AddressScreen> {
  String selectedAddress;
  List<String> addresses = [];
  Future<List<String>> getAddresses() async {
    if (addresses.isNotEmpty) {
      return addresses;
    }
    addresses = [];

    await FirebaseFirestore.instance
        .collection("user")
        .doc("${userData == null ? vendorData.vId : userData.uId}")
        .collection("myAddresses")
        .get()
        .then((value) {
      value.docs.forEach((element) {
        addresses.add(element.data()['fullAddress']);
      });
    }).catchError((error) {
      print(error);
    });
    if (addresses.isNotEmpty) selectedAddress = addresses[0];
    return addresses;
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        backwardsCompatibility: false,
        systemOverlayStyle: SystemUiOverlayStyle(
          statusBarColor: Theme.of(context).canvasColor,
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          IconButton(
            onPressed: () {},
            icon: Image.asset('assets/images/Notofication.png'),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.only(left: 15.0, right: 15.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text(
                'Address',
                style: pageTitle,
              ),
              SizedBox(
                height: size.width * 0.08,
              ),
              FutureBuilder(
                future: getAddresses(),
                builder: (context, snapShot) {
                  if (snapShot.hasData) {
                    return snapShot.data.isEmpty
                        ? Container(height: MediaQuery.of(context).size.height * 0.6, child: Center(child: Text('There is no Addresses found')))
                        : ListView.separated(
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            itemBuilder: (context, index) => Row(
                                  children: [
                                    Expanded(
                                      child: Text(
                                        '${snapShot.data[index]}',
                                        style: addressSecondFonts,
                                      ),
                                    ),
                                    Radio(
                                        value: snapShot.data[index],
                                        groupValue: selectedAddress,
                                        onChanged: (value) {
                                          setState(() {
                                            selectedAddress = value;
                                          });
                                          print(value);
                                        })
                                  ],
                                ),
                            separatorBuilder: (context, index) => SizedBox(
                                  height: 10,
                                ),
                            itemCount: snapShot.data.length);
                  }
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                },
              ),
              SizedBox(
                height: size.height * 0.34,
              ),
              DottedBorder(
                dashPattern: [8, 4],
                color: Color(0xFF667EEA),
                strokeWidth: 1,
                child: Container(
                  width: double.infinity,
                  height: 50.0,
                  padding: EdgeInsets.all(15.0),
                  decoration: BoxDecoration(shape: BoxShape.rectangle, color: Theme.of(context).canvasColor),
                  child: InkWell(
                    onTap: () {
                      navigateTo(context, MapScreen(
                       myProducts:widget.myProducts,
                      ));
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(
                          'assets/images/Notofication.png',
                          color: Color(0xFF667EEA),
                        ),
                        SizedBox(
                          width: size.width * 0.08,
                        ),
                        Text(
                          'Add Address',
                          style: TextStyle(
                            color: Color(0xFF667EEA),
                            fontSize: 20.0,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 8.0,
              ),
              Container(
                width: double.infinity,
                height: 60.0,
                padding: EdgeInsets.all(15.0),
                decoration: BoxDecoration(
                  shape: BoxShape.rectangle,
                  gradient: LinearGradient(
                    colors: [Color(0xFF6681EB), Color(0xFF64B5FF)],
                  ),
                ),
                child: InkWell(
                  child: Text(
                    'Continue To Payment',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 25.0,
                    ),
                  ),
                  hoverColor: Color(0xFF6681EB),
                  onTap: () {
                    navigateTo(
                        context,
                        PaymentScreen(
                          myProducts: widget.myProducts,
                          address: selectedAddress,
                        ));
                  },
                ),
              ),
              SizedBox(
                height: 20.0,
              )
            ],
          ),
        ),
      ),
    );
  }
}
