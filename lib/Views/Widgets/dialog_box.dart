import 'package:flutter/material.dart';

buildDialogBox(BuildContext context, {required Widget dialogBoxWidget}) {
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (context) => dialogBoxWidget,
  );
}
