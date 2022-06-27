import 'dart:io';
import 'package:docs_saver/Bloc/home_categories/categorychanging_bloc.dart';
import 'package:docs_saver/Model/document_model.dart';
import 'package:docs_saver/Views/Add%20details/add_edit_details.dart';
import 'package:docs_saver/Views/Details_page/Widgets/build_custom_text.dart';
import 'package:docs_saver/Views/Home/home.dart';
import 'package:docs_saver/Views/Widgets/dialog_box.dart';
import 'package:docs_saver/core/color.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/intl.dart';
import 'package:share_plus/share_plus.dart';

class DetailsScreen extends StatelessWidget {
  final int categoryIndex;
  final int itemINdex;

  const DetailsScreen({
    Key? key,
    required this.categoryIndex,
    required this.itemINdex,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size mediaQuery = MediaQuery.of(context).size;

    return ValueListenableBuilder<Box<DocumentCategory>>(
      valueListenable: BoxSingleTon.getInstance().listenable(),
      builder: (context, Box<DocumentCategory> box, _) {
        DocumentCategory? category;
        DocumentModel documentModel;

        try {
          category = box.getAt(categoryIndex);

          documentModel = category!.documents[itemINdex];
        } on RangeError {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        return Scaffold(
          appBar: buildAppbar(
            context,
            documentCategory: category,
            documentModel: documentModel,
            categoryName: category.categoryName,
            box: box,
          ),
          bottomSheet: buildBottomSheet(
            mediaQuery,
            documentModel: documentModel,
            categoryName: category.categoryName,
          ),
          body: PageView.builder(
            itemCount: documentModel.documentImagePath.length,
            physics: const BouncingScrollPhysics(),
            itemBuilder: (context, index) {
              File imagFile = File(
                documentModel.documentImagePath[index],
              );

              return Column(
                children: [
                  const SizedBox(
                    height: 10,
                  ),
                  Container(
                    height: mediaQuery.height * 0.51,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: FileImage(
                          imagFile,
                        ),
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        );
      },
    );
  }

// =================================================================================================================
// This method  is used to show the appbar and the popmenubutton.

  AppBar buildAppbar(BuildContext context,
      {required DocumentModel documentModel,
      required DocumentCategory documentCategory,
      required String categoryName,
      required Box<DocumentCategory> box}) {
    List<Map> popupMenuDetails = [
      {
        "title": "Share",
        "icon": Icons.share,
      },
      {
        "title": "Edit",
        "icon": Icons.edit,
      },
      {
        "title": "Delete",
        "icon": Icons.delete,
      },
    ];

    List<DocumentModel> documents = documentCategory.documents;

    int documentsLength = documents.length;

    CategorychangingBloc categorychangingBloc =
        BlocProvider.of<CategorychangingBloc>(context);

    return AppBar(
      title: const Text("Doc Details"),
      centerTitle: true,
      actions: [
        PopupMenuButton(
          onSelected: (value) {
            if (value == 0) {
              Share.shareFiles(
                documentModel.documentImagePath,
                text: '''Title : ${documentModel.documentTitle}
Description  : ${documentModel.description}''',
                subject: 'Document',
              );
            } else if (value == 1) {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => AddAndEditDetailsScreen(
                    isEditing: true,
                    editingDetails: {
                      "categoryName": categoryName,
                      "documentTitle": documentModel.documentTitle,
                      "description": documentModel.description,
                      "images": documentModel.documentImagePath,
                      "expiryDate": documentModel.expiryDate,
                    },
                    itemIndex: itemINdex,
                  ),
                ),
              );
            } else {
              if (documentsLength == 1) {
                _deleteDocument(
                  context,
                  deleteFunction: () async {
                    categorychangingBloc.add(const ChangeIndexEvent(index: 0));

                    await box.deleteAt(categoryIndex);

                    Navigator.of(context).pushAndRemoveUntil(
                        MaterialPageRoute(
                            builder: (context) => const HomeScreen()),
                        (route) => false);
                  },
                );
              } else {
                List<DocumentModel> updatedList = documents
                  ..removeAt(itemINdex);

                _deleteDocument(
                  context,
                  deleteFunction: () async {
                    categorychangingBloc.add(
                      const ChangeIndexEvent(
                        index: 0,
                      ),
                    );

                    await box.putAt(
                      categoryIndex,
                      DocumentCategory(
                        categoryName: categoryName,
                        documents: updatedList,
                      ),
                    );

                    Navigator.of(context).pushAndRemoveUntil(
                        MaterialPageRoute(
                          builder: (context) => const HomeScreen(),
                        ),
                        (route) => false);
                  },
                );
              }
            }
          },
          itemBuilder: (context) => List.generate(
            3,
            (index) => PopupMenuItem<int>(
              value: index,
              child: Row(
                children: [
                  Icon(
                    popupMenuDetails[index]['icon'],
                    color: Colors.black54,
                    size: 20,
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Text(
                    popupMenuDetails[index]['title'],
                    style: const TextStyle(fontWeight: FontWeight.w400),
                  ),
                ],
              ),
              // onTap: popupMenuDetails[index]['function'],
            ),
          ),
        ),
      ],
    );
  }

  // ===================================================================================================3
  // This method is used to show the bottomsheet. the bottomsheet showin gthe document details.

  Container buildBottomSheet(
    Size mediaQuery, {
    required DocumentModel documentModel,
    required String categoryName,
  }) {
    String formatedExpiryDate = documentModel.expiryDate != null
        ? DateFormat("yyyy - MMM - dd").format(documentModel.expiryDate!)
        : "No selected date";

    return Container(
      height: mediaQuery.height * 0.34,
      width: double.infinity,
      decoration: BoxDecoration(
        color: themeClr,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(10),
          topRight: Radius.circular(10),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            BuildCustomText(
              text: documentModel.documentTitle,
            ),
            const SizedBox(
              height: 10,
            ),
            BuildCustomText(
              text: documentModel.description,
              fontSize: 16,
              maxLines: 6,
              fontWeight: FontWeight.w300,
            ),
            const SizedBox(
              height: 10,
            ),
            const Spacer(),
            BuildCustomText(
              text: 'Category     :  $categoryName',
              fontSize: 16,
              fontWeight: FontWeight.w400,
            ),
            const SizedBox(
              height: 10,
            ),
            BuildCustomText(
              text: "Expiry Date :  $formatedExpiryDate",
              fontSize: 16,
              fontWeight: FontWeight.w400,
            ),
            const SizedBox(
              height: 10,
            )
          ],
        ),
      ),
    );
  }

// ======================================================================
// delete a document

  _deleteDocument(
    BuildContext context, {
    required VoidCallback deleteFunction,
  }) {
    ButtonStyle style = OutlinedButton.styleFrom(
      backgroundColor: Colors.white,
    );

    AlertDialog dialogWidget = AlertDialog(
      backgroundColor: themeClr,
      title: Text(
        'Delete document',
        style: TextStyle(color: kWhite),
      ),
      content: Text(
        'Are you sure ?',
        style: TextStyle(color: kWhite),
      ),
      actions: [
        OutlinedButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          style: style,
          child: Text(
            "No",
            style: TextStyle(color: themeClr),
          ),
        ),
        OutlinedButton(
          onPressed: deleteFunction,
          style: style,
          child: Text(
            "Yes",
            style: TextStyle(
              color: themeClr,
            ),
          ),
        )
      ],
    );

    buildDialogBox(context, dialogBoxWidget: dialogWidget);
  }
}
