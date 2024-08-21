import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:finity/features/notification/repos/notification_service.dart';
import 'package:finity/models/notification_model.dart';
import 'package:flutter/material.dart';

part 'notification_event.dart';
part 'notification_state.dart';

class NotificationBloc extends Bloc<NotificationEvent, NotificationState> {
  final BuildContext context;
  final NotificationService notificationService;
  NotificationBloc(this.context, this.notificationService)
      : super(NotificationInitial()) {
    on<GetNotificationsEvent>(_getNotificationEvent);
  }

  FutureOr<void> _getNotificationEvent(
      GetNotificationsEvent event, Emitter<NotificationState> emit) async {
    emit(NotificationLoading());
    try {
      List<NotificationModel> notifications =
          await notificationService.getNotificationsForUserIds(event.notificationIds);
      emit(NotificationLoaded(notifications));
    } catch (e) {
      emit(NotificationError('Error fetching notifications'));
    }
  }
}
