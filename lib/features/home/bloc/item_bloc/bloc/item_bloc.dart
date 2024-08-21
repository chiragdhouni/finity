import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:finity/models/item_model.dart';
import 'package:finity/features/home/repos/home_repo.dart';
import 'package:flutter/material.dart';

part 'item_event.dart';
part 'item_state.dart';

class ItemBloc extends Bloc<ItemEvent, ItemState> {
  final HomeRepo homeRepo;
  ItemBloc(this.homeRepo) : super(ItemInitial()) {
    on<AddItemEvent>(_onAddItemEvent);
    on<FetchNearbyItemsEvent>(_onFetchNearbyItemsEvent);
    on<SearchItemsEvent>(_onSearchItemsEvent);
    on<ItemBorrowEvent>(_onItemBorrowEvent);
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

  FutureOr<void> _onSearchItemsEvent(
      SearchItemsEvent event, Emitter<ItemState> emit) async {
    emit(ItemSearchLoading());
    try {
      List<ItemModel> searchResults = await homeRepo.searchItems(event.query);
      if (searchResults.isNotEmpty) {
        emit(ItemSearchSuccess(searchResults));
      } else {
        emit(ItemSearchError('No items found'));
      }
    } catch (e) {
      emit(ItemSearchError(e.toString()));
    }
  }

  FutureOr<void> _onItemBorrowEvent(
      ItemBorrowEvent event, Emitter<ItemState> emit) {
    // Implement the logic to borrow an item
    emit(ItemLoading());
    try {
      homeRepo.requestToBorrowItem(event.itemId, event.borrowerId);
      emit(ItemBorrowSuccess());
    } catch (e) {
      emit(ItemBorrowError(e.toString()));
    }
  }
}
