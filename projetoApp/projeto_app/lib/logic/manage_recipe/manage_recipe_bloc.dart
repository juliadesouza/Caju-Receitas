import 'package:projeto_app/data/firebase_server.dart';
import 'package:projeto_app/logic/manage_recipe/manage_recipe_event.dart';
import 'package:projeto_app/logic/manage_recipe/manage_recipe_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ManageRecipeBloc extends Bloc<ManageRecipeEvent, ManageRecipeState> {
  ManageRecipeBloc() : super(InsertState());

  @override
  Stream<ManageRecipeState> mapEventToState(ManageRecipeEvent event) async* {
    try {
      if (event is DeleteEvent) {
        FirebaseServer.helper.deleteRecipe(event.recipeId);
      } else if (event is SubmitEvent) {
        if (state is InsertState) {
          FirebaseServer.helper.insertRecipe(event.recipe);
        }
      }
    } catch (e) {
      yield RecipeError(message: "Não foi possível realizar a inserção");
    }
  }
}
