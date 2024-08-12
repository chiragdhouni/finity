import 'dart:async';
import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:finity/features/lost_item_screen/repos/lost_item_repo.dart';
import 'package:finity/models/lost_item_model.dart';

part 'lost_item_event.dart';
part 'lost_item_state.dart';

class LostItemBloc extends Bloc<LostItemEvent, LostItemState> {
  final LostItemService lostItemService;
  LostItemBloc(this.lostItemService) : super(LostItemInitial()) {
    on<CreateLostItemEvent>(_onCreateLostItem);
    // on<searchLostItemsByLocation>(_onSearchLostItemsByLocation);
    on<getNearByLostItemsEvent>(_onGetNearByLostItems);
    on<searchLostItemEvent>(_onSearchLostItems);
  }

  FutureOr<void> _onCreateLostItem(
      CreateLostItemEvent event, Emitter<LostItemState> emit) async {
    emit(LostItemLoading());
    try {
      LostItem lostItem = await lostItemService.createLostItem(
          name: event.name,
          description: event.description,
          status: event.status,
          dateLost: event.dateLost,
          contactInfo: event.contactInfo,
          ownerId: event.ownerId,
          ownerName: event.ownerName,
          ownerEmail: event.ownerEmail,
          ownerAddress: event.ownerAddress,
          latitude: event.latitude,
          longitude: event.longitude);

      emit(lostItemCreated(lostItem));
    } catch (e) {
      log(e.toString());
      emit(LostItemError(e.toString()));
    }
  }

  // FutureOr<void> _onSearchLostItemsByLocation(
  //     searchLostItemsByLocation event, Emitter<LostItemState> emit) async {
  //   emit(LostItemLoading());
  //   try {
  //     List<LostItem> lostItems = await LostItemService()
  //         .searchLostItemsByLocation(
  //             latitude: event.latitude,
  //             longitude: event.longitude,
  //             maxDistance: event.maxDistance);

  //     emit(LostItemSearchSuccess(lostItems));
  //   } catch (e) {
  //     log(e.toString());
  //     emit(LostItemFailure(e.toString()));
  //   }
  // }

  FutureOr<void> _onSearchLostItems(
      searchLostItemEvent event, Emitter<LostItemState> emit) async {
    emit(LostItemLoading());
    try {
      List<LostItem> lostItems =
          await lostItemService.searchLostItems(event.searchQuery);
      emit(SearchLostItemSuccess(
          lostItems)); // Changed state name to SearchLostItemSuccess
    } catch (e) {
      log(e.toString());
      emit(LostItemError(e.toString()));
    }
  }

  FutureOr<void> _onGetNearByLostItems(
      getNearByLostItemsEvent event, Emitter<LostItemState> emit) async {
    emit(LostItemLoading());
    try {
      List<LostItem> lostItems = await lostItemService.getNearByLostItems(
          latitude: event.latitude,
          longitude: event.longitude,
          maxDistance: event.maxDistance);
      emit(NearByLostItemSuccess(
          lostItems)); // Changed state name to NearByLostItemSuccess
    } catch (e) {
      log(e.toString());
      emit(LostItemError(e.toString()));
    }
  }
}
