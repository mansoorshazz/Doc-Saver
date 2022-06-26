part of 'add_category_bloc.dart';

class AddCategoryState extends Equatable {
  String newAdded;

  AddCategoryState({required this.newAdded});

  @override
  List<Object> get props => [newAdded];
}

class AddCategoryInitial extends AddCategoryState {
  AddCategoryInitial({required String newAdded}) : super(newAdded: newAdded);
}
