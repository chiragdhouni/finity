import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:finity/features/home/repos/event_repo.dart';
import 'package:finity/models/event_model.dart';
import 'package:flutter/material.dart';

part 'ad_event.dart';
part 'ad_state.dart';

class AdBloc extends Bloc<AdEvent, AdState> {
  final EventRepo eventRepo;
  AdBloc(this.eventRepo) : super(AdInitial()) {
    on<FetchNearByAdEvent>(_onFetchNearByAdEvent);
  }

  FutureOr<void> _onFetchNearByAdEvent(
      FetchNearByAdEvent event, Emitter<AdState> emit) async {
    emit(AdLoading());
    try {
      // Call the repo to fetch the events
      final List<EventModel> events = await eventRepo.getEventsNearLocation(
        event.longitude,
        event.latitude,
        maxDistance: event.maxDistance,
      );
      emit(AdSuccess(events: events));
    } catch (error) {
      emit(AdError(error: error.toString()));
    }
  }
}
