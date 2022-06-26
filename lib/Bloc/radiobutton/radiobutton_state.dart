part of 'radiobutton_bloc.dart';

class RadiobuttonState extends Equatable {
   int selectedIndex;

   RadiobuttonState({required this.selectedIndex});

  @override
  List<Object> get props => [selectedIndex];
}

class RadiobuttonInitial extends RadiobuttonState {
   RadiobuttonInitial({required int selectedIndex})
      : super(selectedIndex: selectedIndex);
}
