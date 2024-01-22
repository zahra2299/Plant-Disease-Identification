import 'package:flutter/material.dart';
import 'package:plant_disease_identification_app/plant_details.dart';
import 'package:plant_disease_identification_app/plant_model.dart';

class EncyScreen extends StatelessWidget {
  static const String routeName = "EncyScreen";
  List<String> plantNames = [
    "Tomato",
    "Strawberry",
    "Pepper",
    "Peach",
    "Orange",
    "Grape",
    "Apple"
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
      ),
      body: Center(
        child: Column(
          children: [
            Image.asset("assets/images/ency.jpg"),
            Expanded(
              child: ListView.separated(
                separatorBuilder: (context, index) => Divider(
                  thickness: 1,
                  color: Colors.blueGrey,
                  endIndent: 40,
                  indent: 40,
                ),
                itemBuilder: (context, index) {
                  return InkWell(
                    onTap: () {
                      Navigator.pushNamed(context, PlantDetails.routeName,
                          arguments: PlantModel(plantNames[index], index));
                    },
                    child: Center(
                        child: Text(
                      plantNames[index],
                      style: TextStyle(color: Colors.blueGrey, fontSize: 30),
                    )),
                  );
                },
                itemCount: plantNames.length,
              ),
            )
          ],
        ),
      ),
    );
  }
}
