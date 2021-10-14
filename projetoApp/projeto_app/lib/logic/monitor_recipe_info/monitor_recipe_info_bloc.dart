import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:projeto_app/data/firebase_server.dart';
import 'package:projeto_app/model/recipe.dart';
import 'monitor_recipe_info_event.dart';
import 'monitor_recipe_info_state.dart';

class MonitorRecipeInfoBloc
    extends Bloc<MonitorRecipeInfoEvent, MonitorRecipeInfoState> {
  RecipeModel recipeStream;
  String idRecipe;

  MonitorRecipeInfoBloc()
      : super(MonitorRecipeInfoState(recipe: new RecipeModel(), idRecipe: "")) {
    add(AskRecipe());
  }

  @override
  Stream<MonitorRecipeInfoState> mapEventToState(
      MonitorRecipeInfoEvent event) async* {
    try {
      if (event is AskRecipe) {
        var response = await FirebaseServer.helper.getRecipe(event.idRecipe);
        RecipeModel currentRecipe = response[0];
        String currentIdRecipe = response[1];
        yield MonitorRecipeInfoState(
            recipe: currentRecipe, idRecipe: currentIdRecipe);
      }
    } on Exception {
      print("Erro no monitor_recipe_info_bloc");
    }
  }
}
