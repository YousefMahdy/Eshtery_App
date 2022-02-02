import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:iti_project/models/cart_item_model.dart';
import 'package:iti_project/modules/checkout/checkout_screen.dart';
import 'package:iti_project/shared/component/components.dart';


class PaymentScreen extends StatefulWidget {
  final List<CartItemModel> myProducts;
  final String address;
  PaymentScreen({this.myProducts,this.address});

  @override
  _PaymentScreenState createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {

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
          InkWell(
              onTap: () {},
              child: Image.asset('assets/images/Notofication.png')),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        child: Column(
          children: [
            Row(
              children: [
                Text(
                  'Payment',
                  style: TextStyle(fontSize: 25),
                ),
              ],
            ),
            SizedBox(
              height: 30,
            ),
            Image(
              height: _size.width * 0.4,
              width: double.infinity,
              image: AssetImage(
                'assets/images/Visa.png',
              ),
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
            buildPaymentItem('Shipping', '\$10.00'),
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
            Spacer(),
            /* DottedBorder(
              padding: EdgeInsets.zero,
              color: Colors.blue,
              strokeWidth: 1,
              dashPattern: [4, 4],
              child: MaterialButton(
                onPressed: () {
                  
                },
                minWidth: double.infinity,
                child: Text(
                  'Add Card',
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.blue,
                  ),
                ),
              ),
            ), */
            SizedBox(height: 15,),
            defultAppButton(_size, 'Checkout',
            (){
              navigateTo(context, CheckOutScreen(
                myProducts: widget.myProducts,
                address: widget.address,
              ));
            }
            
            ),
            SizedBox(
              height: 20,
            )
          ],
        ),
      ),
    );
  }
}


