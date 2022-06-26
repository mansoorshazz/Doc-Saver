part of 'categorychanging_bloc.dart';

class CategorychangingState extends Equatable {
  final int index;

  const CategorychangingState({required this.index});

  @override
  List<Object> get props => [index];
}

class CategorychangingInitial extends CategorychangingState {
  const CategorychangingInitial({required int index}) : super(index: index);
}
