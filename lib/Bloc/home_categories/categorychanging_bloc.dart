import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'categorychanging_event.dart';
part 'categorychanging_state.dart';

class CategorychangingBloc
    extends Bloc<CategorychangingEvent, CategorychangingState> {
  CategorychangingBloc() : super(CategorychangingInitial(index: 0)) {
    on<ChangeIndexEvent>(_changeIndex);
  }



// ======================================================================================================================================================
// This method is used to change the category using index. When the user click the next category type the function will be called and the index change.

  _changeIndex(
    ChangeIndexEvent event,
    Emitter<CategorychangingState> emit,
  ) {
    int index = event.index;

    emit(CategorychangingState(index: index));
  }


}
