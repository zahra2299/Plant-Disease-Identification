import 'package:flutter/material.dart';
import 'package:plant_disease_identification_app/ency_screen.dart';
import 'package:plant_disease_identification_app/home.dart';
import 'package:plant_disease_identification_app/plant_details.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: HomeScreen.routeName,
      routes: {
        HomeScreen.routeName: (context) => HomeScreen(),
        EncyScreen.routeName: (context) => EncyScreen(),
        PlantDetails.routeName: (context) => PlantDetails(),
      },
    );
  }
}
