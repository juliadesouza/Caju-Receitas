import 'package:projeto_app/model/item.dart';

abstract class ManageShoppingListState {}

class UpdateState extends ManageShoppingListState {
  var itemId;
  ItemModel previousItem;
  UpdateState({this.itemId, this.previousItem});
}

class InsertState extends ManageShoppingListState {}

class ItemInserted extends ManageShoppingListState {
  final String message;
  ItemInserted({this.message});
}
