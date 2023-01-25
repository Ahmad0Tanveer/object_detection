import 'package:flutter/material.dart';
import 'realt_time_camera_tab.dart';
import 'select_image_tab.dart';


class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  @override
  Widget build(BuildContext context) {
    const style = TextStyle(color: Colors.black45);
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          elevation: 1000,
          backgroundColor: Colors.white,
          title: const Text("Flutter Tensorflow lite",style: TextStyle(
            color: Colors.black87,
          ),),
          bottom: const TabBar(
            indicatorColor: Colors.black87,
            tabs: [
              Tab(child: Text("Image",style: style,),),
              Tab(child: Text("Real Time",style: style),),
            ],
          ),
        ),
        body: const TabBarView(
          children: [
            SelectedImageTab(),
            CameraView(),
          ],
        ),
      ),
    );
  }
}
