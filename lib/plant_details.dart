import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:plant_disease_identification_app/plant_model.dart';

class PlantDetails extends StatefulWidget {
  static const String routeName = "PlantDetailsScreen";

  @override
  State<PlantDetails> createState() => _PlantDetailsState();
}

class _PlantDetailsState extends State<PlantDetails> {
  List<String> _lines = [];

  loadFile(int index) async {
    String file = await rootBundle.loadString("assets/files/${index + 1}.txt");
    List<String> lines = file.split("\n");
    _lines = lines;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    var args = ModalRoute.of(context)?.settings.arguments as PlantModel;
    //to stop loading file infinitely
    if (_lines.isEmpty) {
      loadFile(args.index);
    }
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage("assets/images/background.jpeg"),
          fit: BoxFit.fill,
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          centerTitle: true,
          title: Text(args.name,
              style: TextStyle(
                fontSize: 35,
                fontWeight: FontWeight.w600,
              )),
        ),
        body: Padding(
          padding: EdgeInsets.all(18),
          child: Card(
            shape: OutlineInputBorder(
              borderRadius: BorderRadius.circular(18),
              borderSide: BorderSide(color: Colors.grey),
            ),
            child: Padding(
              padding: EdgeInsets.all(8),
              child: ListView.builder(
                  itemBuilder: (context, index) {
                    return Text(
                      _lines[index],
                      style:
                          TextStyle(fontWeight: FontWeight.w500, fontSize: 20),
                    );
                  },
                  itemCount: _lines.length),
            ),
          ),
        ),
      ),
    );
  }
}
