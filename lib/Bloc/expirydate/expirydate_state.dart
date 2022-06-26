part of 'expirydate_bloc.dart';

class ExpirydateState extends Equatable {
  // I user dynamic type we can change the data type the user selecting.
  // The 1st select type is String and its empty.
  //Then the user click the select date button this type will be change to DateTime.

  dynamic selectDate;

  ExpirydateState({required this.selectDate});

  @override
  List<Object> get props => [selectDate!];
}

class ExpirydateInitial extends ExpirydateState {
  ExpirydateInitial({required dynamic selectDate})
      : super(selectDate: selectDate);
}
