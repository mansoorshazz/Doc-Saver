import 'dart:io';
import 'package:docs_saver/Bloc/Add_category/add_category_bloc.dart';
import 'package:docs_saver/Bloc/expirydate/expirydate_bloc.dart';
import 'package:docs_saver/Bloc/radiobutton/radiobutton_bloc.dart';
import 'package:docs_saver/Model/document_model.dart';
import 'package:docs_saver/Views/Add%20details/Widgets/build_textformfield.dart';
import 'package:docs_saver/Views/Add%20details/Widgets/build_title.dart';
import 'package:docs_saver/Views/Widgets/dialog_box.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive/hive.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import '../../Bloc/image/image_bloc.dart';
import '../../core/color.dart';
import 'Widgets/build_sized_box.dart';

class AddAndEditDetailsScreen extends StatefulWidget {
  final bool isEditing;
  Map editingDetails;
  int itemIndex;

  AddAndEditDetailsScreen({
    Key? key,
    this.isEditing = false,
    this.editingDetails = const {},
    this.itemIndex = 0,
  }) : super(key: key);

  @override
  State<AddAndEditDetailsScreen> createState() =>
      _AddAndEditDetailsScreenState();
}

class _AddAndEditDetailsScreenState extends State<AddAndEditDetailsScreen> {
  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController categorycontroller = TextEditingController();

  final GlobalKey<FormState> _formkey = GlobalKey<FormState>();
  final GlobalKey<FormState> _categoryFormkey = GlobalKey<FormState>();

  List<dynamic> alreadyaddedCategories = [
    "HOme",
    "license",
    "Bill",
  ];

  List<String> priorityTitles = [
    "Not Important",
    "Important",
  ];

  String categoryName = "";

  // String newAdded = "Add new one";

  List<XFile>? xfiles;
  late List<DocumentCategory> allDocumentCategory;

  DateTime? selectedDate;

  late ImageBloc imageBloc;
  late ExpirydateBloc expirydateBloc;
  late RadiobuttonBloc radiobuttonBloc;
  late AddCategoryBloc addCategoryBloc;

  late Box<DocumentCategory> box;

  @override
  void initState() {
    imageBloc = BlocProvider.of<ImageBloc>(context);
    expirydateBloc = BlocProvider.of<ExpirydateBloc>(context);
    radiobuttonBloc = BlocProvider.of<RadiobuttonBloc>(context);
    addCategoryBloc = BlocProvider.of<AddCategoryBloc>(context);

    box = BoxSingleTon.getInstance();
    allDocumentCategory = box.values.toList();

    if (widget.isEditing) {
      titleController.text = widget.editingDetails['documentTitle'];
      descriptionController.text = widget.editingDetails['description'];
      categoryName = widget.editingDetails['categoryName'];

      expirydateBloc.state.selectDate =
          widget.editingDetails['expiryDate'] ?? "";

      imageBloc.state.imageFiles = List.generate(
        widget.editingDetails['images'].length,
        (index) => File(
          widget.editingDetails['images'][index],
        ),
      );

      xfiles = List.generate(
        widget.editingDetails['images'].length,
        (index) => XFile(
          widget.editingDetails['images'][index],
        ),
      );

      print(categoryName);
    }

    // TODO: implement initState
    super.initState();
  }

