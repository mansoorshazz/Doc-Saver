import 'package:flutter/material.dart';

class BuildTitleText extends StatelessWidget {
  const BuildTitleText({
    Key? key,
    required this.title,
  }) : super(key: key);

  final String title;

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 17,
        fontWeight: FontWeight.w500,
      ),
    );
  }
}
