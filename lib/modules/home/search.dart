import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:iti_project/models/product_model.dart';
import 'package:iti_project/modules/itemdetails/view.dart';
import 'package:iti_project/shared/component/components.dart';

class DataSearch extends SearchDelegate {
  List name = ["ahmed", "Saad", "ibrahim"];
  ProductModel productModel;
  List<ProductModel> _myproducts = [];
  Future<List<ProductModel>> getproducts() async {
    _myproducts = [];
    await FirebaseFirestore.instance.collection("products").get().then((value) {
      value.docs.forEach((element) {
        _myproducts.add(ProductModel.fromJson(element.data()));
      });
    }).catchError((error) {
      print(error);
    });
    return _myproducts;
  }

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        onPressed: () {
          query = "";
        },
        icon: Icon(Icons.close),
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      onPressed: () {
        close(context, null);
      },
      icon: Icon(Icons.arrow_back),
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return ItemDetails(
      productModel: productModel,
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return FutureBuilder<List<ProductModel>>(
        future: getproducts(),
        builder: (context, snapshot) {
          final List<ProductModel> filttername = query.isEmpty
              ? []
              : snapshot.data
                  .where((element) =>
                      element.name.toLowerCase().contains(query.toLowerCase()))
                  .toList();
          return ListView.builder(
              itemCount: filttername.length,
              // query == "" ? snapshot.data.length : filttername.length,
              itemBuilder: (context, i) {
                return InkWell(
                  onTap: () {
                    query = filttername[i].name;
                    productModel = filttername[i];
                    // query = query == ""
                    //     ? snapshot.data[i].name
                    //     : filttername[i].name;
                    showResults(context);
                  },
                  child: Container(
                      padding: EdgeInsets.all(10),
                      child: Text("${filttername[i].name}")
                      // query == ""
                      //     ? Text("${snapshot.data[i].name}")
                      //     : Text("${filttername[i].name}"),
                      ),
                );
              });
        });
  }
}
