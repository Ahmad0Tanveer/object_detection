
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:tflite_flutter/tflite_flutter.dart';
import 'package:tflite_flutter_helper/tflite_flutter_helper.dart';
import 'package:get/get.dart';
import 'ui/home_page.dart';


const String modelName = "detect.tflite";
const String modelLabels = "labelmap.txt";

List<String> labels = [];
late Interpreter interpreter;
List<CameraDescription> cameras = [];

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  interpreter = await Interpreter.fromAsset(modelName, options: InterpreterOptions()..threads = 4);
  labels = await FileUtil.loadLabels("assets/$modelLabels");
  cameras = await availableCameras();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const GetMaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomePage(),
    );
  }
}
