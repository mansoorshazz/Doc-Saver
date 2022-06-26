import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'add_category_event.dart';
part 'add_category_state.dart';

class AddCategoryBloc extends Bloc<AddCategoryEvent, AddCategoryState> {
  AddCategoryBloc() : super(AddCategoryInitial(newAdded: "Add new one")) {
    on<ChangeCategoryName>(_changeCategoryName);
  }

  _changeCategoryName(
      ChangeCategoryName event, Emitter<AddCategoryState> emit) {
    emit(AddCategoryState(newAdded: event.newAddedCategory));
  }
}
