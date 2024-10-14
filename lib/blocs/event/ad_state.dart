part of 'ad_bloc.dart';

@immutable
sealed class AdState {}

final class AdInitial extends AdState {}

class AdLoading extends AdState {}

class AdSuccess extends AdState {
  final List<dynamic> events;

  AdSuccess({required this.events});
}

class AdError extends AdState {
  final String error;

  AdError({required this.error});
}

class AdAdded extends AdState {}

class AdAddError extends AdState {
  final String error;

  AdAddError({required this.error});
}
