import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:projeto_app/data/firebase_server.dart';
import 'package:projeto_app/model/recipe.dart';
import 'monitor_all_recipe_event.dart';
import 'monitor_all_recipe_state.dart';

class MonitorAllRecipeBloc
    extends Bloc<MonitorAllRecipeEvent, MonitorAllRecipeState> {
  StreamSubscription _localSubscription;
  List<RecipeModel> recipeList = [];
  List<String> idRecipeList = [];

  MonitorAllRecipeBloc()
      : super(MonitorAllRecipeState(recipeList: [], idRecipeList: [])) {
    add(AskNewRecipeList());
    _localSubscription =
        FirebaseServer.helper.streamRecipesDisplay.listen((response) {
      try {
        recipeList = response[0];
        idRecipeList = response[1];
        add(UpdateRecipeList(
            recipeList: recipeList, idRecipeList: idRecipeList));
      } catch (e) {
        print("Erro na Stream: $e");
      }
    });
  }

  @override
  Stream<MonitorAllRecipeState> mapEventToState(
      MonitorAllRecipeEvent event) async* {
    try {
      if (event is AskNewRecipeList) {
        var response = await FirebaseServer.helper.getRecipeList();
        List<RecipeModel> recipeList = response[0];
        List<String> idRecipeList = response[1];
        yield MonitorAllRecipeState(
            recipeList: recipeList, idRecipeList: idRecipeList);
      } else if (event is UpdateRecipeList) {
        yield MonitorAllRecipeState(
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
