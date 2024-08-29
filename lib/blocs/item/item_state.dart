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

class ItemFetched extends ItemState {
  final List<ItemModel>? data;

  ItemFetched(this.data);
}

class ItemSearchLoading extends ItemState {}

class ItemSearchSuccess extends ItemState {
  final List<ItemModel> searchResults;

  ItemSearchSuccess(this.searchResults);
}

class ItemSearchError extends ItemState {
  final String error;

  ItemSearchError(this.error);
}

class ItemBorrowSuccess extends ItemState {}

class ItemBorrowError extends ItemState {
  final String error;

  ItemBorrowError(this.error);
}
