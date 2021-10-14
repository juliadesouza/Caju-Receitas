import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:projeto_app/logic/manage_shopping_list/manage_shopping_list_state.dart';
import 'package:projeto_app/logic/manage_shopping_list/manage_shopping_list_event.dart';
import 'package:projeto_app/logic/manage_shopping_list/manage_shopping_list_bloc.dart';
import 'package:projeto_app/logic/monitor_recipe_info/monitor_recipe_info_bloc.dart';
import 'package:projeto_app/logic/monitor_recipe_info/monitor_recipe_info_state.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:projeto_app/model/item.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class RecipeInfo extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return RecipeInfoState();
  }
}

class RecipeInfoState extends State<RecipeInfo> {
  static Map<int, String> mapLevels = {
    1: 'Fácil',
    2: 'Médio',
    3: 'Difícil',
  };

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
    return BlocBuilder<MonitorRecipeInfoBloc, MonitorRecipeInfoState>(
        builder: (context, state) {
      return Scaffold(
          appBar: AppBar(),
          body: SingleChildScrollView(
            child: Center(
              child: state.idRecipe == ""
                  ? CircularProgressIndicator()
                  : Column(children: [
                      buildRecipeImage(state.recipe.photo, context),
                      buildRecipeTitle(state.recipe.title, state.idRecipe),
                      buildRecipeCategory(state.recipe.category),
                      buildRecipeEspecifications(state.recipe.level,
                          state.recipe.cookingTime, state.recipe.portions),
                      buildRecipeRestrictions(state.recipe.dietary),
                      buildTitleWithDivider('Ingredientes'),
                      buildIngredientsListView(state.recipe.ingredients),
                      buildTitleWithDivider('Modo de Preparo'),
                      buildStepsListView(state.recipe.steps),
                      buildTitleWithDivider('Vídeo no Youtube'),
                      buildVideoYoutube(state.recipe.video),
                    ]),
            ),
          ));
    });
  }

  Widget buildRecipeImage(String imgPath, BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height / 3,
      margin: EdgeInsets.only(bottom: 20),
      decoration: BoxDecoration(
        color: Color(0xFF778375),
        image: DecorationImage(
          image: new NetworkImage(imgPath),
          fit: BoxFit.fill,
        ),
      ),
    );
  }

  Widget buildRecipeTitle(String title, String id) {
    return Container(
      margin: EdgeInsets.only(left: 20, right: 20, top: 15),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              title,
              style: TextStyle(
                fontSize: 30,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildRecipeCategory(int id) {
    return Container(
      margin: EdgeInsets.only(top: 10, left: 20, bottom: 20),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Container(
          margin: EdgeInsets.only(right: 15),
          padding: EdgeInsets.all(10),
          decoration: BoxDecoration(
            border: Border.all(color: Color(0xFF778375), width: 2),
          ),
          child: Text(
            '${mapCategories[id]}',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Color(0xFF778375),
            ),
          ),
        ),
      ),
    );
  }

  Widget buildRecipeEspecifications(int level, int cookingTime, int portions) {
    return Container(
      margin: EdgeInsets.only(left: 20, right: 20, top: 10, bottom: 20),
      child: Align(
          alignment: Alignment.centerLeft,
          child: Row(
            children: [
              Container(
                margin: EdgeInsets.only(right: 15),
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Color(0xFFb9bfb8),
                ),
                child: Text(
                  '$cookingTime min',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF4f574d),
                  ),
                ),
              ),
              Container(
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Color(0xFFb9bfb8),
                ),
                child: Text(
                  mapLevels[level],
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF4f574d),
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.only(left: 15),
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Color(0xFFb9bfb8),
                ),
                child: Text(
                  '$portions porções',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF4f574d),
                  ),
                ),
              ),
            ],
          )),
    );
  }

  Widget buildRecipeRestrictions(List<int> dietaryList) {
    return Container(
      margin: EdgeInsets.only(top: 10, left: 20, bottom: 20),
      child: Align(
          alignment: Alignment.centerLeft,
          child: Row(children: _getDietary(dietaryList))),
    );
  }

  // 0 -> sem lactose
  // 1 -> sem gluten
  // 2 -> vegano
  // 3 -> vegetariano
  // 4 --> diet

  List<Widget> _getDietary(List<int> list) {
    List<Widget> options = [];
    for (int option in list) {
      switch (option) {
        case 0:
          options.add(_getDairyFree());
          break;
        case 1:
          options.add(_getGlutenFree());
          break;
        case 2:
          options.add(_getVegan());
          break;
        case 3:
          options.add(_getVegetarian());
          break;
        case 4:
          options.add(_getDiet());
          break;
        default:
          break;
      }
    }

    return options;
  }

  Widget _getDairyFree() {
    return Container(
      margin: EdgeInsets.only(left: 10, right: 10),
      child: Tooltip(
        message: "hello",
        child: Transform.scale(
          scale: 1.5,
          child: ImageIcon(
            AssetImage(
              "assets/images/dairy.png",
            ),
            color: Color(0xFF778375),
          ),
        ),
      ),
    );
  }

  Widget _getGlutenFree() {
    return Container(
      margin: EdgeInsets.only(left: 10, right: 10),
      child: Transform.scale(
        scale: 1.5,
        child: ImageIcon(
          AssetImage("assets/images/gluten.png"),
          color: Color(0xFF778375),
        ),
      ),
    );
  }

  Widget _getVegan() {
    return Container(
      margin: EdgeInsets.only(left: 10, right: 10),
      child: Transform.scale(
        scale: 1.5,
        child: ImageIcon(
          AssetImage("assets/images/vegan.png"),
          color: Color(0xFF778375),
        ),
      ),
    );
  }

  Widget _getVegetarian() {
    return Container(
      margin: EdgeInsets.only(left: 10, right: 10),
      child: Transform.scale(
        scale: 1.5,
        child: ImageIcon(
          AssetImage("assets/images/meat.png"),
          color: Color(0xFF778375),
        ),
      ),
    );
  }

  Widget _getDiet() {
    return Container(
      margin: EdgeInsets.only(left: 10, right: 10),
      child: Transform.scale(
        scale: 1.5,
        child: ImageIcon(
          AssetImage("assets/images/sugar.png"),
          color: Color(0xFF778375),
        ),
      ),
    );
  }

  Widget buildIngredientsListView(List<String> ingredients) {
    return BlocBuilder<ManageShoppingListBloc, ManageShoppingListState>(
        builder: (context, state) {
      ItemModel item;
      if (state is UpdateState) {
        item = state.previousItem;
      } else {
        item = new ItemModel();
      }
      return ListView.builder(
          shrinkWrap: true,
          padding: EdgeInsets.all(10),
          scrollDirection: Axis.vertical,
          itemCount: ingredients.length,
          itemBuilder: (context, position) {
            return ListTile(
              title: Text('${ingredients[position]}'),
              leading: Icon(Icons.api_sharp),
              trailing: IconButton(
                icon: Icon(Icons.add_circle_outlined),
                onPressed: () {
                  item.title = ingredients[position];
                  BlocProvider.of<ManageShoppingListBloc>(context)
                      .add(SubmitEvent(item: item));
                },
              ),
            );
          });
    });
  }

  Widget buildStepsListView(List<String> steps) {
    return ListView.builder(
        shrinkWrap: true,
        padding: EdgeInsets.all(10),
        scrollDirection: Axis.vertical,
        itemCount: steps.length,
        itemBuilder: (context, position) {
          return ListTile(
            title: Text('${steps[position]}'),
            leading: Text('${position + 1}',
                style: TextStyle(
                    fontSize: 20,
                    color: Color(0xFF778375),
                    fontWeight: FontWeight.bold)),
          );
        });
  }

  Widget buildVideoYoutube(String url) {
    if (url.length > 0) {
      int i = url.indexOf("=");
      String id = url.substring(i + 1).trim();
      YoutubePlayerController _controller = YoutubePlayerController(
          initialVideoId: id, // id youtube video
          flags: YoutubePlayerFlags(
            autoPlay: false,
            mute: false,
          ));
      return Container(
        color: Colors.white,
        child: Column(
          children: [
            YoutubePlayer(
              controller: _controller,
              showVideoProgressIndicator: true,
              progressIndicatorColor: Colors.blueAccent,
            ),
          ],
        ),
      );
    } else {
      return Container(
        margin: EdgeInsets.all(15),
        child: Text("Nenhum vídeo cadastrado", style: TextStyle(fontSize: 20)),
      );
    }
  }

  Widget buildTitleWithDivider(String text) {
    return Container(
      child: Column(
        children: [
          Divider(
            color: Color(0xFF778375),
            thickness: 2,
          ),
          Text(text,
              style: TextStyle(
                  fontSize: 20,
                  color: Color(0xFF778375),
                  fontWeight: FontWeight.bold)),
          Divider(
            color: Color(0xFF778375),
            thickness: 2,
          ),
        ],
      ),
    );
  }
}
