import 'package:flutter/material.dart';
import 'package:iti_project/models/userClass.dart';
import 'package:iti_project/models/vendorModel.dart';

const pageTitle = TextStyle(
  fontSize: 30.0,
  color: Color(0xFF434343),
);
const priceFonts = TextStyle(
  fontSize: 15.0,
  color: Color(0xFF919191),
);
const addressSecondFonts = TextStyle(
  fontSize: 18.0,
);


const  List catogry = ["Electronic", "Health and beauty", "Clothes", "Sport"];
const List<Color> categoryColors = [
    Colors.blue,
    Colors.red,
    Colors.green,
    Colors.yellow,
  ];
const List<String> categoryImages=[
  'assets/images/electronics.jpg',
  'assets/images/health.jpg',
  'assets/images/clothes.jpg',
  'assets/images/sports.jpg',
];
List<String>productsize=['s','m','L','xL','xxL'];
List<String>productColors=['0xFFFF0000','0xFF0000FF','0xFF00FF00','0xFFFFFF00'];

VendorModel vendorData;
UserModel userData;


const String googleMapKey='AIzaSyDGSAjyQhImUqASmbbHk4-r5ACjx7BGNSM';

