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
