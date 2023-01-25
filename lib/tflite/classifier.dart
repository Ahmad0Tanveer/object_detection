import 'dart:io';
import 'dart:math';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:object_detection/main.dart';
import 'package:tflite_flutter/tflite_flutter.dart';
import 'package:tflite_flutter_helper/tflite_flutter_helper.dart';

import '../models/output.model.dart';


class Classifier extends GetxController {

   RxString resultOneScore = "".obs;
   RxString resultPrediction = "".obs;
   RxList<MSimpleOutput> predictions  = <MSimpleOutput>[].obs;

  static const double threshold = 0.5;
  late ImageProcessor imageProcessor;
  static const int inputSize = 300;
  int padSize = 0;

  List<List<int>> outputShapes = [];
  List<TfLiteType> outputTypes = [];

  static const int numResults = 10;

  void initModel(){
    try {
      var outputTensors = interpreter.getOutputTensors();
      outputShapes = [];
      outputTypes = [];
      outputTensors.forEach((tensor) {outputShapes.add(tensor.shape);outputTypes.add(tensor.type);});
      update();
    } catch (e) {
      print("Error while creating interpreter: $e");
    }
  }
  TensorImage getProcessedImage(TensorImage inputImage) {
    padSize = max(inputImage.height, inputImage.width);
    imageProcessor = ImageProcessorBuilder().add(ResizeWithCropOrPadOp(padSize, padSize))
        .add(ResizeOp(inputSize, inputSize, ResizeMethod.BILINEAR))
        .build();
    inputImage = imageProcessor.process(inputImage);
    return inputImage;
  }

  void imagePredictor({required File image}) {
    TensorImage inputImage = TensorImage.fromFile(image);
    inputImage = getProcessedImage(inputImage);
    TensorBuffer outputLocations = TensorBufferFloat(outputShapes[0]);
    TensorBuffer outputClasses = TensorBufferFloat(outputShapes[1]);
    TensorBuffer outputScores = TensorBufferFloat(outputShapes[2]);
    TensorBuffer numLocations = TensorBufferFloat(outputShapes[3]);
    List<Object> inputs = [inputImage.buffer];
    Map<int, Object> outputs = {
      0: outputLocations.buffer,
      1: outputClasses.buffer,
      2: outputScores.buffer,
      3: numLocations.buffer,
    };

    interpreter.runForMultipleInputs(inputs, outputs);

    int resultsCount = min(numResults, numLocations.getIntValue(0));
    int labelOffset = 1;

    for (int i = 0; i < resultsCount; i++) {
      double score = outputScores.getDoubleValue(i);
      var labelIndex = outputClasses.getIntValue(i) + labelOffset;
      var label = labels.elementAt(labelIndex);
      predictions.add(MSimpleOutput(
        score: score,
        label: label,
      ));
      update();
    }
  }
}
