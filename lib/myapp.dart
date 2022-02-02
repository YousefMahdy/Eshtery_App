import 'package:flutter/material.dart';
import 'package:iti_project/modules/splash/welcomLogin.dart';

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Eshtery',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        scaffoldBackgroundColor: Colors.white,
        appBarTheme: AppBarTheme(
          iconTheme: IconThemeData(
            color: Colors.black
          ),
          color: Colors.white,
          elevation: 0,
        )
      ),
      home: SplashScreen() ,
     

    );
  }
}