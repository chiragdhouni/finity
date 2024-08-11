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

class FetchNearbyItemsEvent extends ItemEvent {
  final double latitude;
  final double longitude;
  final double maxDistance;

  FetchNearbyItemsEvent({
    required this.latitude,
    required this.longitude,
    required this.maxDistance,
  });
}

class SearchItemsEvent extends ItemEvent {
  final String query;

  SearchItemsEvent(this.query);
}
