import 'package:flutter/material.dart';
import 'package:google_ml_kit/google_ml_kit.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tts_tutorial/Screens/imagewithlines.dart';
import 'package:tts_tutorial/utils/imagepicker.dart';
import 'package:tts_tutorial/utils/textrecognizer.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String imagePath = "";
  List<TextBlock> textBlock = [];
  void _showModalSheet() {
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
                  String path= await imagePickers(context,ImageSource.camera);
                  setState(() {
                    imagePath = path;
                  });
                  await textRecognizer(path).then((value) {
                      textBlock=value;
                  });
                  Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ImageWithTextLines(
                        imagePath: imagePath, textBlock: textBlock,),
                  ));
                                }),
            ListTile(
              leading: const Icon(Icons.browse_gallery),
              title: const Text('Gallery'),
              onTap: () async {
                // Handle share action
                String path = await imagePickers(context,ImageSource.gallery);
                setState(() {
                  imagePath =path;
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
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          body: const Center(
            child: Text('Select Image'),
          )
          ,
          floatingActionButton: FloatingActionButton.extended(
              onPressed: _showModalSheet, label: const Text('Scan'))),
    );
  }
}