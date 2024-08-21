part of 'notification_bloc.dart';

sealed class NotificationEvent {}

class GetNotificationsEvent extends NotificationEvent {
  final List<String> notificationIds;

  GetNotificationsEvent(this.notificationIds);
}
