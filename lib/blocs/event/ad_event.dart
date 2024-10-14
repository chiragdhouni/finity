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
  final String address;
  final String ownerId;
  final String date;
  final String image;
  final Map<String, dynamic> location;

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
