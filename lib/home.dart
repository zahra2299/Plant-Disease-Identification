import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:plant_disease_identification_app/ency_screen.dart';
import 'package:tflite_v2/tflite_v2.dart';

// import 'package:tflite/tflite.dart';

class HomeScreen extends StatefulWidget {
  static const String routeName = "Home";

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool _loading = true;
  late File _image;
  List _output = [];
  final picker = ImagePicker();
  String diseaseName = "";

  @override
  void initState() {
    super.initState();
    loadModel();
  }

  bool _isModelRunning = false;

  detectImage(File image) async {
    if (_isModelRunning) return; // Skip if model is already running

    _isModelRunning = true;
    try {
      var output = await Tflite.runModelOnImage(
          path: image.path,
          numResults: 8,
          threshold: 0.6,
          imageMean: 127.5,
          imageStd: 127.5);
      setState(() {
        _output = output!;
        _loading = false;
        diseaseName = _output[0]['label'];
      });
      if (output == null) {
        print("Model failed to produce output");
      }
    } finally {
      _isModelRunning = false; // Release for next run
    }

    // var output = await Tflite.runModelOnImage(
    //     path: image.path,
    //     numResults: 8,
    //     threshold: 0.6,
    //     imageMean: 127.5,
    //     imageStd: 127.5);
    // setState(() {
    //   _output = output!;
    //   _loading = false;
    // });
    // if (output == null) {
    //   print("Model failed to produce output");
    // }
  }

  loadModel() async {
    // await Tflite.loadModel(
    //   model: "assets/keras_model.h5",
    //   labels: "assets/labels.txt",
    // );
    try {
      String? tfResponse = await Tflite.loadModel(
        model: "assets/model_unquant.tflite",
        labels: "assets/labels.txt",
      );
      print("Response: TF Model Load $tfResponse");
    } catch (error) {
      print('Failed to load model. Error: $error');
    }
  }

  @override
  void dispose() {
    Tflite.close();
    super.dispose();
  }

  pickImage() async {
    var image = await picker.pickImage(source: ImageSource.camera);
    if (image == null) return null;
    setState(() {
      _image = File(image.path);
    });

    detectImage(_image);
  }

  pickGalleryImage() async {
    var image = await picker.pickImage(source: ImageSource.gallery);
    if (image == null) return null;
    setState(() {
      _image = File(image.path);
    });

    detectImage(_image);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              SizedBox(
                height: 50,
              ),

              Center(
                child: _loading
                    ? Container(
                        width: 270,
                        child: Column(
                          children: <Widget>[
                            Image.asset("assets/images/Green Leaves.jpeg"),
                            SizedBox(
                              height: 20,
                            ),
                          ],
                        ),
                      )
                    : Container(
                        child: Column(
                          children: <Widget>[
                            //To display the image that the user picked
                            Column(
                              children: [
                                Image.file(_image),
                              ],
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            _output != null
                                ? Text(
                                    '${_output[0]['label']}',
                                    style: const TextStyle(
                                        color: Colors.black, fontSize: 20),
                                  )
                                : Container(),
                            if (diseaseName == 'Strawberry Leaf Scorch')
                              Text(
                                'Recommendations for Strawberry Leaf Scorch treatment...',
                                style: TextStyle(color: Colors.grey),
                              ),
                            if (diseaseName == 'Pepper Bell Bacterial Spot')
                              Text(
                                'Recommendations for Pepper Bell Bacterial Spot treatment...',
                                style: TextStyle(color: Colors.grey),
                              ),
                            SizedBox(
                              height: 10,
                            ),
                          ],
                        ),
                      ),
              ),

              //Buttons
              Container(
                width: MediaQuery.of(context).size.width,
                child: Column(
                  children: <Widget>[
                    GestureDetector(
                      onTap: pickImage,
                      child: Container(
                        width: MediaQuery.of(context).size.width - 230,
                        alignment: Alignment.center,
                        padding:
                            EdgeInsets.symmetric(horizontal: 10, vertical: 18),
                        decoration: BoxDecoration(
                          color: Colors.blueGrey,
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text("Camera",
                            style: TextStyle(
                              color: Colors.white,
                            )),
                      ),
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    GestureDetector(
                      onTap: pickGalleryImage,
                      child: Container(
                        width: MediaQuery.of(context).size.width - 230,
                        alignment: Alignment.center,
                        padding:
                            EdgeInsets.symmetric(horizontal: 10, vertical: 18),
                        decoration: BoxDecoration(
                          color: Colors.blueGrey,
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text("Select a photo",
                            style: TextStyle(
                              color: Colors.white,
                            )),
                      ),
                    ),
                    SizedBox(
                      height: 65,
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.pushNamed(context, EncyScreen.routeName);
                      },
                      child: Container(
                        width: MediaQuery.of(context).size.width - 230,
                        alignment: Alignment.center,
                        padding:
                            EdgeInsets.symmetric(horizontal: 10, vertical: 18),
                        decoration: BoxDecoration(
                          color: Colors.blueGrey,
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text("Encyclopedia",
                            style: TextStyle(
                              color: Colors.white,
                            )),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
