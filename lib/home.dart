import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:plant_disease_identification_app/ency_screen.dart';
import 'package:tflite_v2/tflite_v2.dart';

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

  detectImage(File image) async {
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
  }

  loadModel() async {
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
                                      color: Colors.black,
                                      fontSize: 30,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  )
                                : Container(),
                            if (diseaseName == 'Tomato Mosaic Virus')
                              const Text(
                                'Remove all infected plants and destroy them.\n'
                                ' Monitor the rest of your plants closely, especially those that are located near infected plants.\n'
                                'Disinfect gardening tools after every use. '
                                'Keep a bottle of a weak bleach solution or other antiviral disinfectant to wipe your tools down with.',
                                style: TextStyle(
                                    color: Colors.green,
                                    fontSize: 20,
                                    fontWeight: FontWeight.w400),
                              ),
                            if (diseaseName == 'Tomato Yellow Leaf Curl Virus')
                              const Text(
                                ' Removal and destruction of plants is recommended. Since weeds often act as hosts to the viruses, '
                                'controlling weeds around the garden can reduce virus transmission by insects.',
                                style: TextStyle(
                                    color: Colors.green,
                                    fontSize: 20,
                                    fontWeight: FontWeight.w400),
                              ),
                            if (diseaseName == 'Strawberry Leaf Scorch')
                              const Text(
                                '- Use drip irrigation, remove infected leaves when practical, and be sure planting stock is clean.\n'
                                '- Choose a growing area with environmental conditions that are not conducive to disease development.',
                                style: TextStyle(
                                    color: Colors.green,
                                    fontSize: 20,
                                    fontWeight: FontWeight.w400),
                              ),
                            if (diseaseName == 'Pepper Bell Bacterial Spot')
                              const Text(
                                '- Apply copper-based fungicides or bactericides according to the manufacturer\'s instructions.\n '
                                '- Avoid overhead watering, as it can splash bacteria from infected plants to healthy ones. Instead, use drip irrigation or water at the base of plants.',
                                style: TextStyle(
                                    color: Colors.green,
                                    fontSize: 20,
                                    fontWeight: FontWeight.w400),
                              ),
                            if (diseaseName == 'Peach Bacterial Spot')
                              const Text(
                                '- Dormant sprays are essential in the fall to protect the stems of your peach tree.\n '
                                '- Use a copper-based fungicide spray on the tree\'s leaves when they begin to fall.',
                                style: TextStyle(
                                    color: Colors.green,
                                    fontSize: 20,
                                    fontWeight: FontWeight.w400),
                              ),
                            if (diseaseName == 'Orange Haunglongbing')
                              const Text(
                                '- Use oxytetracycline and streptomycin in rotation.\n '
                                '- Retreatment interval is a minimum of 21 days.',
                                style: TextStyle(
                                    color: Colors.green,
                                    fontSize: 20,
                                    fontWeight: FontWeight.w400),
                              ),
                            if (diseaseName == 'Grape Black Rot')
                              const Text(
                                '- Apply fungicides preventatively according to a regular schedule, '
                                'starting at bud break and continuing throughout the growing season. '
                                'Fungicides containing active ingredients such as mancozeb, captan, myclobutanil, '
                                'or azoxystrobin can help control black rot. '
                                'Follow label instructions carefully and rotate fungicides to prevent resistance.',
                                style: TextStyle(
                                    color: Colors.green,
                                    fontSize: 20,
                                    fontWeight: FontWeight.w400),
                              ),
                            if (diseaseName == 'Apple Black Rot')
                              const Text(
                                '- Start a full-rate protectant spray program early in the season with copper-based products, lime-sulfur or Daconil.',
                                style: TextStyle(
                                    color: Colors.green,
                                    fontSize: 20,
                                    fontWeight: FontWeight.w400),
                              ),
                            // if (diseaseName == 'Cherry Powdery Mildew')
                            //   const Text(
                            //     '- Start by pruning infected branches and leaves, and lean up fallen leaves and debris around the cherry tree regularly. This reduces the likelihood of the disease spreading or overwintering.\n'
                            //     '- Apply fungicides specifically labeled for powdery mildew control on cherries',
                            //     style: TextStyle(color: Colors.green,
                            //         fontSize: 20,
                            //         fontWeight: FontWeight.w400),
                            //   ),
                            // if (diseaseName == 'Potato Late Blight')
                            //   const Text(
                            //     '- Apply fungicides preventatively before late blight symptoms appear, especially during periods of warm, humid weather.\n'
                            //     '- Ensure proper spacing between potato plants to promote air circulation, which reduces humidity and inhibits disease development.',
                            //     style: TextStyle(color: Colors.green,
                            //         fontSize: 20,
                            //         fontWeight: FontWeight.w400),
                            //   ),
                            // if (diseaseName == 'Corn Northern Leaf Blight')
                            //   const Text(
                            //     '- Remove and destroy any NLB-infected corn debris from fields and surrounding areas to prevent the spread of the disease to healthy plants.\n'
                            //     '- Apply fungicides to protect corn plants from Northern leaf blight. Fungicides containing active ingredients such as azoxystrobin, pyraclostrobin, or trifloxystrobin are effective against NLB.',
                            //     style: TextStyle(color: Colors.green,
                            //         fontSize: 20,
                            //         fontWeight: FontWeight.w400),
                            //   ),
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
                          color: Color(0xff82a974),
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
                          color: Color(0xff82a974),
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
                          color: Color(0xff82a974),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text("Encyclopedia",
                            style: TextStyle(
                              color: Colors.white,
                            )),
                      ),
                    ),
                    SizedBox(
                      height: 5,
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
