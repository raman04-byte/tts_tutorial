import 'dart:async';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:google_ml_kit/google_ml_kit.dart';

class ImageWithTextLines extends StatefulWidget {
  final String imagePath;
  final List<TextBlock> textBlock;
  List<TextLine> textLine = [];
  ImageWithTextLines(
      {super.key, required this.imagePath, required this.textBlock});

  @override
  State<ImageWithTextLines> createState() => _ImageWithTextLinesState();
}

class _ImageWithTextLinesState extends State<ImageWithTextLines> {
  List<String> convertedLanguageBlockList = [];
  List<TextLine> textLines = [];
  TextLine? _textLine;
  bool isSpeaking = false;
  FlutterTts flutterTts = FlutterTts();
  List<TextBlock> convertedLanguageTextBlock = [];
  TextBlock? currentBlock;
  List<String> completeString = [];
  String wordToBeSpoken = '';
  @override
  void initState() {
    super.initState();
    extractLinesFromBlocks(widget.textBlock);
    textIntoBlockConverter();
    extractLines();
    initTts();
  }

  initTts() {
    flutterTts = FlutterTts();

    _setAwaitOptions();
    _setEngines();

    flutterTts.setStartHandler(() {
      setState(() {
        if (kDebugMode) {
          print("Playing");
        }
      });
    });

    flutterTts.setInitHandler(() {
      setState(() {
        if (kDebugMode) {
          print("TTS Initialized");
        }
      });
    });
    flutterTts.setCompletionHandler(() {
      setState(() {
        if (kDebugMode) {
          print("Complete");
        }
      });
    });

    flutterTts.setCancelHandler(() {
      setState(() {
        if (kDebugMode) {
          print("Canceling");
        }
      });
    });

    flutterTts.setPauseHandler(() {
      setState(() {
        if (kDebugMode) {
          print("Paused");
        }
      });
    });

    flutterTts.setContinueHandler(() {
      setState(() {
        if (kDebugMode) {
          print("Continued");
        }
      });
    });
    flutterTts.setErrorHandler((msg) {
      setState(() {
        if (kDebugMode) {
          print("error: $msg");
        }
      });
    });
    flutterTts.setProgressHandler((text, start, end, word) {
      completeString = text.split(' ');
      wordToBeSpoken = word;
      for (String element in completeString) {
        if (kDebugMode) {
          print("String is playing");
          print(element);
        }
      }
    });
  }

  Future _setAwaitOptions() async {
    await flutterTts.awaitSpeakCompletion(true);
    if (kDebugMode) {
      print("Await Completion");
    }
  }

  Future<dynamic> _setEngines() async {
    String engine = await flutterTts.getDefaultEngine;
    flutterTts.setEngine(engine);
  }

  void textIntoBlockConverter() async {
    for (var textBB in widget.textBlock) {
      OnDeviceTranslator onDeviceTranslator = OnDeviceTranslator(
          sourceLanguage: TranslateLanguage.english,
          targetLanguage: TranslateLanguage.hindi);
      String response = await onDeviceTranslator.translateText(textBB.text);
      convertedLanguageBlockList.add(response);
      if (kDebugMode) {
        print(response);
      }
      setState(() {});
    }
  }

  Future<void> speaklines(int currentindex) async {
    while (currentindex < widget.textBlock.length) {
      setState(() {
        if (kDebugMode) {
          print("state changes");
        }
        currentBlock = widget.textBlock[currentindex];
      });
      await flutterTts
          .speak(convertedLanguageBlockList[currentindex])
          .then((value) {
        if (isSpeaking) {
          currentindex++;
        }
      });
      if (!isSpeaking) {
        return;
      }
    }
    return;
  }

  void extractLines() {
    for (var textBB in widget.textBlock) {
      List<TextLine> lines = textBB.lines;
      for (var ll in lines) {
        widget.textLine.add(ll);
      }
    }
  }

  void extractLinesFromBlocks(List<TextBlock> textBlock) {
    textLines =
        textBlock.expand((block) => block.lines).map((line) => line).toList();
  }

  TextBlock? _findTappedTextBlock(Offset localPath, Size size, Size imageSize) {
    for (var textblock in widget.textBlock) {
      final rect = Rect.fromLTRB(
          textblock.boundingBox.left * size.width / imageSize.width,
          textblock.boundingBox.top * size.height / imageSize.height,
          textblock.boundingBox.right * size.width / imageSize.width,
          textblock.boundingBox.bottom * size.height / imageSize.height);
      if (rect.contains(localPath)) {
        return textblock;
      }
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Appbar")),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          flutterTts.stop();
          isSpeaking = false;
        },
      ),
      body: FutureBuilder<Size>(
        future: _getImageSize(widget.imagePath),
        builder: (BuildContext context, AsyncSnapshot<Size> snapshot) {
          if (snapshot.hasData) {}
          return const Center(child: CircularProgressIndicator());
        },
      ),
    );
  }

  Future<Size> _getImageSize(String imagePath) {
    final completer = Completer<Size>();
    final image = Image.file(File(imagePath));
    image.image.resolve(const ImageConfiguration()).addListener(
      ImageStreamListener(
        (ImageInfo image, bool synchronousCall) {
          final size =
              Size(image.image.width.toDouble(), image.image.height.toDouble());
          completer.complete(size);
        },
      ),
    );
    return completer.future;
  }
}
