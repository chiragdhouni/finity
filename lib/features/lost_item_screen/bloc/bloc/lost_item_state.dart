part of 'lost_item_bloc.dart';

sealed class LostItemState {}

final class LostItemInitial extends LostItemState {}

final class LostItemLoading extends LostItemState {}

final class LostItemSuccess extends LostItemState {
  final LostItem lostItem;

  LostItemSuccess(this.lostItem);
}

final class LostItemFailure extends LostItemState {
  final String message;

  LostItemFailure(this.message);
}

final class LostItemSearchSuccess extends LostItemState {
  final List<LostItem> lostItems;

  LostItemSearchSuccess(this.lostItems);
}

final class nearByLostItemSuccess extends LostItemState {
  final List<LostItem> lostItems;

  nearByLostItemSuccess(this.lostItems);
}
