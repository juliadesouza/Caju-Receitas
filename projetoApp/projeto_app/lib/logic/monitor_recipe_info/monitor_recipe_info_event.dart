abstract class MonitorRecipeInfoEvent {}

class AskRecipe extends MonitorRecipeInfoEvent {
  String idRecipe;
  AskRecipe({this.idRecipe});
}
