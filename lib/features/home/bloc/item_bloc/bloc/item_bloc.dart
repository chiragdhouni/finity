import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:finity/features/home/repos/home_repo.dart';
import 'package:meta/meta.dart';

part 'item_event.dart';
part 'item_state.dart';

class ItemBloc extends Bloc<ItemEvent, ItemState> {
  final HomeRepo homeRepo;
  ItemBloc(this.homeRepo) : super(ItemInitial()) {
    on<AddItemEvent>(_onAddItemEvent);
    on<RequestToBorrowItemEvent>(_onRequestToBorrowItemEvent);
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
}
