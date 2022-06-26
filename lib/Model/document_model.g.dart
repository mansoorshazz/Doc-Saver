// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'document_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class DocumentCategoryAdapter extends TypeAdapter<DocumentCategory> {
  @override
  final int typeId = 0;

  @override
  DocumentCategory read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return DocumentCategory(
      categoryName: fields[0] as String,
      documents: (fields[1] as List).cast<DocumentModel>(),
    );
  }

  @override
  void write(BinaryWriter writer, DocumentCategory obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.categoryName)
      ..writeByte(1)
      ..write(obj.documents);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DocumentCategoryAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class DocumentModelAdapter extends TypeAdapter<DocumentModel> {
  @override
  final int typeId = 1;

  @override
  DocumentModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return DocumentModel(
      documentImagePath: (fields[0] as List).cast<String>(),
      documentTitle: fields[1] as String,
      description: fields[2] as String,
      expiryDate: fields[3] as DateTime?,
      priority: fields[4] as String,
    );
  }

  @override
  void write(BinaryWriter writer, DocumentModel obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.documentImagePath)
      ..writeByte(1)
      ..write(obj.documentTitle)
      ..writeByte(2)
      ..write(obj.description)
      ..writeByte(3)
      ..write(obj.expiryDate)
      ..writeByte(4)
      ..write(obj.priority);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DocumentModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
