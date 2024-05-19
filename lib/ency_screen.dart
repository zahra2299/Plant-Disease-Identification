import 'package:flutter/material.dart';
import 'package:plant_disease_identification_app/plant_details.dart';
import 'package:plant_disease_identification_app/plant_model.dart';

class EncyScreen extends StatelessWidget {
  static const String routeName = "EncyScreen";
  List<String> plantsNames = [
    "Tomato",
    "Strawberry",
    "Pepper",
    "Peach",
    "Orange",
    "Grape",
    "Apple",
    "Basil",
    "Lavender",
    "Rosemary",
    "Mint",
    "Cherry",
    "Blueberries",
    "Raspberries",
    "Aloe Vera",
    "Peace Lily"
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
            Image.asset("assets/images/ency pic.jpeg"),
            Expanded(
              child: ListView.separated(
                separatorBuilder: (context, index) => const Divider(
                  thickness: 1,
                  color: Color(0xff384b2d),
                  endIndent: 40,
                  indent: 40,
                ),
                itemBuilder: (context, index) {
                  return InkWell(
                    onTap: () {
                      Navigator.pushNamed(context, PlantDetails.routeName,
                          arguments: PlantModel(plantsNames[index], index));
                    },
                    child: Center(
                        child: Text(
                      plantsNames[index],
                      style: TextStyle(color: Color(0xff3e5532), fontSize: 25),
                    )),
                  );
                },
                itemCount: plantsNames.length,
              ),
            )
          ],
        ),
      ),
    );
  }
}
