import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:projeto_app/logic/manage_auth/auth_bloc.dart';
import 'package:projeto_app/logic/manage_recipe/manage_recipe_bloc.dart';
import 'package:projeto_app/logic/manage_shopping_list/manage_shopping_list_bloc.dart';
import 'package:projeto_app/logic/monitor_all_recipe/monitor_all_recipe_bloc.dart';
import 'package:projeto_app/logic/monitor_auth/monitor_auth_bloc.dart';
import 'package:projeto_app/logic/monitor_my_recipes/monitor_my_recipes_bloc.dart';
import 'package:projeto_app/logic/monitor_recipe_info/monitor_recipe_info_bloc.dart';
import 'package:projeto_app/logic/monitor_shopping_list/monitor_shopping_list_bloc.dart';
import 'package:projeto_app/view/profile_screen.dart';
import 'package:projeto_app/view/recipes_display_view.dart';
import 'package:projeto_app/view/new_recipe_view.dart';
import 'package:projeto_app/view/shopping_list_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'my_recipes_screen.dart';

class MyBottomNavigationBar extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return MyBottomNavigationBarState();
  }
}

class MyBottomNavigationBarState extends State<MyBottomNavigationBar> {
  int _currentPage = 0;
  List<Widget> _pages = [
    RecipesDisplay(),
    NewRecipe(),
    ShoppingListScreen(),
    MyRecipesScreen(),
    MyProfileScreen(),
  ];

  static const MaterialColor _color = MaterialColor(0xFF778375, <int, Color>{
    50: Color(0xFF778375),
    100: Color(0xFF778375),
    200: Color(0xFF778375),
    300: Color(0xFF778375),
    400: Color(0xFF778375),
    500: Color(0xFF778375),
    600: Color(0xFF778375),
    700: Color(0xFF778375),
    800: Color(0xFF778375),
    900: Color(0xFF778375),
  });

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => AuthBloc()),
        BlocProvider(create: (_) => MonitorAllRecipeBloc()),
        BlocProvider(create: (_) => ManageRecipeBloc()),
        BlocProvider(create: (_) => MonitorRecipeInfoBloc()),
        BlocProvider(create: (_) => MonitorAuthBloc()),
        BlocProvider(create: (_) => ManageShoppingListBloc()),
        BlocProvider(create: (_) => MonitorShoppingListBloc()),
        BlocProvider(create: (_) => MonitorMyRecipesBloc()),
      ],
      child: MaterialApp(
        theme: ThemeData(primarySwatch: _color),
        home: Scaffold(
            body: _pages[_currentPage],
            bottomNavigationBar: new Theme(
              data: Theme.of(context).copyWith(
                canvasColor: _color,
              ),
              child: BottomNavigationBar(
                items: [
                  BottomNavigationBarItem(
                      icon: Icon(Icons.restaurant_menu), label: 'Receitas'),
                  BottomNavigationBarItem(
                      icon: Icon(Icons.add_box), label: 'Nova Receita'),
                  BottomNavigationBarItem(
                      icon: Icon(Icons.shopping_cart),
                      label: 'Lista de Compras'),
                  BottomNavigationBarItem(
                      icon: Icon(Icons.all_inbox), label: 'Minhas Receitas'),
                  BottomNavigationBarItem(
                      icon: Icon(Icons.person), label: 'Meu Perfil'),
                ],
                currentIndex: _currentPage,
                onTap: (int index) {
                  setState(() {
                    _currentPage = index;
                  });
                },
              ),
            )),
      ),
    );
  }
}
