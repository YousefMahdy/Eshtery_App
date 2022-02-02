import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:iti_project/models/product_model.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

Widget buildProductItem({Size size, Function tap, ProductModel productModel}) =>
    InkWell(
      onTap: tap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: size.width * 0.5,
            width: size.width * 0.4,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(6),
                image: DecorationImage(
                    image:
                        CachedNetworkImageProvider('${productModel.imageUrl}'),
                    fit: BoxFit.contain)),
          ),
          SizedBox(
            height: 10,
          ),
          Text(
            '\$${productModel.price}',
          ),
          SizedBox(
            height: 10,
          ),
          Text(
            '${productModel.name}',
          ),
        ],
      ),
    );

Widget defultAppButton(Size size, String title, Function tap) => InkWell(
      onTap: tap,
      child: Container(
        height: size.width * 0.15,
        alignment: Alignment.center,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(6),
            gradient: LinearGradient(colors: [
              Color(0xff667EEA),
              Color(0xff64B6FF),
            ])),
        width: double.infinity,
        child: Text(
          '$title',
          style: TextStyle(
            fontSize: 18,
            color: Colors.white,
          ),
        ),
      ),
    );

Widget buildPaymentItem(String title, String price) =>
    Row(children: [Text(title), Spacer(), Text(price)]);

void navigateTo(BuildContext context, Widget page) {
  Navigator.of(context).push(MaterialPageRoute(builder: (ctx) => page));
}

void navigateAndfinish(BuildContext context, Widget page) {
  Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (ctx) => page), (route) => false);
}

loading(BuildContext context) {
  showDialog(
      barrierDismissible: false,
      barrierColor: Colors.black12,
      context: context,
      builder: (context) => Center(
            child: CircularProgressIndicator(),
          ));
}

showLoading(context) {
  return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Please wait"),
          content: Container(
            height: 50,
            child: Center(
              child: CircularProgressIndicator(),
            ),
          ),
        );
      });
}



topsnackbar(context, text) {
  showTopSnackBar(
    context,
    CustomSnackBar.info(
      message: text,
    ),
  );
}
