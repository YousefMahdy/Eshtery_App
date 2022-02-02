import 'package:flutter/material.dart';
import 'package:iti_project/modules/home/home_screen.dart';
import 'package:iti_project/modules/vendor/vendor_mainPage.dart';
import 'package:iti_project/shared/component/components.dart';
import 'package:iti_project/shared/component/conestants.dart';

class Confirmation extends StatefulWidget {
  Confirmation({Key key}) : super(key: key);

  @override
  _ConfirmationState createState() => _ConfirmationState();
}

class _ConfirmationState extends State<Confirmation> {
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size.width;
    return Scaffold(
      body: Container(
        margin:
            EdgeInsets.symmetric(horizontal: size * .05, vertical: size * .03),
        child: Column(
          children: [
            Container(
              height: size * .6,
              margin: EdgeInsets.only(top: size * .4),
              decoration: BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage("assets/images/like.png"))),
            ),
            Container(
                margin: EdgeInsets.only(top: size * .07),
                child: Text(
                  "Confirmation",
                  style: TextStyle(fontSize: size * .07),
                )),
            Container(
                margin: EdgeInsets.only(top: size * .05, bottom: size * .02),
                child: Text("You have sucessfully")),
            Text("completed your payment procedure"),
            Expanded(
                child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                        color: Colors.blue,
                        borderRadius: BorderRadius.circular(5)),
                    child: MaterialButton(
                      //function
                      onPressed: () {
                        if(vendorData!=null){
                          navigateAndfinish(context, VendorPage());
                          navigateTo(context, HomeScreen());
                        }else{
                          navigateAndfinish(context, HomeScreen());

                        }
                        
                        
                        
                      },
                      child: Text(
                        "Back to Home",
                        style: TextStyle(color: Colors.white),
                      ),
                    )),
              ],
            )),
          ],
        ),
      ),
    );
  }
}
