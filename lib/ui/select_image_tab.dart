import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:object_detection/tflite/classifier.dart';


class SelectedImageTab extends StatefulWidget {
  const SelectedImageTab({Key? key}) : super(key: key);
  @override
  State<SelectedImageTab> createState() => _SelectedImageTabState();
}

class _SelectedImageTabState extends State<SelectedImageTab> {
  final model = Get.put(Classifier());
  Image? image;
  final piker = ImagePicker();
  void pickImage() async {
    final im = await piker.getImage(source: ImageSource.gallery);
    if(im != null){
      image = Image.file(File(im.path));
      setState(() {});
      model.imagePredictor(image: File(im.path));
    }
  }

  @override
  void initState() {
    model.initModel();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
        children:[
          Container(
            height: MediaQuery.of(context).size.height,
            alignment: Alignment.center,
            child: image ?? TextButton(
              onPressed: pickImage,
              child: const Text("Select Image"),
            ),
          ),
          Positioned(
              bottom: 10,
              child: Visibility(
                visible: model.predictions.isNotEmpty,
                child: results(),
              )),
          Positioned(
            bottom: 0,
            right: 0,
            child: FloatingActionButton(
              child: const Icon(Icons.clear),
              onPressed: (){
                image = null;
                setState(() {

                });
              },
            ),
          )
        ]
    );
  }
  Widget results(){
    return model.predictions.isNotEmpty?Container(
        height: 80,
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(15),
              margin: const EdgeInsets.only(left: 10),
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.red,
              ),
              child: Text("${(model.predictions[0].score*100).toStringAsFixed(0)}%",
                style: const TextStyle(color: Colors.white,fontWeight: FontWeight.bold,),
              ),
            ),
            Text(model.predictions[0].label,style: const TextStyle(
              color: Colors.black87,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),)
          ],
        )
    ):Container();
  }
}
