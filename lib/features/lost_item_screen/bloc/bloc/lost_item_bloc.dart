import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'lost_item_event.dart';
part 'lost_item_state.dart';

class LostItemBloc extends Bloc<LostItemEvent, LostItemState> {
  LostItemBloc() : super(LostItemInitial()) {
    on<LostItemEvent>((event, emit) {
      // TODO: implement event handler
    });
  }
}
