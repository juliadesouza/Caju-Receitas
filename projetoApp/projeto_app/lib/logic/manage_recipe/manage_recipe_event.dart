import 'package:projeto_app/model/recipe.dart';

abstract class ManageRecipeEvent {}

class SubmitEvent extends ManageRecipeEvent {
  RecipeModel recipe;
  SubmitEvent({this.recipe});
}

class DeleteEvent extends ManageRecipeEvent {
  var recipeId;
  DeleteEvent({this.recipeId});
}
