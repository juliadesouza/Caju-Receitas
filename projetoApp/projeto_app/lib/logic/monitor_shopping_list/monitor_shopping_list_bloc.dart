import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:projeto_app/data/firebase_server.dart';
import 'package:projeto_app/model/item.dart';
import 'monitor_shopping_list_event.dart';
import 'monitor_shopping_list_state.dart';

class MonitorShoppingListBloc
    extends Bloc<MonitorShoppingListEvent, MonitorShoppingListState> {
  StreamSubscription _firebaseSubscription;

  List<ItemModel> newItemList;
  List<String> newIdList;

  MonitorShoppingListBloc()
      : super(MonitorShoppingListState(itemList: [], idList: [])) {
    add(AskNewList());
    _firebaseSubscription =
        FirebaseServer.helper.streamItems.listen((response) {
      try {
        newItemList = response[0];
        newIdList = response[1];
        add(UpdateShoppingList(
          itemList: newItemList,
          idList: newIdList,
        ));
      } catch (e) {
        print("erro aqui : $e");
      }
    });
  }

  @override
  Stream<MonitorShoppingListState> mapEventToState(
      MonitorShoppingListEvent event) async* {
    if (event is AskNewList) {
      var firebaseResponse = await FirebaseServer.helper.getShoppingList();
      newItemList = firebaseResponse[0];
      newIdList = firebaseResponse[1];
      yield MonitorShoppingListState(itemList: newItemList, idList: newIdList);
    } else if (event is UpdateShoppingList) {
      yield MonitorShoppingListState(
          itemList: event.itemList, idList: event.idList);
    }
  }

  close() {
    _firebaseSubscription.cancel();
    return super.close();
  }
}
