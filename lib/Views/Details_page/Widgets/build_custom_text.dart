import 'package:docs_saver/core/color.dart';
import 'package:flutter/material.dart';

class BuildCustomText extends StatelessWidget {
  BuildCustomText({
    Key? key,
    required this.text,
    this.fontSize = 25,
    this.fontWeight = FontWeight.w500,
    this.maxLines = 1,
  }) : super(key: key);

  String text;
  double fontSize;
  FontWeight fontWeight;
  int maxLines;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      maxLines: maxLines,
      overflow: TextOverflow.ellipsis,
      style: TextStyle(
        fontSize: fontSize,
        fontWeight: fontWeight,
        color: kWhite,
      ),
    );
  }
}
