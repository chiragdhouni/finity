part of 'item_bloc.dart';

@immutable
sealed class ItemState {}

final class ItemInitial extends ItemState {}

class ItemLoading extends ItemState {}

class ItemSuccess extends ItemState {}

class ItemError extends ItemState {
  final String error;

  ItemError({required this.error});
}
