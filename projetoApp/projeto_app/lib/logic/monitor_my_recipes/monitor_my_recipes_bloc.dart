import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:projeto_app/data/firebase_server.dart';
import 'package:projeto_app/model/recipe.dart';
import 'monitor_my_recipes_event.dart';
import 'monitor_my_recipes_state.dart';

class MonitorMyRecipesBloc
    extends Bloc<MonitorMyRecipesEvent, MonitorMyRecipesState> {
  StreamSubscription _localSubscription;
  List<RecipeModel> recipeList = [];
  List<String> idRecipeList = [];

  MonitorMyRecipesBloc()
      : super(MonitorMyRecipesState(recipeList: [], idRecipeList: [])) {
    add(AskMyRecipesList());
    _localSubscription =
        FirebaseServer.helper.streamMyRecipes.listen((response) {
      try {
        recipeList = response[0];
        idRecipeList = response[1];
        add(UpdateMyRecipesList(
            recipeList: recipeList, idRecipeList: idRecipeList));
      } catch (e) {
        print("Erro na Stream: $e");
      }
    });
  }

  @override
  Stream<MonitorMyRecipesState> mapEventToState(
      MonitorMyRecipesEvent event) async* {
    try {
      if (event is AskMyRecipesList) {
        var response = await FirebaseServer.helper.getMyRecipesList();
        List<RecipeModel> recipeList = response[0];
        List<String> idRecipeList = response[1];
        yield MonitorMyRecipesState(
            recipeList: recipeList, idRecipeList: idRecipeList);
      } else if (event is UpdateMyRecipesList) {
        yield MonitorMyRecipesState(
            recipeList: event.recipeList, idRecipeList: event.idRecipeList);
      }
    } on Exception {
      print("Erro no monitor_recipe_bloc");
    }
  }

  close() {
    _localSubscription.cancel();
    return super.close();
  }
}
