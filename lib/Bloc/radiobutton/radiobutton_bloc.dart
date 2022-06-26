import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'radiobutton_event.dart';
part 'radiobutton_state.dart';

class RadiobuttonBloc extends Bloc<RadiobuttonEvent, RadiobuttonState> {
  RadiobuttonBloc() : super(RadiobuttonInitial(selectedIndex: 0)) {
    on<ChangeRadioButtonIndex>((event, emit) {
      // TODO: implement event handler
      emit(RadiobuttonState(selectedIndex: event.selectedIndex));
    });
  }
}
