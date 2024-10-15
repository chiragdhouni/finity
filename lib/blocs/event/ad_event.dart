part of 'ad_bloc.dart';

@immutable
sealed class AdEvent {}

class FetchNearByAdEvent extends AdEvent {
  final double latitude;
  final double longitude;
  final double maxDistance;

  FetchNearByAdEvent({
    required this.latitude,
    required this.longitude,
    required this.maxDistance,
  });
}

class AddAdEvent extends AdEvent {
  final String title;
  final String description;
  final AddressModel address;
  final String ownerId;
  final DateTime date;
  final List<String> image;
  final Location location;

  AddAdEvent({
    required this.title,
    required this.description,
    required this.address,
    required this.ownerId,
    required this.date,
    required this.image,
    required this.location,
  });
}

// Event for updating an existing event
class UpdateAdEvent extends AdEvent {
  final String eventId;
  final String title;
  final List<String> image;
  final String description;
  final DateTime date;
  final AddressModel address;
  final Location location;

  UpdateAdEvent({
    required this.eventId,
    required this.title,
    required this.image,
    required this.description,
    required this.date,
    required this.address,
    required this.location,
  });
}

// Event for deleting an existing event
class DeleteAdEvent extends AdEvent {
  final String eventId;

  DeleteAdEvent({required this.eventId});
}
