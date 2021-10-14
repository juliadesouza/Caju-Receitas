import 'package:bloc/bloc.dart';
import 'package:projeto_app/data/firebase_server.dart';

import 'manage_shopping_list_event.dart';
import 'manage_shopping_list_state.dart';

class ManageShoppingListBloc
    extends Bloc<ManageShoppingListEvent, ManageShoppingListState> {
  ManageShoppingListBloc() : super(InsertState());

  @override
  Stream<ManageShoppingListState> mapEventToState(
      ManageShoppingListEvent event) async* {
    if (event is DeleteEvent) {
      FirebaseServer.helper.deleteItem(event.itemId);
    } else if (event is UpdateRequest) {
      FirebaseServer.helper.updateItem(event.itemId, event.previousItem);
    } else if (event is UpdateCancel) {
      yield InsertState();
    } else if (event is SubmitEvent) {
      FirebaseServer.helper.insertItem(event.item);
    }
  }
}
