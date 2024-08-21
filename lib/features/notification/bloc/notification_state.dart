part of 'notification_bloc.dart';

sealed class NotificationState {}

final class NotificationInitial extends NotificationState {}

final class NotificationLoading extends NotificationState {}

final class NotificationLoaded extends NotificationState {
  final List<NotificationModel> notifications;

  NotificationLoaded(this.notifications);
}

final class NotificationError extends NotificationState {
  final String message;

  NotificationError(this.message);
}
