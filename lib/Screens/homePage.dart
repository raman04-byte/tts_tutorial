import 'package:flutter/material.dart';
import 'package:google_ml_kit/google_ml_kit.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tts_tutorial/Screens/imagewithLines.dart';
import 'package:tts_tutorial/utils/imagepicker.dart';
import 'package:tts_tutorial/utils/textrecognizer.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String imagePath = "";
  List<TextBlock> textBlock = [];

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
                return Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    ListTile(
                        leading: const Icon(Icons.camera),
                        title: const Text('Camera'),
                        onTap: () async {
                          // Handle share action
                          String path =
                              await imagePickers(context, ImageSource.camera);
                          setState(() {
                            imagePath = path;
                          });
                          await textRecognizer(path).then((value) {
                            textBlock = value;
                          });
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ImageWithTextLines(
                                  imagePath: imagePath,
                                  textBlock: textBlock,
                                ),
                              ));
                        }),
                    ListTile(
                      leading: const Icon(Icons.browse_gallery),
                      title: const Text('Gallery'),
                      onTap: () async {
                        // Handle share action
                        String path =
                            await imagePickers(context, ImageSource.gallery);
                        setState(() {
                          imagePath = path;
                        });
                        await textRecognizer(path).then((value) {
                          textBlock = value;
                        });
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ImageWithTextLines(
                                  imagePath: imagePath, textBlock: textBlock),
                            ));
                      },
                    ),
                  ],
                );
              },
            );
          },
          label: const Text("Scan")),
    );
  }
}
