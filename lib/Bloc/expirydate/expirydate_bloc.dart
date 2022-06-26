import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'expirydate_event.dart';
part 'expirydate_state.dart';

class ExpirydateBloc extends Bloc<ExpirydateEvent, ExpirydateState> {
  ExpirydateBloc() : super(ExpirydateInitial(selectDate: "")) {
    on<SelectDateEvent>(_changeExpiryDate);
    on<CancelDateEvent>(_cancelExpiryDate);
  }

// ============================================================================================================
// This method is used to change the expiry date when the user click the date button.

  _changeExpiryDate(SelectDateEvent event, Emitter<ExpirydateState> emit) {
    emit(
      ExpirydateState(
        selectDate: event.selectedDate,
      ),
    );
  }

// ============================================================================================================
// This method is used to cancel the the date button.

  _cancelExpiryDate(CancelDateEvent event, Emitter<ExpirydateState> emit) {
    // state.selectDate = null;

    emit(
      ExpirydateState(selectDate: ""),
    );
  }
}
