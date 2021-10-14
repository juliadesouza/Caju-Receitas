import 'package:projeto_app/model/item.dart';

abstract class MonitorShoppingListEvent {}

class AskNewList extends MonitorShoppingListEvent {}

class UpdateShoppingList extends MonitorShoppingListEvent {
  List<ItemModel> itemList;
  List<dynamic> idList;
  UpdateShoppingList({this.itemList, this.idList});
}
