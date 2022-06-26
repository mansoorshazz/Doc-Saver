part of 'radiobutton_bloc.dart';

class RadiobuttonEvent extends Equatable {
  const RadiobuttonEvent();

  @override
  List<Object> get props => [];
}

class ChangeRadioButtonIndex extends RadiobuttonEvent {
  final int selectedIndex;

  const ChangeRadioButtonIndex({required this.selectedIndex});

  @override
  List<Object> get props => [selectedIndex];
}
