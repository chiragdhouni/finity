part of 'lost_item_bloc.dart';

@immutable
sealed class LostItemEvent {}

class CreateLostItem extends LostItemEvent {
  final String name;
  final String description;
  final String status;
  final DateTime dateLost;
  final String contactInfo;
  final String ownerId;
  final String ownerName;
  final String ownerEmail;
  final String ownerAddress;
  final double latitude;
  final double longitude;

  CreateLostItem({
    required this.name,
    required this.description,
    required this.status,
    required this.dateLost,
    required this.contactInfo,
    required this.ownerId,
    required this.ownerName,
    required this.ownerEmail,
    required this.ownerAddress,
    required this.latitude,
    required this.longitude,
  });
}
