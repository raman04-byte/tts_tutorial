import 'package:flutter/material.dart';
import 'package:google_ml_kit/google_ml_kit.dart';

class TextBlockPainter extends CustomPainter {
  final TextBlock textBlock;
  final Size imageSize;
  final List<String> completeString;
  final String wordToBeSpoken;
  TextBlockPainter(
      {required this.textBlock,
      required this.imageSize,
      required this.completeString,
      required this.wordToBeSpoken});
  @override
  void paint(Canvas canvas, Size size) {
    mypaint(canvas, size);
  }

  void mypaint(Canvas canvas, Size size) async {
    final bgcolor = Paint()
      ..color = Colors.green.withOpacity(0.2)
      ..style = PaintingStyle.fill;
    final rect = Rect.fromLTRB(
      textBlock.boundingBox.left,
      textBlock.boundingBox.top,
      textBlock.boundingBox.right,
      textBlock.boundingBox.bottom,
    );

    final left = rect.left * size.width / imageSize.width;
    final top = rect.top * size.height / imageSize.height;
    final right = rect.right * size.width / imageSize.width;
    final bottom = rect.bottom * size.height / imageSize.height;
    canvas.drawRect(Rect.fromLTRB(left, top, right, bottom), bgcolor);
    final highlightText = Paint()
      ..color = Colors.black
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4;

    for (String element in completeString) {
      if (wordToBeSpoken == element) {
        canvas.drawRect(Rect.fromLTRB(left, top, right, bottom), highlightText);
      }
    }
  }

  @override
  bool shouldRepaint(TextBlockPainter oldDelegate) {
    return oldDelegate.textBlock != textBlock ||
        oldDelegate.imageSize != imageSize;
  }
}