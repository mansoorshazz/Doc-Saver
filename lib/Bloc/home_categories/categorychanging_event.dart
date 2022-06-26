part of 'categorychanging_bloc.dart';

class CategorychangingEvent extends Equatable {
  const CategorychangingEvent();

  @override
  List<Object> get props => [];
}

class ChangeIndexEvent extends CategorychangingEvent {
  final int index;

  const ChangeIndexEvent({required this.index});
}
