import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:finity/models/item_model.dart';
import 'package:finity/features/home/repos/home_repo.dart';
import 'package:meta/meta.dart';

part 'item_event.dart';
part 'item_state.dart';

class ItemBloc extends Bloc<ItemEvent, ItemState> {
  final HomeRepo homeRepo;
  ItemBloc(this.homeRepo) : super(ItemInitial()) {
    on<AddItemEvent>(_onAddItemEvent);
    on<FetchNearbyItemsEvent>(_onFetchNearbyItemsEvent);
  }

  FutureOr<void> _onAddItemEvent(
      AddItemEvent event, Emitter<ItemState> emit) async {
    emit(ItemLoading());
    try {
      await homeRepo.addItem(
        event.userId,
        event.itemName,
        event.description,
        event.itemCategory,
        event.dueDate,
      );
      emit(ItemSuccess());
    } catch (e) {
      emit(ItemError(error: e.toString()));
    }
  }

  FutureOr<void> _onFetchNearbyItemsEvent(
      FetchNearbyItemsEvent event, Emitter<ItemState> emit) async {
    // Implement the logic to fetch nearby items
    emit(ItemLoading());
    try {
      List<ItemModel>? data = await homeRepo.fetchNearbyItems(
          event.latitude, event.longitude, event.maxDistance);
      if (data != null && data.isNotEmpty) {
        emit(ItemFetched(data));
      } else {
        emit(ItemError(error: 'No items found'));
      }
    } catch (e) {
      emit(ItemError(error: e.toString()));
    }
  }
}
