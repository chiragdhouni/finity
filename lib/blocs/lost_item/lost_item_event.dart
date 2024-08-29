// ignore_for_file: camel_case_types

part of 'lost_item_bloc.dart';

sealed class LostItemEvent {}

class CreateLostItemEvent extends LostItemEvent {
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

  CreateLostItemEvent({
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

// class searchLostItemsByLocation extends LostItemEvent {
//   final double latitude;
//   final double longitude;
//   final double maxDistance;

//   searchLostItemsByLocation({
//     required this.latitude,
//     required this.longitude,
//     required this.maxDistance,
//   });
// }

class getNearByLostItemsEvent extends LostItemEvent {
  final double latitude;
  final double longitude;
  final double maxDistance;

  getNearByLostItemsEvent({
    required this.latitude,
    required this.longitude,
    required this.maxDistance,
  });
}

class searchLostItemEvent extends LostItemEvent {
  final String searchQuery;

  searchLostItemEvent({
    required this.searchQuery,
  });
}

class deleteLostItemEvent extends LostItemEvent {
  final String lostItemId;

  deleteLostItemEvent({
    required this.lostItemId,
  });
}

class ClearSearchResultsEvent extends LostItemEvent {}

class getLostItemByIdEvent extends LostItemEvent {
  final String lostItemId;

  getLostItemByIdEvent({
    required this.lostItemId,
  });
}

class updateLostItemEvent extends LostItemEvent {
  final LostItem lostItem;

  updateLostItemEvent({
    required this.lostItem,
  });
}

// claiming lost item

class SubmitClaimEvent extends LostItemEvent {
  final String lostItemId;
  final String proofText;
  final List<String> proofImages;

  SubmitClaimEvent({
    required this.lostItemId,
    required this.proofText,
    required this.proofImages,
  });
}

class AcceptClaimEvent extends LostItemEvent {
  final String claimId;

  AcceptClaimEvent({
    required this.claimId,
  });
}

class RejectClaimEvent extends LostItemEvent {
  final String claimId;

  RejectClaimEvent({
    required this.claimId,
  });
}
