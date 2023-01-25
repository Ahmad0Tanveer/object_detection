
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:object_detection/main.dart';

class CameraView extends StatefulWidget {
  const CameraView({super.key});
  @override
   createState() => _CameraViewState();
}

class _CameraViewState extends State<CameraView> with WidgetsBindingObserver {
  CameraImage? image;
  late CameraController _controller;
  Future<void>? _initializeControllerFuture;

  void initCamera() async {
    _controller = CameraController(cameras[0], ResolutionPreset.ultraHigh,);
    _initializeControllerFuture = _controller.initialize();
    if(_initializeControllerFuture != null){
      _controller.startImageStream(_processCameraImage);
    }
  }
  void _processCameraImage(CameraImage img) async {
    setState(() {
      image = image;
    });
  }
  @override
  void initState() {
    super.initState();
    initCamera();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return _initializeControllerFuture != null ? Stack(
        children: [
          FutureBuilder<void>(
            future: _initializeControllerFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                return LayoutBuilder(
                  builder: (context, constraints) {
                    return SizedBox(
                      width: constraints.maxWidth,
                      height: constraints.maxHeight,
                      child: CameraPreview(_controller),
                    );
                  },
                );
              } else {
                return const Center(child: CircularProgressIndicator());
              }
            },
          ),
          Positioned(
              bottom: 10,
              right: 10,
              child: Container(
                height: size.height * 0.3,
                width: size.width * 0.40,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                ),
                child: image!=null?Image.memory(image!.planes[0].bytes):Text("No"),
              )
          )
        ],
      ) : Center(
        child: TextButton(
          onPressed: initCamera,
          child: const Text("Re Connect"),
        ),
    );
  }
}