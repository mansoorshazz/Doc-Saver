import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'image_event.dart';
part 'image_state.dart';

class ImageBloc extends Bloc<ImageEvent, ImageState> {
  ImageBloc() : super(ImageInitial(imageFiles: const [])) {
    on<AddImageEvent>(_addImage);
    on<DeleteImageEvent>(_deleteImage);
  }

  // ==================================================================================================
  // tHis method is used to add the imagefiles in to state.

  void _addImage(AddImageEvent event, Emitter<ImageState> emit) {
    final state = this.state;

    // state.imageFiles = [];

    List<File> imageFiles = event.imagefiles;

    emit(
      ImageState(
        imageFiles: imageFiles,
      ),
    );
  }

  // ================================================================================================
  // this method is used to delete image using index.

  void _deleteImage(DeleteImageEvent event, Emitter<ImageState> emit) {
    final state = this.state;

    emit(
      ImageState(
        imageFiles: List.of(state.imageFiles)..removeAt(event.index),
      ),
    );
  }
}
