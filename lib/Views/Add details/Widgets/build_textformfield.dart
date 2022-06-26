import 'package:docs_saver/Model/document_model.dart';
import 'package:docs_saver/Views/Home/home.dart';
import 'package:docs_saver/core/color.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

class BuildTextFormField extends StatelessWidget {
  BuildTextFormField({
    Key? key,
    required this.hintText,
    this.maxLines = 1,
    this.keyboardType = TextInputType.name,
    required this.controller,
    this.isCategoryValidation = false,
    this.fillColor = Colors.white,
  }) : super(key: key);

  final String hintText;
  final TextInputType keyboardType;
  final bool isCategoryValidation;

  final int maxLines;
  final TextEditingController controller;

  Color fillColor;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      maxLines: maxLines,
      cursorColor: Colors.black,
      textAlignVertical: TextAlignVertical.center,
      keyboardType: keyboardType,
      validator: (value) {
        if (value!.isEmpty || value.trim().isEmpty) {
          return '*required';
        } else if (value.startsWith(' ')) {
          print(value);
          return "*please avoid whitespace";
        }

        bool alphaNumeric = value.contains(
          RegExp(
            r'^[a-zA-Z0-9- ]+$',
          ),
        );

        if (!alphaNumeric) {
          return "*please enter albhabets or numbers eg: abc or abc123";
        }

        if (isCategoryValidation) {
          Box<DocumentCategory> box = BoxSingleTon.getInstance();

          List<DocumentCategory> documents = box.values.toList();

          String categoryName = controller.text;

          bool isValid = documents.any((element) =>
              element.categoryName.trim().toLowerCase() ==
              categoryName.trim().toLowerCase());

          return isValid ? '*category name already exist.' : null;
        }

        return null;
      },
      decoration: InputDecoration(
        hintText: hintText,
        contentPadding: const EdgeInsets.all(10),
        focusColor: Colors.amber,
        focusedErrorBorder: const OutlineInputBorder(
          borderSide: BorderSide(
            color: Colors.red,
            width: 1.5,
          ),
        ),
        fillColor: fillColor,
        filled: true,
        errorBorder: const OutlineInputBorder(
          borderSide: BorderSide(
            color: Colors.red,
            width: 1.5,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: themeClr,
            width: 1.5,
          ),
        ),
        focusedBorder: const OutlineInputBorder(
          borderSide: BorderSide(
            color: Colors.black,
            width: 1.5,
          ),
        ),
      ),
    );
  }
}
