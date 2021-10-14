abstract class ManageRecipeState {}

class InsertState extends ManageRecipeState {}

class RecipeInserted extends ManageRecipeState {
  final String message;
  RecipeInserted({this.message});
}

class RecipeError extends ManageRecipeState {
  final String message;
  RecipeError({this.message});
}
