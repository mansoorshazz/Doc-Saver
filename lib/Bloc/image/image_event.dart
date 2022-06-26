// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'image_bloc.dart';

class ImageEvent extends Equatable {
  const ImageEvent();

  @override
  List<Object> get props => [];
}

class AddImageEvent extends ImageEvent {
  final List<File> imagefiles;

  const AddImageEvent({
    required this.imagefiles,
  });

  @override
  List<Object> get props => [imagefiles];
}

class DeleteImageEvent extends ImageEvent {
  final int index;

  const DeleteImageEvent({
    required this.index,
  });

  @override
  List<Object> get props => [index];
}
