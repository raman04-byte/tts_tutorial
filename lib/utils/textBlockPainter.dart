import 'package:flutter/material.dart';
import 'package:google_ml_kit/google_ml_kit.dart';

class TextBlockPainters extends CustomPainter {
  final List<TextBlock> textBlocks;
  final Size imageSize;
  final List<String> convertedBlocks;
  TextBlockPainters(
      {required this.textBlocks,
      required this.imageSize,
      required this.convertedBlocks});

  @override
  void paint(Canvas canvas, Size size) {
    mypaint(canvas, size);
  }

  void mypaint(Canvas canvas, Size size) {
    double padding = 4;
    final bgcolor = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;
    for (var textBlock in textBlocks) {
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
      final paddedLeft = left + padding;
      canvas.drawRect(Rect.fromLTRB(left, top, right, bottom), bgcolor);

      _renderText(
          canvas,
          Rect.fromLTRB(left, top, right, bottom),
          convertedBlocks[textBlocks.indexOf(textBlock)],
          right,
          left,
          paddedLeft,
          top,
          textBlock);
    }
  }

  void _renderText(Canvas canvas, Rect rect, final text, final right,
      final left, final paddedLeft, final top, TextBlock textBlock) {
    double minFontSize = 1;
    double maxFontSize = rect.height;
    double fontSize =
        _findOptimalFontSize(minFontSize, maxFontSize, rect, text, right, left);

    print(fontSize);

    TextStyle textStyle = TextStyle(fontSize: fontSize, color: Colors.black);
    TextSpan textSpan = TextSpan(text: text, style: textStyle);
    TextPainter textPainter = TextPainter(
      text: textSpan,
      textDirection: TextDirection.ltr,
      textAlign: TextAlign.justify,
    );

    textPainter.layout(maxWidth: right - left);

    final textX = paddedLeft - 4;
    final textY = top;
    textPainter.paint(canvas, Offset(textX, textY));
  }

  double _findOptimalFontSize(double minFontSize, double maxFontSize, Rect rect,
      final text, final right, final left) {
    double epsilon = 0.1;

    while ((maxFontSize - minFontSize) > epsilon) {
      double midFontSize = (minFontSize + maxFontSize) / 2;
      if (_isOverflowing(midFontSize, rect, text, right, left)) {
        maxFontSize = midFontSize;
      } else {
        minFontSize = midFontSize;
      }
    }

    return minFontSize;
  }

  bool _isOverflowing(
      double fontSize, Rect rect, final text, final right, final left) {
    TextStyle textStyle = TextStyle(fontSize: fontSize);
    TextSpan textSpan = TextSpan(text: text, style: textStyle);

    TextPainter textPainter = TextPainter(
      text: textSpan,
      textDirection: TextDirection.ltr,
      textAlign: TextAlign.justify,
      maxLines: (rect.height / fontSize).floor(),
    );

    textPainter.layout(maxWidth: right - left);

    return textPainter.didExceedMaxLines ||
        textPainter.size.height > rect.height;
  }

  @override
  bool shouldRepaint(TextBlockPainters oldDelegate) {
    return oldDelegate.textBlocks != textBlocks ||
        oldDelegate.imageSize != imageSize ||
        oldDelegate.convertedBlocks != convertedBlocks;
  }
}
