import 'package:flutter/material.dart';
import 'package:iti_project/models/product_model.dart';
import 'package:iti_project/modules/itemdetails/view.dart';
import 'package:iti_project/shared/component/components.dart';

class ProductScreen extends StatelessWidget {
  final String title;
  final List<ProductModel>products;
  ProductScreen({this.title,this.products});
  @override
  Widget build(BuildContext context) {
    final _size = MediaQuery.of(context).size;
    return Scaffold(
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
        actions: [
          InkWell(onTap: () {}, child: Image.asset('assets/images/Search.png')),
          InkWell(
              onTap: () {},
              child: Image.asset('assets/images/Notofication.png')),
        ],
      ),
      body: SingleChildScrollView(
              child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '$title',
                
                style: TextStyle(fontSize: 20),
              ),
              SizedBox(
                height: 20,
              ),
             products.isEmpty?
             Container(
               height: _size.height*0.6,
               
               child: Center(child: Text('There is no products found'),))
             
             : GridView.builder(
                   shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      mainAxisSpacing: 10,
                      crossAxisSpacing: 10,
                      childAspectRatio: 0.65),
                  itemBuilder: (context, index) => buildProductItem(size:_size,tap:(){
                     Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (ctx)=>ItemDetails(
                      productModel:products[index] ,
                    )));
                   
                  },productModel:products[index]),
                  itemCount: products.length,
                ),
              
            ],
          ),
        ),
      ),
    );
  }
}
