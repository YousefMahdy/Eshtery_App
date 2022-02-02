

import 'package:iti_project/models/product_model.dart';

class CartItemModel {
  String itemId;
  int itemCount;
  double totalPrice;
  String color;
  String size;
  String address;
  String phone;
  ProductModel product;


  CartItemModel({
    this.itemCount,
    this.itemId,
    this.product,
    this.totalPrice,
    this.size,
    this.color,
    this.address,
    this.phone,

  });

  CartItemModel.fromJson(Map<String, dynamic> json) {
    itemId=json['itemId'];
    itemCount=json['itemCount'];
    totalPrice=json['totalPrice'];
    size=json['size'];
    color=json['color'];
    address=json['address'];
    phone=json['phone'];
    product=ProductModel.fromJson(json['product']);
  }

  Map<String, dynamic> toMap() {
    return {
      'itemId':itemId,
      'itemCount':itemCount,
      'totalPrice':totalPrice,
      'color':color,
      'size':size,
      'product':product.toMap(),
      'address':address,
      'phone':phone,

    };
  }
}
