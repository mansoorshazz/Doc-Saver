
import 'package:flutter/material.dart';

class BuildSizedBox extends StatelessWidget {
  BuildSizedBox({
    Key? key,
    this.height = 20,
  }) : super(key: key);

  double height;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
    );
  }
}