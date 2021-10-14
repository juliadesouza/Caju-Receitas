import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:projeto_app/logic/manage_recipe/manage_recipe_bloc.dart';
import 'package:projeto_app/logic/manage_recipe/manage_recipe_event.dart';
import 'package:projeto_app/logic/manage_recipe/manage_recipe_state.dart';
import 'package:projeto_app/model/recipe.dart';

class NewRecipe extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return NewRecipeState();
  }
}

class Dietary {
  int id;
  String title;

  Dietary(this.id, this.title);
}

class NewRecipeState extends State<NewRecipe> {
  final GlobalKey<FormState> _formKey = new GlobalKey<FormState>();
  final RecipeModel newRecipe = new RecipeModel();

  static Dietary lactfree = new Dietary(0, 'Sem Lactose');
  static Dietary glutenfree = new Dietary(1, 'Sem Glúten');
  static Dietary vegan = new Dietary(2, 'Vegano');
  static Dietary vegetarian = new Dietary(3, 'Vegetariano');
  static Dietary diet = new Dietary(4, 'Diet');

  File _image;

  final List<String> _ingredients = <String>[];
  final List<String> _steps = <String>[];

  TextEditingController _ingredientController = TextEditingController();
  TextEditingController _stepController = TextEditingController();

  int _selectedItem = 0;
  int _selectedLevel = 1;

  Map<int, String> _categoryList = {
    0: 'Nenhuma',
    1: 'Acompanhamentos',
    2: 'Bebidas',
    3: 'Carnes',
    4: 'Doces e Sobremesas',
    5: 'Lanches',
    6: 'Massas',
    7: 'Molhos',
    8: 'Pães',
    9: 'Saladas',
    10: 'Sopas'
  };

