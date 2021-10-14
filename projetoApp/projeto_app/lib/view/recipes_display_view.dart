import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:projeto_app/logic/monitor_all_recipe/monitor_all_recipe_bloc.dart';
import 'package:projeto_app/logic/monitor_all_recipe/monitor_all_recipe_state.dart';
import 'package:projeto_app/logic/monitor_recipe_info/monitor_recipe_info_bloc.dart';
import 'package:projeto_app/logic/monitor_recipe_info/monitor_recipe_info_event.dart';
import 'package:projeto_app/model/recipe.dart';

import 'recipe_info_view.dart';

class RecipesDisplay extends StatelessWidget {
  @override
  Widget build(BuildContext contextBuild) {
    return BlocBuilder<MonitorAllRecipeBloc, MonitorAllRecipeState>(
        builder: (context, state) {
      return Scaffold(
        appBar: AppBar(
          title: Center(child: Text('RECEITAS')),
        ),
        body: SingleChildScrollView(
          child: Center(
              child: state.recipeList.length <= 0 ||
                      state.recipeList[0].photo == ""
                  ? Container()
                  : Column(
                      children: cardsRow(
                          state.recipeList, state.idRecipeList, contextBuild))),
        ),
      );
    });
  }

  List<Widget> cardsRow(List<RecipeModel> recipeList, List<String> idRecipeList,
      BuildContext context) {
    List<Widget> rows = [];
    int rowNumber = getRow(recipeList.length);
    int index = -1;

    for (int i = 0; i < rowNumber; i++) {
      rows.add(Row(
          children:
              retornaContainers(index, recipeList, idRecipeList, context)));
      index += 2;
    }
    return rows;
  }

  List<Widget> retornaContainers(int index, List<RecipeModel> recipeList,
      List<String> idRecipeList, BuildContext context) {
    List<Widget> columns = [];
    for (int i = 0; i < 2; i++) {
      index++;
      if (index < recipeList.length) {
        columns.add(buildRecipeCard(recipeList[index].photo,
            recipeList[index].title, idRecipeList[index], context));
      }
    }
    return columns;
  }

  int getRow(int length) {
    if (length % 2 == 0) {
      return (length / 2).floor();
    } else {
      return (length / 2).floor() + 1;
    }
  }

  Widget buildRecipeCard(
      String image, String text, String idRecipe, BuildContext context) {
    return Container(
      margin: EdgeInsets.all(10),
      child: Padding(
        padding: const EdgeInsets.only(left: 10),
        child: GestureDetector(
          onTap: () {
            BlocProvider.of<MonitorRecipeInfoBloc>(context)
                .add(AskRecipe(idRecipe: idRecipe));
            Navigator.push(
                context, MaterialPageRoute(builder: (context) => RecipeInfo()));
          },
          child: Card(
            color: Colors.grey[100],
            child: Column(children: <Widget>[
              Container(
                width: MediaQuery.of(context).size.width * 0.38,
                height: MediaQuery.of(context).size.width * 0.35,
                child: Image(image: NetworkImage(image), fit: BoxFit.fill),
              ),
              SizedBox(
                height: 50,
                child: Center(
                    child: Text(
                  text,
                  overflow: TextOverflow.clip,
                  maxLines: 1,
                  softWrap: false,
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                )),
              ),
            ]),
          ),
        ),
      ),
    );
  }
}
