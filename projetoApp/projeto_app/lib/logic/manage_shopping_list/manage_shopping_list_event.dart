import 'package:projeto_app/model/item.dart';

abstract class ManageShoppingListEvent {}

class DeleteEvent extends ManageShoppingListEvent {
  var itemId;
  DeleteEvent({this.itemId});
}

class UpdateRequest extends ManageShoppingListEvent {
  var itemId;
  ItemModel previousItem;

  UpdateRequest({this.itemId, this.previousItem});
}

class UpdateCancel extends ManageShoppingListEvent {}

class SubmitEvent extends ManageShoppingListEvent {
  ItemModel item;
  SubmitEvent({this.item});
}
