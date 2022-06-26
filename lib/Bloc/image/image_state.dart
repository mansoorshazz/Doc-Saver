part of 'image_bloc.dart';

class ImageState extends Equatable {
  List<File> imageFiles;

  ImageState({
    required this.imageFiles,
  });

  @override
  List<Object> get props => [imageFiles];
}

class ImageInitial extends ImageState {
  ImageInitial({required List<File> imageFiles})
      : super(imageFiles: imageFiles);
}
