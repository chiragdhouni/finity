// lost_item_state.dart
part of 'lost_item_bloc.dart';

abstract class LostItemState {}

class LostItemInitial extends LostItemState {}

class LostItemLoading extends LostItemState {}

class lostItemCreated extends LostItemState {
  final LostItem lostItem;
  lostItemCreated(this.lostItem);
}

class LostItemSuccess extends LostItemState {
  final LostItem lostItem;
  LostItemSuccess(this.lostItem);
}

class SearchLostItemSuccess extends LostItemState {
  final List<LostItem> lostItems;
  SearchLostItemSuccess(this.lostItems);
}

class NearByLostItemSuccess extends LostItemState {
  final List<LostItem> lostItems;
  NearByLostItemSuccess(this.lostItems);
}

class LostItemError extends LostItemState {
  final String message;
  LostItemError(this.message);
}

class SubmitClaimSuccess extends LostItemState {}

class LostItemDeleteSuccess extends LostItemState {}

class AcceptClaimSuccess extends LostItemState {}

class RejectClaimSuccess extends LostItemState {}

class LostItemUpdateSuccess extends LostItemState {
  final LostItem lostItem;
  LostItemUpdateSuccess(this.lostItem);
}
