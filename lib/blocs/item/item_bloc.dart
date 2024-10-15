import 'dart:async';

import 'package:bloc/bloc.dart';

import 'package:finity/models/item_model.dart';
import 'package:finity/models/user_model.dart';
import 'package:finity/services/item_service.dart';
import 'package:flutter/material.dart';

part 'item_event.dart';
part 'item_state.dart';

class ItemBloc extends Bloc<ItemEvent, ItemState> {
  final ItemRepo itemRepo;
  ItemBloc(this.itemRepo) : super(ItemInitial()) {
    on<AddItemEvent>(_onAddItemEvent);
    on<FetchNearbyItemsEvent>(_onFetchNearbyItemsEvent);
    on<SearchItemsEvent>(_onSearchItemsEvent);
    on<ItemBorrowEvent>(_onItemBorrowEvent);
    on<getItemByIdsEvent>(_onGetItemByIdsEvent);
  }

  FutureOr<void> _onAddItemEvent(
      AddItemEvent event, Emitter<ItemState> emit) async {
    emit(ItemLoading());
    try {
      await itemRepo.addItem(
        event.user,
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
      List<ItemModel>? data = await itemRepo.fetchNearbyItems(
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
      List<ItemModel> searchResults = await itemRepo.searchItems(event.query);
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
      itemRepo.requestToBorrowItem(event.itemId, event.borrowerId);
      emit(ItemBorrowSuccess());
    } catch (e) {
      emit(ItemBorrowError(e.toString()));
    }
  }

  FutureOr<void> _onGetItemByIdsEvent(
      getItemByIdsEvent event, Emitter<ItemState> emit) async {
    // Implement the logic to get items by their ids
    emit(ItemLoading());
    try {
      List<ItemModel> items = await itemRepo.getItemByIds(event.itemIds);
      emit(ItemByIdsFetched(items));
    } catch (e) {
      emit(ItemError(error: e.toString()));
    }
  }
}
