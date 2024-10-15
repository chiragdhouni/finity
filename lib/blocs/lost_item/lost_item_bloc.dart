import 'dart:async';
import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:finity/models/address_model.dart';
import 'package:finity/models/user_model.dart';
import 'package:finity/services/claim_lost_item_service.dart';
import 'package:finity/services/lost_item_service.dart';
import 'package:finity/models/lost_item_model.dart';

part 'lost_item_event.dart';
part 'lost_item_state.dart';

class LostItemBloc extends Bloc<LostItemEvent, LostItemState> {
  final LostItemService lostItemService;
  final ClaimLostItemRepo claimLostItemRepo;
  LostItemBloc(this.lostItemService, this.claimLostItemRepo)
      : super(LostItemInitial()) {
    on<CreateLostItemEvent>(_onCreateLostItem);
    // on<searchLostItemsByLocation>(_onSearchLostItemsByLocation);
    on<getNearByLostItemsEvent>(_onGetNearByLostItems);
    on<searchLostItemEvent>(_onSearchLostItems);
    on<deleteLostItemEvent>(_onDeleteLostItem);
    on<getLostItemByIdEvent>(_onGetLostItemById);
    on<updateLostItemEvent>(_onUpdateLostItem);

    // claming lost item
    on<SubmitClaimEvent>(_onSumbitClaimEvent);
    on<AcceptClaimEvent>(_onAcceptClaimEvent);
    on<RejectClaimEvent>(_onRejectClaimEvent);
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
          address: event.address,
          user: event.user,
          latitude: event.latitude,
          longitude: event.longitude);

      emit(lostItemCreated(lostItem));
      add(getNearByLostItemsEvent(
          latitude: event.longitude,
          longitude: event.latitude,
          maxDistance: 10000.0));
    } catch (e) {
      // log(e.toString());
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

  FutureOr<void> _onSumbitClaimEvent(
      SubmitClaimEvent event, Emitter<LostItemState> emit) {
    emit(LostItemLoading());
    try {
      claimLostItemRepo.submitClaim(
          lostItemId: event.lostItemId,
          proofText: event.proofText,
          proofImages: event.proofImages);
      emit(SubmitClaimSuccess());
    } catch (e) {
      log(e.toString());
      emit(LostItemError(e.toString()));
    }
  }

  FutureOr<void> _onUpdateLostItem(
      updateLostItemEvent event, Emitter<LostItemState> emit) {
    emit(LostItemLoading());
    try {
      lostItemService.updateLostItem(
        event.lostItem.id,
        event.lostItem,
      );
      emit(LostItemUpdateSuccess(event.lostItem));
    } catch (e) {
      // log(e.toString());
      emit(LostItemError(e.toString()));
    }
  }

  FutureOr<void> _onDeleteLostItem(
      deleteLostItemEvent event, Emitter<LostItemState> emit) {
    emit(LostItemLoading());
    try {
      lostItemService.deleteLostItem(event.lostItemId);
      emit(LostItemDeleteSuccess());
    } catch (e) {
      // log(e.toString());
      emit(LostItemError(e.toString()));
    }
  }

  FutureOr<void> _onGetLostItemById(
      getLostItemByIdEvent event, Emitter<LostItemState> emit) async {
    emit(LostItemLoading());
    try {
      LostItem lostItem =
          await lostItemService.getLostItemById(event.lostItemId);
      emit(LostItemSuccess(lostItem));
    } catch (e) {
      // log(e.toString());
      emit(LostItemError(e.toString()));
    }
  }

  FutureOr<void> _onAcceptClaimEvent(
      AcceptClaimEvent event, Emitter<LostItemState> emit) {
    emit(LostItemLoading());
    try {
      claimLostItemRepo.acceptClaim(event.claimId);
      emit(AcceptClaimSuccess());
    } catch (e) {
      // log(e.toString());
      emit(LostItemError(e.toString()));
    }
  }

  FutureOr<void> _onRejectClaimEvent(
      RejectClaimEvent event, Emitter<LostItemState> emit) {
    emit(LostItemLoading());
    try {
      claimLostItemRepo.rejectClaim(event.claimId);
      emit(RejectClaimSuccess());
    } catch (e) {
      // log(e.toString());
      emit(LostItemError(e.toString()));
    }
  }
}