  Map<Dietary, bool> _dietaryList = {
    lactfree: false,
    glutenfree: false,
    vegan: false,
    vegetarian: false,
    diet: false,
  };

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ManageRecipeBloc, ManageRecipeState>(
        builder: (context, state) {
      return Scaffold(
        appBar: AppBar(
          title: Center(child: Text('NOVA RECEITA')),
        ),
        body: SingleChildScrollView(
          child: Container(
            margin: EdgeInsets.only(top: 20),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  buildPhoto(),
                  buildTitleField(),
                  buildTimeField(),
                  buildPortionsField(),
                  buildDropDownButton(),
                  buildLevelField(),
                  buildDietaryOptions(),
                  buildIngredientsField(),
                  buildHowToDoField(),
                  buildLinkField(),
                  buildSubmitButton()
                ],
              ),
            ),
          ),
        ),
      );
    });
  }

  Widget buildPhoto() {
    return Container(
      child: SizedBox(
        height: 180,
        child: Center(
          child: GestureDetector(
            onTap: () {
              _showPicker(context);
            },
            child: CircleAvatar(
              radius: 100,
              child: _image != null
                  ? ClipRRect(
                      borderRadius: BorderRadius.circular(40),
                      child: Image.file(
                        _image,
                        width: 600,
                        height: 600,
                        fit: BoxFit.fill,
                      ),
                    )
                  : Container(
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.circular(50),
                      ),
                      width: 600,
                      height: 600,
                      child: Icon(
                        Icons.camera_alt,
                        color: Colors.grey[800],
                        size: 40,
                      ),
                    ),
            ),
          ),
        ),
      ),
    );
  }

  Widget buildIngredientsField() {
    return Container(
      margin: EdgeInsets.only(left: 20, right: 20, bottom: 10),
      child: Column(
        children: [
          TextFormField(
            autocorrect: true,
            cursorColor: Colors.grey,
            controller: _ingredientController,
            decoration: InputDecoration(
              labelText: 'Adicionar Ingrediente',
              labelStyle: TextStyle(fontSize: 20, color: Colors.grey),
              filled: true,
              fillColor: Colors.transparent,
              suffixIcon: IconButton(
                onPressed: () => addIngredient(),
                icon: Icon(Icons.add_box_rounded),
              ),
              border: UnderlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(10)),
                borderSide: BorderSide(color: Color(0xFF778375)),
              ),
              enabledBorder: UnderlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(10)),
                borderSide: BorderSide(color: Color(0xFF778375)),
              ),
              focusedBorder: UnderlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(10)),
                borderSide: BorderSide(color: Color(0xFF778375), width: 4),
              ),
            ),
            validator: (String value) {
              if (value.isEmpty && _ingredients.length < 1) {
                return "Insira pelo menos 1 ingrediente.";
              }
              return null;
            },
            onSaved: (value) {
              newRecipe.ingredients = _ingredients;
            },
          ),
          Visibility(
            visible: _ingredients.length > 0 ? true : false,
            child: Container(
                margin: EdgeInsets.only(top: 20, left: 10, right: 10),
                child: DataTable(
                  headingTextStyle:
                      TextStyle(fontSize: 20, color: Colors.black),
                  headingRowColor: MaterialStateColor.resolveWith(
                      (states) => Color(0xFFC2D5BE)),
                  dataTextStyle: TextStyle(fontSize: 18, color: Colors.black),
                  decoration:
                      BoxDecoration(border: Border.all(color: Colors.grey)),
                  columns: [
                    DataColumn(label: Text('Ingredientes')),
                    DataColumn(label: Text('')),
                  ],
                  rows: _ingredients
                      .map((e) => DataRow(cells: [
                            DataCell(Text('$e')),
                            DataCell(
                              IconButton(
                                icon: Icon(Icons.delete),
                                onPressed: () => removeIngredient(e),
                              ),
                            ),
                          ]))
                      .toList(),
                )),
          ),
        ],
      ),
    );
  }

  Widget buildHowToDoField() {
    return Container(
      margin: EdgeInsets.only(left: 20, right: 20, bottom: 10),
      child: Column(
        children: [
          TextFormField(
            keyboardType: TextInputType.text,
            autocorrect: true,
            cursorColor: Colors.grey,
            controller: _stepController,
            decoration: InputDecoration(
              labelText: 'Adicionar Etapa',
              labelStyle: TextStyle(fontSize: 20, color: Colors.grey),
              filled: true,
              fillColor: Colors.transparent,
              suffixIcon: IconButton(
                onPressed: () => addStep(),
                icon: Icon(Icons.add_box_rounded),
              ),
              border: UnderlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(10)),
                borderSide: BorderSide(color: Color(0xFF778375)),
              ),
              enabledBorder: UnderlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(10)),
                borderSide: BorderSide(color: Color(0xFF778375)),
              ),
              focusedBorder: UnderlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(10)),
                borderSide: BorderSide(color: Color(0xFF778375), width: 4),
              ),
            ),
            validator: (String value) {
              if (value.isEmpty && _steps.length < 1) {
                return "Insira pelo menos 1 passo no modo de preparo.";
              }
              return null;
            },
            onSaved: (value) {
              newRecipe.steps = _steps;
            },
          ),
          Visibility(
            visible: _steps.length > 0 ? true : false,
            child: Container(
                //margin: EdgeInsets.only(top: 20, left: 10, right: 10),
                child: DataTable(
              headingTextStyle: TextStyle(fontSize: 20, color: Colors.black),
              headingRowColor:
                  MaterialStateColor.resolveWith((states) => Color(0xFFC2D5BE)),
              dataTextStyle: TextStyle(fontSize: 18, color: Colors.black),
              decoration: BoxDecoration(border: Border.all(color: Colors.grey)),
              columns: [
                DataColumn(label: Text('Modo de Preparo')),
                DataColumn(label: Text('')),
              ],
              rows: _steps
                  .map((e) => DataRow(cells: [
                        DataCell(Text('${_steps.indexOf(e) + 1}. $e')),
                        DataCell(
                          IconButton(
                            icon: Icon(Icons.delete),
                            onPressed: () => removeStep(e),
                          ),
                        ),
                      ]))
                  .toList(),
            )),
          ),
        ],
      ),
    );
  }

  Widget buildTitleField() {
    return Container(
      margin: EdgeInsets.only(left: 20, right: 20, bottom: 10),
      child: TextFormField(
        keyboardType: TextInputType.text,
        autocorrect: true,
        cursorColor: Colors.grey,
        decoration: InputDecoration(
          labelText: 'Título da Receita',
          labelStyle: TextStyle(fontSize: 20, color: Colors.grey),
          prefixIcon: Icon(Icons.title),
          filled: true,
          fillColor: Colors.transparent,
          border: UnderlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(10)),
            borderSide: BorderSide(color: Color(0xFF778375)),
          ),
          enabledBorder: UnderlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(10)),
            borderSide: BorderSide(color: Color(0xFF778375)),
          ),
          focusedBorder: UnderlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(10)),
            borderSide: BorderSide(color: Color(0xFF778375), width: 4),
          ),
        ),
        validator: (String value) {
          if (value.isEmpty) {
            return "Insira o título da receita.";
          }
          return null;
        },
        onSaved: (value) {
          newRecipe.title = value;
        },
      ),
    );
  }

  Widget buildDropDownButton() {
    return Container(
      margin: EdgeInsets.only(top: 10, left: 30, right: 20, bottom: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'Selecione a categoria',
            style: TextStyle(fontSize: 20, color: Colors.grey),
          ),
          Container(
            margin: EdgeInsets.only(top: 10),
            padding: EdgeInsets.only(left: 20),
            decoration: BoxDecoration(
                color: Color(0xffE0E0E0),
                border: Border.all(color: Colors.grey)),
            child: DropdownButtonHideUnderline(
              child: DropdownButtonFormField(
                isExpanded: true,
                style: const TextStyle(fontSize: 18, color: Colors.black),
                value: _selectedItem,
                items: _categoryList.entries
                    .map<DropdownMenuItem<int>>(
                        (MapEntry<int, String> e) => DropdownMenuItem<int>(
                              value: e.key,
                              child: Text(e.value),
                            ))
                    .toList(),
                onChanged: (int newItem) {
                  setState(() {
                    this._selectedItem = newItem;
                  });
                },
                validator: (value) {
                  if (value == null || value == _categoryList[0]) {
                    return "Selecione uma categoria.";
                  }
                  return null;
                },
                onSaved: (value) {
                  newRecipe.category = value;
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildTimeField() {
    return Container(
      margin: EdgeInsets.only(left: 20, right: 20, bottom: 10),
      child: TextFormField(
        keyboardType: TextInputType.number,
        autocorrect: true,
        cursorColor: Colors.grey,
        decoration: InputDecoration(
          hintText: 'em minutos',
          hintStyle: TextStyle(fontSize: 12, color: Colors.grey),
          labelText: 'Tempo de Preparo',
          labelStyle: TextStyle(fontSize: 20, color: Colors.grey),
          prefixIcon: Icon(Icons.access_alarm),
          filled: true,
          fillColor: Colors.transparent,
          border: UnderlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(10)),
            borderSide: BorderSide(color: Color(0xFF778375)),
          ),
          enabledBorder: UnderlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(10)),
            borderSide: BorderSide(color: Color(0xFF778375)),
          ),
          focusedBorder: UnderlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(10)),
            borderSide: BorderSide(color: Color(0xFF778375), width: 4),
          ),
        ),
        validator: (String value) {
          if (value.isEmpty) {
            return "Insira o tempo de preparo.";
          }
          return null;
        },
        onSaved: (value) {
          newRecipe.cookingTime = int.parse(value);
        },
      ),
    );
  }

  Widget buildPortionsField() {
    return Container(
      margin: EdgeInsets.only(left: 20, right: 20, bottom: 10),
      child: TextFormField(
        keyboardType: TextInputType.number,
        autocorrect: true,
        cursorColor: Colors.grey,
        decoration: InputDecoration(
          labelText: 'Porções',
          labelStyle: TextStyle(fontSize: 20, color: Colors.grey),
          prefixIcon: Icon(Icons.local_restaurant),
          filled: true,
          fillColor: Colors.transparent,
          border: UnderlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(10)),
            borderSide: BorderSide(color: Color(0xFF778375)),
          ),
          enabledBorder: UnderlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(10)),
            borderSide: BorderSide(color: Color(0xFF778375)),
          ),
          focusedBorder: UnderlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(10)),
            borderSide: BorderSide(color: Color(0xFF778375), width: 4),
          ),
        ),
        validator: (String value) {
          if (value.isEmpty) {
            return "Insira a quantidade de porções.";
          }
          return null;
        },
        onSaved: (value) {
          newRecipe.portions = int.parse(value);
        },
      ),
    );
  }

  Widget buildLevelField() {
    return Container(
      margin: EdgeInsets.only(top: 10, left: 30, right: 20, bottom: 10),
      child: Column(children: [
        Align(
          alignment: Alignment.centerLeft,
          child: Text("Dificuldade",
              style: TextStyle(color: Colors.grey, fontSize: 20)),
        ),
        Row(
          children: [
            Radio(
              activeColor: Color(0xFF778375),
              value: 1,
              groupValue: _selectedLevel,
              onChanged: (value) {
                setState(() {
                  newRecipe.level = value;
                  _selectedLevel = value;
                });
              },
            ),
            Text('Fácil', style: TextStyle(fontSize: 18)),
            Radio(
              activeColor: Color(0xFF778375),
              value: 2,
              groupValue: _selectedLevel,
              onChanged: (value) {
                setState(() {
                  newRecipe.level = value;
                  _selectedLevel = value;
                });
              },
            ),
            Text('Médio', style: TextStyle(fontSize: 18)),
            Radio(
              activeColor: Color(0xFF778375),
              value: 3,
              groupValue: _selectedLevel,
              onChanged: (value) {
                setState(() {
                  newRecipe.level = value;
                  _selectedLevel = value;
                });
              },
            ),
            Text('Difícil', style: TextStyle(fontSize: 18)),
          ],
        )
      ]),
    );
  }

  Widget buildDietaryOptions() {
    return Container(
        margin: EdgeInsets.only(left: 30, right: 20, bottom: 10),
        child: Column(
          children: [
            Align(
              alignment: Alignment.centerLeft,
              child: Text("Restrições",
                  style: TextStyle(color: Colors.grey, fontSize: 20)),
            ),
            Column(
              children: _dietaryList.keys.map((key) {
                return CheckboxListTile(
                  title: Text(key.title),
                  value: _dietaryList[key],
                  onChanged: (value) {
                    setState(() {
                      _dietaryList[key] = !_dietaryList[key];
                      if (_dietaryList[key] == true) {
                        newRecipe.dietary.add(key.id);
                      } else {
                        newRecipe.dietary.remove(key.id);
                      }
                    });
                  },
                  controlAffinity: ListTileControlAffinity.leading,
                );
              }).toList(),
            ),
          ],
        ));
  }

  void _showPicker(context) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          return SafeArea(
            child: Container(
              child: new Wrap(
                children: <Widget>[
                  new ListTile(
                      leading: new Icon(Icons.photo_library),
                      title: new Text('Galeria de fotos'),
                      onTap: () {
                        _imgFromGallery();
                        Navigator.of(context).pop();
                      }),
                  new ListTile(
                    leading: new Icon(Icons.photo_camera),
                    title: new Text('Câmera'),
                    onTap: () {
                      _imgFromCamera();
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              ),
            ),
          );
        });
  }

  Widget buildLinkField() {
    return Container(
      margin: EdgeInsets.only(left: 20, right: 20, bottom: 10),
      child: TextFormField(
        keyboardType: TextInputType.text,
        autocorrect: true,
        cursorColor: Colors.grey,
        decoration: InputDecoration(
          labelText: 'Link do vídeo no youtube',
          labelStyle: TextStyle(fontSize: 20, color: Colors.grey),
          prefixIcon: Icon(Icons.link),
          filled: true,
          fillColor: Colors.transparent,
          border: UnderlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(10)),
            borderSide: BorderSide(color: Color(0xFF778375)),
          ),
          enabledBorder: UnderlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(10)),
            borderSide: BorderSide(color: Color(0xFF778375)),
          ),
          focusedBorder: UnderlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(10)),
            borderSide: BorderSide(color: Color(0xFF778375), width: 4),
          ),
        ),
        onSaved: (value) {
          newRecipe.video = value;
        },
      ),
    );
  }

  Widget buildSubmitButton() {
    return Container(
      height: 50,
      width: MediaQuery.of(context).size.width / 2,
      margin: EdgeInsets.only(top: 30, bottom: 15),
      child: ElevatedButton(
        style: ButtonStyle(
          backgroundColor:
              MaterialStateProperty.all<Color>(Color((0xFF778375))),
          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0),
            ),
          ),
        ),
        onPressed: () {
          if (_formKey.currentState.validate()) {
            _formKey.currentState.save();
            BlocProvider.of<ManageRecipeBloc>(context)
                .add(SubmitEvent(recipe: newRecipe));
          }
        },
        child: Center(
          child: Text(
            'SALVAR',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),
        ),
      ),
    );
  }

  addIngredient() {
    setState(() {
      if (_ingredientController.text.length > 0) {
        _ingredients.insert(_ingredients.length, _ingredientController.text);
      }
    });
  }

  removeIngredient(String value) {
    setState(() {
      _ingredients.remove(value);
    });
  }

  addStep() {
    setState(() {
      if (_stepController.text.length > 0) {
        _steps.insert(_steps.length, _stepController.text);
      }
    });
  }

  removeStep(String value) {
    setState(() {
      _steps.remove(value);
    });
  }

  _imgFromCamera() async {
    PickedFile image = await ImagePicker()
        .getImage(source: ImageSource.camera, imageQuality: 50);
    File imageFile = File(image.path);
    setState(() {
      _image = imageFile;
      newRecipe.photo = image.path;
    });
  }

  _imgFromGallery() async {
    PickedFile image = await ImagePicker()
        .getImage(source: ImageSource.gallery, imageQuality: 50);
    File imageFile;
    imageFile = File(image.path);
    setState(() {
      _image = imageFile;
      newRecipe.photo = image.path;
    });
  }
}
