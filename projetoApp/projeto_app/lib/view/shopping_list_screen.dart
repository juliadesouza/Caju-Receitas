import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:projeto_app/logic/manage_shopping_list/manage_shopping_list_bloc.dart';
import 'package:projeto_app/logic/manage_shopping_list/manage_shopping_list_event.dart';
import 'package:projeto_app/logic/monitor_shopping_list/monitor_shopping_list_bloc.dart';
import 'package:projeto_app/logic/monitor_shopping_list/monitor_shopping_list_state.dart';

class ShoppingListScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return ShoppingListState();
  }
}

class ShoppingListState extends State<ShoppingListScreen> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MonitorShoppingListBloc, MonitorShoppingListState>(
        builder: (context, state) {
      return Scaffold(
        appBar: AppBar(
          title: Center(child: Text('LISTA DE COMPRAS')),
        ),
        body: Center(
          child: generateBasicListView(state.itemList, state.idList),
        ),
      );
    });
  }

  Widget generateBasicListView(itemList, idList) {
    return ListView.builder(
        itemCount: itemList.length,
        itemBuilder: (context, position) {
          return Card(
            color: itemList[position].clicked == true
                ? Color(0xffC1E1C1)
                : Color(0xffE0E0E0),
            elevation: 5,
            child: ListTile(
              title: Text(
                itemList[position].title,
                style: TextStyle(
                    decoration: itemList[position].clicked == true
                        ? TextDecoration.lineThrough
                        : TextDecoration.none),
              ),
              leading: Checkbox(
                value: itemList[position].clicked,
                onChanged: (value) {
                  itemList[position].clicked = !itemList[position].clicked;
                  BlocProvider.of<ManageShoppingListBloc>(context).add(
                      UpdateRequest(
                          itemId: idList[position],
                          previousItem: itemList[position]));
                },
              ),
              trailing: GestureDetector(
                child: Icon(Icons.delete),
                onTap: () {
                  BlocProvider.of<ManageShoppingListBloc>(context)
                      .add(DeleteEvent(itemId: idList[position]));
                },
              ),
            ),
          );
        });
    /* return ListView(
      scrollDirection: Axis.vertical,
      children: 
        _shoppingList.keys.map((String key){
          return Card(
            color: _shoppingList[key] ? Color(0xffC1E1C1): Color(0xffE0E0E0),
            elevation: 5,
            child: ListTile(
              title: Text(
                key,
                style: TextStyle(
                  decoration: _shoppingList[key] ? TextDecoration.lineThrough:TextDecoration.none
                ),
              ),          
              leading: Checkbox(
                value: _shoppingList[key],
                onChanged: (value){
                  setState(() {
                    _shoppingList[key] = !_shoppingList[key];
                  });
                },
              ),
              trailing: GestureDetector(
                child: Icon(Icons.delete),
                onTap: () {
                  setState(() {
                    _shoppingList.remove(key);
                  });
                },
              ),
            ),
          );
        }).toList(),
    );*/
  }
}
