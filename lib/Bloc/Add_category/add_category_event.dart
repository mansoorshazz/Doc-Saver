// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'add_category_bloc.dart';

class AddCategoryEvent extends Equatable {
  const AddCategoryEvent();

  @override
  List<Object> get props => [];
}

class ChangeCategoryName extends AddCategoryEvent {
  final String newAddedCategory;
  const ChangeCategoryName({
    required this.newAddedCategory,
  });

  @override
  List<Object> get props => [newAddedCategory];
}
