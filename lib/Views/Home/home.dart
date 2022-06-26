import 'dart:io';
import 'package:docs_saver/Model/document_model.dart';
import 'package:docs_saver/Views/Add%20details/add_edit_details.dart';
import 'package:docs_saver/Views/Details_page/details_screen.dart';
import 'package:docs_saver/core/color.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/intl.dart';

import '../../Bloc/home_categories/categorychanging_bloc.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late CategorychangingBloc categorychangingBloc;
  Box<DocumentCategory> box = BoxSingleTon.getInstance();
  int allDocsLength = 0;

  @override
  void initState() {
    categorychangingBloc = BlocProvider.of<CategorychangingBloc>(context);
    // box = BoxSingleTon.getInstance();

    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Document Saver'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 10, left: 10, right: 10),
        child: ValueListenableBuilder<Box<DocumentCategory>>(
            valueListenable: box.listenable(),
            builder: (BuildContext context, Box<DocumentCategory> box, _) {
              List<DocumentCategory> documents = box.values.toList();

              int allDocsLength = 0;

              for (var element in documents) {
                allDocsLength = allDocsLength + element.documents.length;
              }

              List<String> categories = [
                "All ($allDocsLength)",
                ...documents.map((e) => e.categoryName),
              ];

              if (documents.isEmpty) {
                return const Center(
                  child: Text(
                    'No Documents',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                );
              }

              return ListView(
                shrinkWrap: true,
                // crossAxisAlignment: CrossAxisAlignment.start,
                physics: const BouncingScrollPhysics(),
                children: [
                  buildCategoryTypes(categories),
                  const SizedBox(
                    height: 17,
                  ),
                  Text(
                    'Documents',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: themeClr,
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  buildDocuments(
                    categories,
                    documents,
                  ),
                ],
              );
            }),
      ),
      floatingActionButton: buildFloatingActionButton(context),
    );
  }

  //==================================================================================================================
  FloatingActionButton buildFloatingActionButton(BuildContext context) {
    return FloatingActionButton(
      backgroundColor: themeClr,
      onPressed: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => AddAndEditDetailsScreen(),
          ),
        );
      },
      child: Icon(Icons.add),
    );
  }

// ==================================================================================================================
  // This method is used to show the documents the category selected wise.

  BlocBuilder buildDocuments(
    List<String> categories,
    List<DocumentCategory> documents,
  ) {
    return BlocBuilder<CategorychangingBloc, CategorychangingState>(
      builder: (context, state) {
        List<Map<String, dynamic>> sortedDetails = [];

        int tappedIndex = state.index;

        if (tappedIndex == 0) {
          // sortedDetails = [];

          for (var doc in documents) {
            for (var element in doc.documents) {
              sortedDetails.add(
                {
                  "title": element.documentTitle,
                  "expiryDate": element.expiryDate,
                  "images": element.documentImagePath,
                  "priority": element.priority,
                  "categoryName": doc.categoryName,
                },
              );
            }
          }
        } else {
          // sortedDetails = [];

          for (var element in documents[tappedIndex - 1].documents) {
            sortedDetails.add(
              {
                "title": element.documentTitle,
                "expiryDate": element.expiryDate,
                "images": element.documentImagePath,
                "priority": element.priority,
                // "categoryName": doc.categoryName,
              },
            );
          }
        }

        return GridView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: tappedIndex == 0 ? 2 / 2.7 : 2 / 2.4,
            ),
            itemCount: sortedDetails.length,
            itemBuilder: (context, index) {
              String firstImage = sortedDetails[index]['images'][0];

              File imageFile = File(firstImage);

              String formatedExpiryDate =
                  sortedDetails[index]['expiryDate'] != null
                      ? DateFormat("yyyy - MMM - dd")
                          .format(sortedDetails[index]['expiryDate'])
                      : "No selected date";

              bool isImp = (formatedExpiryDate != 'No selected date' ||
                      sortedDetails[index]['priority'] == "Important")
                  ? true
                  : false;

              return GestureDetector(
                onTap: () {
                  int categoryINdex = -1;
                  int itemIndex = -1;

                  if (tappedIndex == 0) {
                    categoryINdex = documents.indexWhere(
                      (element) =>
                          element.categoryName ==
                          sortedDetails[index]['categoryName'],
                    );

                    itemIndex = documents[categoryINdex].documents.indexWhere(
                          (element) =>
                              element.documentTitle ==
                              sortedDetails[index]['title'],
                        );
                  } else {
                    categoryINdex = tappedIndex - 1;
                    itemIndex = index;
                  }

                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => DetailsScreen(
                        categoryIndex: categoryINdex,
                        itemINdex: itemIndex,
                      ),
                    ),
                  );
                },
                child: Card(
                  color: isImp ? themeClr : Colors.white,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        height: 130,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(3),
                          image: DecorationImage(
                            image: FileImage(imageFile),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 13,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 5),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              sortedDetails[index]['title'].toUpperCase(),
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: isImp ? Colors.white : Colors.black,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Visibility(
                              visible: tappedIndex == 0 ? true : false,
                              child: Text(
                                sortedDetails[index]['categoryName'] ?? '',
                                style: TextStyle(
                                  color: isImp ? Colors.white : Colors.black,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            SizedBox(
                              height: tappedIndex == 0 ? 10 : 0,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Text(
                                  formatedExpiryDate,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    color: isImp ? Colors.white : Colors.black,
                                  ),
                                ),
                                const SizedBox(
                                  width: 10,
                                )
                              ],
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              );
            });
      },
    );
  }

  //=============================================================================================================
  Padding buildCategoryTypes(List<String> categories) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 1,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Documents Types',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: themeClr,
            ),
          ),
          const SizedBox(
            height: 15,
          ),
          BlocBuilder<CategorychangingBloc, CategorychangingState>(
            builder: (context, state) {
              int tappedIndex = state.index;

              List<String> allCategories = categories;

              return SizedBox(
                height: 40,
                child: ListView.separated(
                  itemCount: allCategories.length,
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (context, index) {
                    Color bgColor =
                        tappedIndex == index ? themeClr : Colors.transparent;
                    Color borderColor =
                        tappedIndex == index ? Colors.transparent : themeClr;

                    return GestureDetector(
                      onTap: () {
                        categorychangingBloc
                            .add(ChangeIndexEvent(index: index));
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          color: bgColor,
                          border: Border.all(
                            color: borderColor,
                          ),
                        ),
                        child: Center(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            child: Text(
                              allCategories[index],
                              style: TextStyle(
                                color: tappedIndex == index
                                    ? Colors.white
                                    : themeClr,
                              ),
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                  separatorBuilder: (context, index) => SizedBox(
                    width: 10,
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
