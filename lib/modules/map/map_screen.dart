import 'dart:async';
import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_google_places_hoc081098/flutter_google_places_hoc081098.dart';
//import 'package:flutter_google_places/flutter_google_places.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_webservice/places.dart';
import 'package:iti_project/models/cart_item_model.dart';
import 'package:iti_project/modules/address/addres_screen.dart';
import 'package:iti_project/shared/component/conestants.dart';

class MapScreen extends StatefulWidget {
  final List<CartItemModel> myProducts;
  MapScreen({this.myProducts});
  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  double _latitude = 30.04483;

  double _longitude = 31.23609;
  Completer<GoogleMapController> _controller = Completer();
  String _fullAddress='';

  Future<void> _goToTheLake(CameraPosition _kLake) async {
    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(_kLake));
  }

  void _getLatLng() async {
    Prediction prediction = await PlacesAutocomplete.show(
      context: context,
      apiKey: '',
      mode: Mode.overlay, // Mode.overlay
      language: "ar",
      components: [Component(Component.country, "eg")],
    ).catchError((error) {
      print(error);
    });
    GoogleMapsPlaces _places = new GoogleMapsPlaces(apiKey: ''); //Same API_KEY as above
    PlacesDetailsResponse detail = await _places.getDetailsByPlaceId(prediction.placeId);
    double latitude = detail.result.geometry.location.lat;
    double longitude = detail.result.geometry.location.lng;
    final CameraPosition _kLake = CameraPosition(
        // bearing: 192.8334901395799,
        target: LatLng(latitude, longitude),
        // tilt: 59.440717697143555,
        zoom: 19.151926040649414);
    _goToTheLake(_kLake);
    setState(() {
      _latitude = detail.result.geometry.location.lat;
      _longitude = detail.result.geometry.location.lng;
      _fullAddress=detail.result.formattedAddress;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
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
          TextButton(
            onPressed: () {
              FirebaseFirestore.instance.collection('user')
              .doc('${userData == null ? vendorData.vId : userData.uId}')
              .collection('myAddresses').add({
                'fullAddress':_fullAddress
              }).then((value) {
                Navigator.of(context).pop();
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder:(ctx)=>AddressScreen(myProducts: widget.myProducts,)));

              });
            },
            child: Text('Add'),
          ),
        ],
      ),
      body: Container(
        child: Stack(
          children: [
            GoogleMap(
              mapType: MapType.normal,
              initialCameraPosition: CameraPosition(
                target: LatLng(_latitude, _longitude),
                zoom: 16,
              ),
              markers: {
                Marker(
                  markerId: MarkerId('m1'),
                  position: LatLng(_latitude, _longitude),
                ),
              },
              onTap: (position) {
                GoogleMapsPlaces _places = new GoogleMapsPlaces(apiKey: '');
                _places.doGet('https://maps.google.com/maps/api/geocode/json?key=&language=en&latlng=${position.latitude},${position.longitude} ').then((value) {
                
                   _fullAddress=json.decode(value.body)["results"][0]["formatted_address"];
                   print(_fullAddress);
                   setState(() {
                  _latitude = position.latitude;
                  _longitude = position.longitude;
                });
                  
                 });
                 
                
                 
                
              },
              onMapCreated: (GoogleMapController controller) {
                _controller.complete(controller);
              },
            ),
            Positioned(
              right: 20,
              left: 20,
              top: 20,
              child: InkWell(
                onTap:(){
                   _getLatLng();

                },
                child: Card(
                  child: Padding(
                    padding: const EdgeInsetsDirectional.only(start: 10),
                    child: Row(
                      children: [
                        Expanded(
                          child: Text('$_fullAddress',
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                          
                       ),
                        ),
                       // Spacer(),
                        Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Icon(Icons.search),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}




