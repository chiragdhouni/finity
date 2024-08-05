part of 'item_bloc.dart';

@immutable
sealed class ItemEvent {}

class AddItemEvent extends ItemEvent {
  final String userId;
  final String itemName;
  final String description;
  final String itemCategory;
  final DateTime dueDate;

  AddItemEvent({
    required this.userId,
    required this.itemName,
    required this.description,
    required this.itemCategory,
    required this.dueDate,
  });
}

class RequestToBorrowItemEvent extends ItemEvent {
  final String itemId;
  final String borrowerId;
  final String dueDate;

  RequestToBorrowItemEvent({
    required this.itemId,
    required this.borrowerId,
    required this.dueDate,
  });
}