  @override
  void dispose() {
    imageBloc.state.imageFiles = [];
    expirydateBloc.state.selectDate = "";
    addCategoryBloc.state.newAdded = "Add new one";
    radiobuttonBloc.state.selectedIndex = 0;
    titleController.dispose();
    descriptionController.dispose();

    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppbar(context),
      body: Padding(
        padding: const EdgeInsets.only(left: 10, right: 10, top: 10),
        child: Form(
          key: _formkey,
          child: ListView(
            shrinkWrap: true,
            physics: const BouncingScrollPhysics(),
            children: [
              BuildSizedBox(
                height: 10,
              ),
              const BuildTitleText(
                title: 'Images',
              ),
              BuildSizedBox(
                height: 10,
              ),
              buildImageDisplayImages(context),
              BuildSizedBox(),
              const BuildTitleText(
                title: 'Document Title',
              ),
              BuildSizedBox(
                height: 10,
              ),
              BuildTextFormField(
                hintText: 'Enter document title.',
                controller: titleController,
              ),
              BuildSizedBox(),
              const BuildTitleText(
                title: 'Description',
              ),
              BuildSizedBox(
                height: 10,
              ),
              BuildTextFormField(
                hintText: 'Enter your document description.',
                controller: descriptionController,
                maxLines: 5,
              ),
              BuildSizedBox(),
              buildDropdownList(),
              BuildSizedBox(),
              const BuildTitleText(
                title: 'Expiry Date (Optional)',
              ),
              BuildSizedBox(
                height: 10,
              ),
              buildExpiryDateWidget(context),
              BuildSizedBox(),
              const BuildTitleText(title: 'Priority'),
              ...buildPriority()
            ],
          ),
        ),
      ),
    );
  }

  //==================================================================================================================================================
  //This method is used to show the priority radio buttons.

  List<Widget> buildPriority() {
    return List.generate(
      priorityTitles.length,
      (index) => BlocBuilder<RadiobuttonBloc, RadiobuttonState>(
        builder: (context, state) {
          int selectedIndex = state.selectedIndex;

          return RadioListTile<int>(
            activeColor: themeClr,
            value: index,
            groupValue: selectedIndex,
            title: Text(priorityTitles[index]),
            onChanged: (int? value) {
              radiobuttonBloc.add(
                ChangeRadioButtonIndex(
                  selectedIndex: value!,
                ),
              );
            },
          );
        },
      ),
    );
  }

  // =============================================================================================================================================
  // This method is used to show the appbar widget and the 2 buttons and title. 1st button is backbutton and 2nd is document save button.

  AppBar buildAppbar(BuildContext context) {
    return AppBar(
      centerTitle: true,
      title: const BuildTitleText(
        title: 'Add doc details',
      ),
      actions: [
        IconButton(
          onPressed: () async {
            bool isValid = _formkey.currentState!.validate();

            if (xfiles == null || xfiles!.isEmpty) {
              buildCustomSnackbar("Please add images!!");
              return;
            }

            if (isValid) {
              List<String> imagesPath =
                  imageBloc.state.imageFiles.map((e) => e.path).toList();

              int prioritySelectedIndex = radiobuttonBloc.state.selectedIndex;

              String priority = priorityTitles[prioritySelectedIndex];

              dynamic expiryDate = expirydateBloc.state.selectDate;

              bool isCategoryAlreadyExist = allDocumentCategory
                  .any((element) => element.categoryName == categoryName);

              if (isCategoryAlreadyExist) {
                int categoryIndex = allDocumentCategory.indexWhere(
                    (element) => element.categoryName == categoryName);

                List<DocumentModel> documentModels =
                    box.values.toList()[categoryIndex].documents;

                if (widget.isEditing) {
                  documentModels[widget.itemIndex] = DocumentModel(
                    documentImagePath: imagesPath,
                    documentTitle: titleController.text,
                    description: descriptionController.text,
                    expiryDate: expiryDate == "" ? null : expiryDate,
                    priority: priority,
                  );

                  await box.putAt(
                    categoryIndex,
                    DocumentCategory(
                      categoryName: categoryName,
                      documents: documentModels,
                    ),
                  );
                } else {
                  await box.putAt(
                    categoryIndex,
                    DocumentCategory(
                      categoryName: categoryName,
                      documents: documentModels
                        ..add(
                          DocumentModel(
                            documentImagePath: imagesPath,
                            documentTitle: titleController.text,
                            description: descriptionController.text,
                            expiryDate: expiryDate == "" ? null : expiryDate,
                            priority: priority,
                          ),
                        ),
                    ),
                  );
                }
              } else {
                await box.add(
                  DocumentCategory(
                    categoryName: categoryName,
                    documents: [
                      DocumentModel(
                        documentImagePath: imagesPath,
                        documentTitle: titleController.text,
                        description: descriptionController.text,
                        expiryDate: expiryDate == "" ? null : expiryDate,
                        priority: priority,
                      )
                    ],
                  ),
                );
              }

              Navigator.of(context).pop();
            }
          },
          icon: const Icon(Icons.done),
        ),
        const SizedBox(
          width: 7,
        )
      ],
    );
  }

  // ===================================================================================================================================
  // This method is used to show the 2 button of selecting date and cancel date.

  BlocBuilder buildExpiryDateWidget(BuildContext context) {
    ButtonStyle outlinedButtonStyle = OutlinedButton.styleFrom(
      backgroundColor: themeClr,
    );

    return BlocBuilder<ExpirydateBloc, ExpirydateState>(
      builder: (context, state) {
        return Row(
          children: [
            OutlinedButton(
              style: outlinedButtonStyle,
              onPressed: () {
                _selectDate(context);
              },
              child: const Text(
                'Select Date',
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
            ),
            Expanded(
              child: Center(
                child: BlocBuilder<ExpirydateBloc, ExpirydateState>(
                  builder: (context, state) {
                    String formatedExpiryDate = state.selectDate != ""
                        ? DateFormat("yyyy - MMM - dd")
                            .format(state.selectDate!)
                        : "No selected date";

                    return Text(
                      formatedExpiryDate,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(fontWeight: FontWeight.w600),
                    );
                  },
                ),
              ),
            ),
            OutlinedButton(
              style: outlinedButtonStyle,
              onPressed: () {
                expirydateBloc.add(CancelDateEvent());
              },
              child: const Text(
                'Cancel Date',
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  // ====================================================================================
  // This method is used to show the selected images and add button for gallerry and camera.

  SingleChildScrollView buildImageDisplayImages(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      physics: const BouncingScrollPhysics(),
      child: Row(
        children: [
          Card(
            child: Container(
              height: 142,
              width: 100,
              decoration: BoxDecoration(
                color: themeClr,
                borderRadius: BorderRadius.circular(3),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  InkWell(
                    onTap: () {
                      _addImages(
                        isCamera: false,
                      );
                    },
                    child: Column(
                      children: [
                        Icon(
                          Icons.image,
                          size: 35,
                          color: kWhite,
                        ),
                        Text(
                          'Gallery',
                          style: TextStyle(
                            color: kWhite,
                          ),
                        )
                      ],
                    ),
                  ),
                  const Divider(
                    thickness: 1,
                    color: Colors.grey,
                  ),
                  InkWell(
                    onTap: () {
                      _addImages(
                        isCamera: true,
                      );
                    },
                    child: Column(
                      children: [
                        Icon(
                          Icons.camera,
                          size: 35,
                          color: kWhite,
                        ),
                        Text(
                          'Camera',
                          style: TextStyle(
                            color: kWhite,
                          ),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(
            width: 10,
          ),
          SizedBox(
            height: 150,
            child: BlocBuilder<ImageBloc, ImageState>(
              builder: (bloccontext, state) {
                List<File> imageFiles = state.imageFiles;

                print('rebuiilding');

                return ListView.separated(
                  shrinkWrap: true,
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (context, index) {
                    return Stack(
                      children: [
                        Card(
                          child: Container(
                            height: 150,
                            width: 100,
                            decoration: BoxDecoration(
                              color: Colors.black,
                              borderRadius: BorderRadius.circular(3),
                              image: DecorationImage(
                                image: FileImage(
                                  imageFiles[index],
                                ),
                              ),
                            ),
                          ),
                        ),
                        Positioned(
                          left: 80,
                          child: GestureDetector(
                            onTap: () {
                              xfiles!.removeAt(index);

                              imageBloc.add(
                                DeleteImageEvent(
                                  index: index,
                                ),
                              );
                            },
                            child: CircleAvatar(
                              radius: 13,
                              backgroundColor: Colors.red,
                              child: Icon(
                                Icons.close,
                                size: 15,
                                color: kWhite,
                              ),
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                  separatorBuilder: (context, index) => const SizedBox(
                    width: 10,
                  ),
                  itemCount: imageFiles.length,
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  //====================================================================================================================================
  // This method is used to show the already added document types. The user is first time then the widget is didn't visible.

  Visibility buildDropdownList() {
    List<DocumentCategory> values = box.values.toList();

    List<String> allCategories = values.map((e) => e.categoryName).toList();

    return Visibility(
      visible: widget.isEditing ? false : true,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const BuildTitleText(
            title: 'Add Category',
          ),
          BuildSizedBox(
            height: 10,
          ),
          BlocBuilder<AddCategoryBloc, AddCategoryState>(
            builder: (context, state) {
              String newAdded = state.newAdded;

              allCategories = allCategories.isEmpty
                  ? [newAdded]
                  : allCategories = [
                      ...allCategories,
                      newAdded,
                    ];

              return DropdownButtonFormField<String>(
                validator: (value) {
                  if (value == "Add new one") {
                    return "*required";
                  }
                  return null;
                },
                value: newAdded,
                decoration: InputDecoration(
                  labelStyle: const TextStyle(
                    color: Colors.black,
                  ),
                  enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: themeClr)),
                  focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: themeClr)),
                ),
                items: List.generate(
                  allCategories.length,
                  (index) => DropdownMenuItem(
                    child: Text(allCategories[index]),
                    value: allCategories[index],
                  ),
                ),
                onChanged: (value) {
                  categoryName = value!;

                  if (value == "Add new one") {
                    ButtonStyle style = OutlinedButton.styleFrom(
                      backgroundColor: Colors.white,
                    );

                    Widget dialogWidget = Form(
                      key: _categoryFormkey,
                      child: AlertDialog(
                        backgroundColor: themeClr,
                        title: const Text(
                          'Add new category',
                          style: TextStyle(color: Colors.white),
                        ),
                        content: BuildTextFormField(
                          hintText: "Add new one",
                          controller: categorycontroller,
                          isCategoryValidation: true,
                        ),
                        actions: [
                          OutlinedButton(
                            style: style,
                            onPressed: () {
                              categorycontroller.clear();
                              Navigator.of(context).pop();
                            },
                            child: Text(
                              "Cancel",
                              style: TextStyle(
                                color: themeClr,
                              ),
                            ),
                          ),
                          OutlinedButton(
                            style: style,
                            onPressed: () {
                              bool isValid =
                                  _categoryFormkey.currentState!.validate();

                              if (isValid) {
                                addCategoryBloc.add(
                                  ChangeCategoryName(
                                    newAddedCategory:
                                        categorycontroller.text.trim(),
                                  ),
                                );
                                categoryName = categorycontroller.text.trim();
                                categorycontroller.clear();
                                Navigator.of(context).pop();
                              }
                            },
                            child: Text(
                              "Save",
                              style: TextStyle(
                                color: themeClr,
                              ),
                            ),
                          )
                        ],
                      ),
                    );

                    buildDialogBox(
                      context,
                      dialogBoxWidget: dialogWidget,
                    );
                  }
                },
              );
            },
          ),
        ],
      ),
    );
  }

  // ===================================================================
  // This method is used to add images through cameera and gallery.

  void _addImages({
    required bool isCamera,
  }) async {
    final ImagePicker imagePicker = ImagePicker();

    late List<File> imageFiles;

    ImageBloc imageBloc = BlocProvider.of<ImageBloc>(context);

    if (!isCamera) {
      xfiles = await imagePicker.pickMultiImage();

      if (xfiles == null) {
        return;
      }
    } else {
      XFile? xfile = await imagePicker.pickImage(source: ImageSource.camera);
      if (xfile == null) {
        print('NULL');
        return;
      }

      xfiles = [];

      xfiles!.add(xfile);
    }

    imageFiles = imageBloc.state.imageFiles.toList();

    imageFiles.addAll(
      xfiles!.map(
        (e) => File(e.path),
      ),
    );

    imageBloc.add(
      AddImageEvent(
        imagefiles: imageFiles,
      ),
    );
  }

// ===========================================================================================================================
// This method is used to showt the date widget and user can select the expiry date.

  Future<void> _selectDate(BuildContext context) async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate ?? DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2101),
    );

    if (picked != null && picked != selectedDate) {
      selectedDate = picked;

      expirydateBloc.add(
        SelectDateEvent(
          selectedDate: selectedDate,
        ),
      );
    }
  }

// =============================================================================================================================
//

  buildCustomSnackbar(
    String contentTitle,
  ) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        duration: const Duration(seconds: 3),
        content: Text(
          contentTitle,
          style: TextStyle(
            color: kWhite,
          ),
        ),
        backgroundColor: themeClr,
      ),
    );
  }
}
