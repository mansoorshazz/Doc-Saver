// ==================================================================================================
// This class used to store the type of document and documents.

import 'package:hive/hive.dart';

part 'document_model.g.dart';

@HiveType(typeId: 0)
class DocumentCategory {
  @HiveField(0)
  String categoryName;

  @HiveField(1)
  List<DocumentModel> documents;

  DocumentCategory({
    required this.categoryName,
    required this.documents,
  });
}

String boxName = "documents";

// ==============================================================
// This class is a model of document .

@HiveType(typeId: 1)
class DocumentModel {
  @HiveField(0)
  List<String> documentImagePath;

  @HiveField(1)
  String documentTitle;

  @HiveField(2)
  String description;

  @HiveField(3)
  DateTime? expiryDate;

  @HiveField(4)
  String priority;

  DocumentModel({
    required this.documentImagePath,
    required this.documentTitle,
    required this.description,
    required this.expiryDate,
    required this.priority,
  });
}

// =================================================================
// This class is used to call the hive box and get the box instance.

class BoxSingleTon {
  static Box<DocumentCategory> getInstance() {
    return Hive.box<DocumentCategory>(boxName);
  }
}
