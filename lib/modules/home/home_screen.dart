import 'dart:io';

import 'package:badges/badges.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_pro/carousel_pro.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:iti_project/models/product_model.dart';
import 'package:iti_project/modules/cart/view.dart';
import 'package:iti_project/modules/home/search.dart';
import 'package:iti_project/modules/itemdetails/view.dart';
import 'package:iti_project/modules/menu/View.dart';
import 'package:iti_project/modules/product/product_screen.dart';
import 'package:iti_project/shared/component/components.dart';
import 'package:iti_project/shared/component/conestants.dart';
import 'package:url_launcher/url_launcher.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  List link = [];
  Future<List> getads() async {
    link = [];
    await FirebaseFirestore.instance.collection('ads').get().then((value) {
      value.docs.forEach((element) {
        link.add(element.data());
      });
    });
    return link;
  }

////
  List<ProductModel> _products = [];

  Future<List<ProductModel>> getProducts() async {
    _products = [];
    await FirebaseFirestore.instance.collection('products').get().then((value) {
      value.docs.forEach((element) {
        _products.add(ProductModel.fromJson(element.data()));
      });
    });
    return _products;
  }

/////////
  List<ProductModel> myCart = [];

  Future<List<ProductModel>> indexCart() async {
    myCart = [];
    await FirebaseFirestore.instance
        .collection("user")
        .doc(userData == null ? vendorData.vId : userData.uId)
        .collection("mycart")
        .get()
        .then((value) {
      value.docs.forEach((element) {
        myCart.add(ProductModel.fromJson(element.data()['product']));
      });
    });
    
    return myCart;
  }
  

  @override
  Widget build(BuildContext context) {
    final _size = MediaQuery.of(context).size;
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        leading: InkWell(
            onTap: () {
              _scaffoldKey.currentState.openDrawer();
            },
            child: Image.asset('assets/images/MenuBar.png')),
        actions: [
          IconButton(
            onPressed: () {
              showSearch(context: context, delegate: DataSearch());
            },
            icon: Icon(Icons.search),
          ),
          FutureBuilder<List>(
            future: indexCart(),
            builder: (context, snapshot) {
             // print(snapshot.data);
             if(snapshot.hasData){
               return Badge(
                badgeColor: Colors.blue,
                position: BadgePosition.topStart(top: 3, start: 25),
                animationDuration: Duration(milliseconds: 300),
                animationType: BadgeAnimationType.slide,
                badgeContent:snapshot.data!=null? Text(
                  "${snapshot.data.length}",
                  style: TextStyle(color: Colors.white),
                ): Text(
                  "0",
                  style: TextStyle(color: Colors.white),
                ),
                child: IconButton(
                    icon: Icon(Icons.shopping_cart),
                    padding: EdgeInsets.only(
                      right: 10.0,
                    ),
                    onPressed: () {
                      navigateTo(context, Cart());
                    }),
              );

             }
             return Badge(
                badgeColor: Colors.blue,
                position: BadgePosition.topStart(top: 3, start: 25),
                animationDuration: Duration(milliseconds: 300),
                animationType: BadgeAnimationType.slide,
                badgeContent: 
                   Text(
                  "0",
                  style: TextStyle(color: Colors.white),
                ),
                child: IconButton(
                    icon: Icon(Icons.shopping_cart),
                    padding: EdgeInsets.only(
                      right: 10.0,
                    ),
                    onPressed: () {
                      navigateTo(context, Cart());
                    }),
              );
              
            },
          ),
        ],
      ),
      drawer: Menu(),
      body: Padding(
        padding: const EdgeInsetsDirectional.only(start: 20, top: 20),
        child: SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsetsDirectional.only(end: 20),
                child: Container(
                  width: double.infinity,
                  child: Container(
                      height: _size.width * .5,
                      width: double.infinity,
                      child: FutureBuilder<List>(
                          future: getads(),
                          builder: (context, snapshot) {
                            if(snapshot.hasData){
                               return Carousel(
                                boxFit: BoxFit.cover,
                                autoplay: true,
                                animationCurve: Curves.fastOutSlowIn,
                                dotSize: 6.0,
                                dotIncreasedColor: Colors.blue,
                                dotBgColor: Colors.transparent,
                                dotPosition: DotPosition.bottomLeft,
                                dotVerticalPadding: 10.0,
                                showIndicator: true,
                                indicatorBgPadding: 7.0,
                                images: List.generate(
                                  snapshot.data.length,
                                  (index) => InkWell(
                                      onTap: () {
                                        launch(
                                            '${snapshot.data[index]['link']}');
                                      },
                                      child: CachedNetworkImage(
                                        imageUrl:
                                            '${snapshot.data[index]['image']}',
                                        fit: BoxFit.cover,
                                      )),
                                ));

                            }
                            return Center(child: CircularProgressIndicator(),);
                           
                          })),
                ),
              ),
              SizedBox(
                height: 30,
              ),
              Padding(
                padding: const EdgeInsetsDirectional.only(end: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      'Categories',
                      style: TextStyle(fontSize: 20),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Container(
                //color: Colors.red,
                height: _size.width * 0.23,
                child: ListView.separated(
                    padding: const EdgeInsetsDirectional.only(start: 8),
                    physics: BouncingScrollPhysics(),
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (context, index) => InkWell(
                          onTap: () {
                            showLoading(context);
                            FirebaseFirestore.instance
                                .collection('products')
                                .where('category',
                                    isEqualTo: '${catogry[index]}')
                                .get()
                                .then((value) {
                              Navigator.of(context).pop();
                              final List<ProductModel> _products = [];
                              value.docs.forEach((element) {
                                _products
                                    .add(ProductModel.fromJson(element.data()));
                              });
                              navigateTo(
                                  context,
                                  ProductScreen(
                                    title: catogry[index],
                                    products: _products,
                                  ));
                            });
                          },
                          child: Stack(
                            children: [
                              Container(
                                clipBehavior: Clip.antiAliasWithSaveLayer,
                                width: _size.width * 0.35,
                                height: _size.width * 0.2,
                                decoration: BoxDecoration(
                                    boxShadow: [
                                      BoxShadow(
                                          color: Colors.grey[600],
                                          offset: Offset(0, 0),
                                          blurRadius: 8.0)
                                    ],
                                    borderRadius: BorderRadius.circular(8),
                                    image: DecorationImage(
                                        image: AssetImage(
                                            '${categoryImages[index]}'),
                                        fit: BoxFit.cover)),
                              ),
                              Container(
                                clipBehavior: Clip.antiAliasWithSaveLayer,
                                alignment: Alignment.center,
                                width: _size.width * 0.35,
                                height: _size.width * 0.2,
                                child: Text(
                                  '${catogry[index]}',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold),
                                ),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8),
                                  color: categoryColors[index].withOpacity(0.7),
                                ),
                              )
                            ],
                          ),
                        ),
                    separatorBuilder: (context, index) => SizedBox(
                          width: 15,
                        ),
                    itemCount: catogry.length),
              ),
              SizedBox(
                height: 20,
              ),
              Padding(
                padding: const EdgeInsetsDirectional.only(end: 20),
                child: Row(
                  children: [
                    Text(
                      'Featured',
                      style: TextStyle(fontSize: 20),
                    ),
                    Spacer(),
                    InkWell(
                        onTap: () {
                          navigateTo(
                              context,
                              ProductScreen(
                                title: 'Featured',
                                products: _products,
                              ));
                        },
                        child: Text('See all')),
                  ],
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Container(
                height: _size.width * 0.65,
                //color: Colors.red,
                child: FutureBuilder<List<ProductModel>>(
                  future: getProducts(),
                  builder: (context, snapShot) {
                    if (snapShot.hasData) {
                      return ListView.separated(
                          physics: BouncingScrollPhysics(),
                          scrollDirection: Axis.horizontal,
                          itemBuilder: (context, index) => buildProductItem(
                              size: _size,
                              tap: () {
                                Navigator.of(context).push(
                                  MaterialPageRoute(builder: (ctx)=>ItemDetails(
                                      productModel: snapShot.data[index],
                                    )));
                                /* navigateTo(
                                    context,
                                    ); */
                              },
                              productModel: snapShot.data[index]),
                          separatorBuilder: (context, index) => SizedBox(
                                width: 20,
                              ),
                          itemCount: snapShot.data.length);
                    }

                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  },
                ),
              ),
              SizedBox(
                height: 30,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
