import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:finity/models/address_model.dart';
import 'package:finity/services/event_service.dart';
import 'package:finity/models/event_model.dart';
import 'package:flutter/material.dart';

part 'ad_event.dart';
part 'ad_state.dart';

class AdBloc extends Bloc<AdEvent, AdState> {
  final EventRepo eventRepo;
  AdBloc(this.eventRepo) : super(AdInitial()) {
    on<FetchNearByAdEvent>(_onFetchNearByAdEvent);
    on<AddAdEvent>(_onAddAdEvent);
    // Handle updating an event
    on<UpdateAdEvent>(_onUpdateAdEvent);

    // Handle deleting an event
    on<DeleteAdEvent>(_onDeleteAdEvent);
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

  FutureOr<void> _onAddAdEvent(AddAdEvent event, Emitter<AdState> emit) async {
    emit(AdLoading());
    try {
      // Call the repo to create a new event
      final EventModel newEvent = await eventRepo.createEvent(
        title: event.title,
        image: event.image,
        description: event.description,
        ownerId: event.ownerId,
        date: event.date,
        address: event.address,
        location: event.location,
      );
      emit(AdSuccess(events: [newEvent]));
    } catch (error) {
      emit(AdError(error: error.toString()));
    }
  }

  FutureOr<void> _onUpdateAdEvent(
      UpdateAdEvent event, Emitter<AdState> emit) async {
    emit(AdLoading());
    try {
      final EventModel updatedEvent = await eventRepo.updateEvent(
        eventId: event.eventId,
        title: event.title,
        image: event.image,
        description: event.description,
        date: event.date,
        address: event.address,
        location: event.location,
      );
      emit(AdSuccess(events: [updatedEvent]));
    } catch (error) {
      emit(AdError(error: error.toString()));
    }
  }

  FutureOr<void> _onDeleteAdEvent(
      DeleteAdEvent event, Emitter<AdState> emit) async {
    emit(AdLoading());
    try {
      await eventRepo.deleteEvent(event.eventId);
      emit(AdSuccess(events: [])); // Empty list or updated list after deletion
    } catch (error) {
      emit(AdError(error: error.toString()));
    }
  }
}
