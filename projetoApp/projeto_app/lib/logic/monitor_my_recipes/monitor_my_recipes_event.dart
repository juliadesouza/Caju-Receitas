import 'package:projeto_app/model/recipe.dart';

abstract class MonitorMyRecipesEvent {}

class AskMyRecipesList extends MonitorMyRecipesEvent {
  AskMyRecipesList();
}

class UpdateMyRecipesList extends MonitorMyRecipesEvent {
  List<RecipeModel> recipeList;
  List<dynamic> idRecipeList;

  UpdateMyRecipesList({this.recipeList, this.idRecipeList});
}
