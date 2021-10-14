import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:projeto_app/logic/manage_recipe/manage_recipe_bloc.dart';
import 'package:projeto_app/logic/manage_recipe/manage_recipe_event.dart';
import 'package:projeto_app/logic/monitor_my_recipes/monitor_my_recipes_bloc.dart';
import 'package:projeto_app/logic/monitor_my_recipes/monitor_my_recipes_state.dart';
import 'package:projeto_app/logic/monitor_recipe_info/monitor_recipe_info_bloc.dart';
import 'package:projeto_app/logic/monitor_recipe_info/monitor_recipe_info_event.dart';
import 'package:projeto_app/model/recipe.dart';
import 'package:projeto_app/view/recipe_info_view.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:getwidget/getwidget.dart';

class MyRecipesScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return MyRecipesScreenState();
  }
}

class MyRecipesScreenState extends State<MyRecipesScreen> {
  static Map<int, String> mapCategories = {
    1: 'Acompanhamentos',
    2: 'Bebidas',
    3: 'Carnes',
    4: 'Doces e Sobremesas',
    5: 'Lanches',
    6: 'Massas',
    7: 'Molhos',
    8: 'Pães',
    9: 'Saladas',
    10: 'Sopas',
  };

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MonitorMyRecipesBloc, MonitorMyRecipesState>(
        builder: (context, state) {
      return Scaffold(
        appBar: AppBar(
          title: Center(child: Text('MINHAS RECEITAS')),
        ),
        body: Center(
            child: state.recipeList.isEmpty
                ? Container()
                : getMyRecipes(state.recipeList, state.idRecipeList)),
      );
    });
  }

  Widget getMyRecipes(List<RecipeModel> recipeList, List<String> idList) {
    return ListView.builder(
        itemCount: recipeList.length,
        itemBuilder: (context, location) {
          return Card(
              child: ListTile(
                  title: Text(recipeList[location].title),
                  subtitle: Text(mapCategories[recipeList[location].category]),
                  leading: GestureDetector(
                      child: GFAvatar(
                          backgroundImage:
                              NetworkImage(recipeList[location].photo),
                          shape: GFAvatarShape.standard),
                      onTap: () {
                        BlocProvider.of<MonitorRecipeInfoBloc>(context)
                            .add(AskRecipe(idRecipe: idList[location]));
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => RecipeInfo()));
                      }),
                  trailing: IconButton(
                    icon: Icon(Icons.delete),
                    onPressed: () {
                      BlocProvider.of<ManageRecipeBloc>(context)
                          .add(DeleteEvent(recipeId: idList[location]));
                    },
                  )));
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
      //   width: MediaQuery.of(context).size.width/3,
      //   height: MediaQuery.of(context).size.height * 0.35,
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
                child: Align(
                  alignment: Alignment.topRight,
                  child: Container(
                    padding: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                        color: Color(0xFF778375),
                        borderRadius: BorderRadius.circular(100)),
                    child: Icon(
                      Icons.delete,
                      color: Colors.white,
                    ),
                  ),
                ),
                width: MediaQuery.of(context).size.width * 0.40,
                height: MediaQuery.of(context).size.width * 0.35,
                decoration: BoxDecoration(
                  image: DecorationImage(
                      image: NetworkImage(image), fit: BoxFit.fill),
                ),
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
