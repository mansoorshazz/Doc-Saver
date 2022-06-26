part of 'expirydate_bloc.dart';

class ExpirydateEvent extends Equatable {
  const ExpirydateEvent();

  @override
  List<Object> get props => [];
}

class SelectDateEvent extends ExpirydateEvent {
  final dynamic selectedDate;

  const SelectDateEvent({required this.selectedDate});

  @override
  List<Object> get props => [selectedDate!];
}

class CancelDateEvent extends ExpirydateEvent {}
