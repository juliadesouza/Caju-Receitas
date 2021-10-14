import 'package:projeto_app/model/recipe.dart';

abstract class MonitorAllRecipeEvent {}

class AskNewRecipeList extends MonitorAllRecipeEvent {
  AskNewRecipeList();
}

class UpdateRecipeList extends MonitorAllRecipeEvent {
  List<RecipeModel> recipeList;
  List<dynamic> idRecipeList;

  UpdateRecipeList({this.recipeList, this.idRecipeList});
}
