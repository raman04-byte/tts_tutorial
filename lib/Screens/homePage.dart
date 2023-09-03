import 'package:flutter/material.dart';
import 'package:google_ml_kit/google_ml_kit.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String imagePath = "";
  List<TextBlock> blocks = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: const Center(
        child: Text("Select Image"),
      ),
      floatingActionButton: FloatingActionButton.extended(
          onPressed: () {
            showModalBottomSheet(
                context: context,
                builder: (BuildContext context) {
                  return const Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      ListTile(
                        leading: Icon(Icons.camera_alt),
                        title: Text("Camera"),
                      ),
                      ListTile(
                        leading: Icon(Icons.image),
                        title: Text("Gallery"),
                      )
                    ],
                  );
                });
          },
          label: const Text("Scan")),
    );
  }
}
