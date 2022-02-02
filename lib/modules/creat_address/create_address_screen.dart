import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:iti_project/shared/component/conestants.dart';

class CreateAddressScreen extends StatefulWidget {
  const CreateAddressScreen({Key key}) : super(key: key);

  @override
  _CreateAddressScreenState createState() => _CreateAddressScreenState();
}

class _CreateAddressScreenState extends State<CreateAddressScreen> {
  @override
  Widget build(BuildContext context) {
    TextEditingController _nameController = TextEditingController();
    TextEditingController _addressLaneController = TextEditingController();
    TextEditingController _cityController = TextEditingController();
   // TextEditingController _postalCodeController = TextEditingController();
    TextEditingController _phoneNumberController = TextEditingController();
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
      body: Container(
        padding: EdgeInsets.only(left: 15.0, right: 15.0),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Create Address',
                style: pageTitle,
              ),
              SizedBox(
                height: size.width * 0.1,
              ),
              TextField(
                controller: _nameController,
                decoration: InputDecoration(
                  labelText: 'Name',
                  labelStyle: TextStyle(
                    color: const Color(
                      0xFF919191,
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: size.width * 0.07,
              ),
              TextField(
                controller: _addressLaneController,
                decoration: InputDecoration(
                  labelText: 'Address lane',
                  labelStyle: TextStyle(
                    color: const Color(
                      0xFF919191,
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: size.width * 0.07,
              ),
              TextField(
                controller: _cityController,
                decoration: InputDecoration(
                  labelText: 'City',
                  labelStyle: TextStyle(
                    color: const Color(
                      0xFF919191,
                    ),
                  ),
                ),
              ),
             /*  SizedBox(
                height: size.width * 0.07,
              ),
              TextField(
                controller: _postalCodeController,
                decoration: InputDecoration(
                  labelText: 'Postal Code',
                  labelStyle: TextStyle(
                    color: const Color(
                      0xFF919191,
                    ),
                  ),
                ),
                keyboardType: TextInputType.number,
              ), */
              SizedBox(
                height: size.width * 0.07,
              ),
              TextField(
                controller: _phoneNumberController,
                decoration: InputDecoration(
                  labelText: 'Phone Number',
                  labelStyle: TextStyle(
                    color: const Color(
                      0xFF919191,
                    ),
                  ),
                ),
                keyboardType: TextInputType.phone,
              ),
              SizedBox(
                height: size.height * 0.13,
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
                    'Add Address',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 25.0,
                    ),
                  ),
                  hoverColor: Color(0xFF6681EB),
                  onTap: () {
                   // FirebaseFirestore.instance.collection('')
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
