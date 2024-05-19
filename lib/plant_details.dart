import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:plant_disease_identification_app/plant_model.dart';

class PlantDetails extends StatefulWidget {
  static const String routeName = "PlantDetailsScreen";

  @override
  State<PlantDetails> createState() => _PlantDetailsState();
}

class _PlantDetailsState extends State<PlantDetails> {
  List<String> plantContent = [];

  loadFile(int index) async {
    String file = await rootBundle.loadString("assets/files/${index + 1}.txt");
    List<String> lines = file.split("\n");
    plantContent = lines;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    var args = ModalRoute.of(context)?.settings.arguments as PlantModel;
    //to stop loading file infinitely
    if (plantContent.isEmpty) {
      loadFile(args.index);
    }
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage("assets/images/green ground.jpg"),
          fit: BoxFit.fill,
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          centerTitle: true,
          title: Stack(
            children: <Widget>[
              // Stroked text as border.
              Text(
                args.name,
                style: TextStyle(
                  fontSize: 40,
                  foreground: Paint()
                    ..style = PaintingStyle.stroke
                    ..strokeWidth = 4
                    ..color = Color(0xff586350),
                ),
              ),
              // Solid text as fill.
              Text(
                args.name,
                style: const TextStyle(
                  fontSize: 40,
                  fontWeight: FontWeight.w500,
                  color: Color(0xffd7c2ab),
                ),
              ),
            ],
          ),
        ),
        body: Padding(
          padding: EdgeInsets.all(18),
          child: Card(
            color: Color(0xffd7c2ab),
            shape: OutlineInputBorder(
              borderRadius: BorderRadius.circular(18),
              borderSide: BorderSide(color: Colors.grey),
            ),
            child: Padding(
              padding: EdgeInsets.all(8),
              child: ListView.builder(
                  itemBuilder: (context, index) {
                    return Text(
                      plantContent[index],
                      style:
                          TextStyle(fontWeight: FontWeight.w500, fontSize: 20),
                    );
                  },
                  itemCount: plantContent.length),
            ),
          ),
        ),
      ),
    );
  }
}
