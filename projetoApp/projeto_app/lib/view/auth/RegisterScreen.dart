import 'dart:io';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:projeto_app/logic/manage_auth/auth_bloc.dart';
import 'package:projeto_app/logic/manage_auth/auth_event.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

enum Gender { feminino, masculino, outro }

class RegisterScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return RegisterState();
  }
}

class RegisterState extends State<RegisterScreen> {
  final GlobalKey<FormState> _formKey = new GlobalKey<FormState>();
  final RegisterUser registerData = new RegisterUser();

  TextEditingController _selectedDate = TextEditingController();
  DateTime _date = DateTime.now();
  int _selectedGender = 1;

  static const MaterialColor _datePickerColor =
      MaterialColor(0xFF778375, <int, Color>{
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

  File _image;

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: EdgeInsets.only(top: 20),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                buildRegisterTitle(),
                buildPhoto(),
                buildNameFormField(),
                buildBirthdayDateField(),
                buildEmailFormField(),
                buildPasswordFormField(),
                buildGenderOption(),
                buildSubmitButton(context),
              ],
            ),
          ),
        ));
  }

  Future<Null> _selectDate(BuildContext context) async {
    DateTime _datePicker = await showDatePicker(
        context: context,
        initialDate: _date,
        firstDate: DateTime(1947),
        lastDate: _date,
        builder: (BuildContext context, Widget child) {
          return Theme(
            data: ThemeData(
              primarySwatch: _datePickerColor,
              primaryColor: Color(0xFF778375),
              accentColor: Color(0xFF778375),
            ),
            child: child,
          );
        });

    if (_datePicker != null && _datePicker != _date) {
      setState(() {
        _date = _datePicker;
        _selectedDate.text = '${_date.day}/${_date.month}/${_date.year}';
      });
    }
  }

  Widget buildRegisterTitle() {
    return Container(
      margin: EdgeInsets.all(20),
      child: Align(
        alignment: Alignment.center,
        child: Text(
          "CADASTRO",
          style: TextStyle(
            fontSize: 30,
            fontWeight: FontWeight.bold,
            color: Color(0xFF778375),
          ),
        ),
      ),
    );
  }

  Widget buildNameFormField() {
    return Container(
      margin: EdgeInsets.only(left: 20, right: 20, bottom: 10),
      child: TextFormField(
        keyboardType: TextInputType.text,
        autocorrect: true,
        cursorColor: Colors.grey,
        decoration: InputDecoration(
          labelText: 'Nome Completo',
          labelStyle: TextStyle(fontSize: 20, color: Colors.grey),
          prefixIcon: Icon(Icons.person, color: Color(0xFF778375)),
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
            return "Insira seu nome completo.";
          }
          return null;
        },
        onSaved: (value) {
          registerData.name = value;
        },
      ),
    );
  }

  Widget buildEmailFormField() {
    return Container(
      margin: EdgeInsets.only(left: 20, right: 20, bottom: 10),
      child: TextFormField(
        keyboardType: TextInputType.emailAddress,
        autocorrect: true,
        cursorColor: Colors.grey,
        decoration: InputDecoration(
          labelText: 'Email',
          labelStyle: TextStyle(fontSize: 20, color: Colors.grey),
          prefixIcon: Icon(Icons.email, color: Color(0xFF778375)),
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
            return "Insira um email.";
          }
          return null;
        },
        onSaved: (value) {
          registerData.email = value;
        },
      ),
    );
  }

  Widget buildBirthdayDateField() {
    return Container(
      margin: EdgeInsets.only(left: 20, right: 20, bottom: 10),
      child: TextFormField(
        readOnly: true,
        cursorColor: Colors.grey,
        controller: _selectedDate,
        decoration: InputDecoration(
          labelText: 'Data de Nascimento',
          labelStyle: TextStyle(fontSize: 20, color: Colors.grey),
          hintText: '${_date.day}/${_date.month}/${_date.year}',
          hintStyle: TextStyle(color: Colors.grey),
          prefixIcon: Icon(Icons.calendar_today, color: Color(0xFF778375)),
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
            return "Insira sua data de nascimento.";
          }
          return null;
        },
        onSaved: (value) {
          registerData.birthdate = value;
        },
        onTap: () {
          setState(() {
            _selectDate(context);
          });
        },
      ),
    );
  }

  Widget buildPasswordFormField() {
    return Container(
      margin: EdgeInsets.only(left: 20, right: 20, bottom: 10),
      child: TextFormField(
        obscureText: true,
        cursorColor: Colors.grey,
        decoration: InputDecoration(
          labelText: 'Senha',
          labelStyle: TextStyle(fontSize: 20, color: Colors.grey),
          prefixIcon: Icon(Icons.vpn_key, color: Color(0xFF778375)),
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
          if (value.length < 10) {
            return "A senha deve ter pelo menos 10 caracteres.";
          }
          return null;
        },
        onSaved: (value) {
          registerData.password = value;
        },
      ),
    );
  }

  Widget buildGenderOption() {
    return Container(
      margin: EdgeInsets.only(top: 20, left: 30, right: 20, bottom: 10),
      child: Column(children: [
        Align(
          alignment: Alignment.centerLeft,
          child: Text(
            "GÃªnero",
            style: TextStyle(color: Colors.grey, fontSize: 20),
          ),
        ),
        Row(
          children: [
            Radio(
              activeColor: Color(0xFF778375),
              value: 1,
              groupValue: _selectedGender,
              onChanged: (value) {
                setState(() {
                  registerData.gender = 1;
                  _selectedGender = value;
                });
              },
            ),
            Text('Feminino', style: TextStyle(fontSize: 14)),
            Radio(
              activeColor: Color(0xFF778375),
              value: 2,
              groupValue: _selectedGender,
              onChanged: (value) {
                setState(() {
                  registerData.gender = 2;
                  _selectedGender = value;
                });
              },
            ),
            Text('Masculino', style: TextStyle(fontSize: 14)),
            Radio(
              activeColor: Color(0xFF778375),
              value: 3,
              groupValue: _selectedGender,
              onChanged: (value) {
                setState(() {
                  registerData.gender = 3;
                  _selectedGender = value;
                });
              },
            ),
            Text('Outro', style: TextStyle(fontSize: 14)),
          ],
        )
      ]),
    );
  }

  Widget buildSubmitButton(BuildContext context) {
    return Container(
      height: 50,
      width: MediaQuery.of(context).size.width / 2,
      margin: EdgeInsets.only(bottom: 10),
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
            BlocProvider.of<AuthBloc>(context).add(registerData);
          }
        },
        child: Center(
          child: Text(
            'Cadastrar',
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

  _imgFromCamera() async {
    PickedFile image = await ImagePicker()
        .getImage(source: ImageSource.camera, imageQuality: 50);
    File imageFile = File(image.path);
    setState(() {
      _image = imageFile;
      registerData.photo = image.path;
    });
  }

  _imgFromGallery() async {
    PickedFile image = await ImagePicker()
        .getImage(source: ImageSource.gallery, imageQuality: 50);
    File imageFile;
    imageFile = File(image.path);
    setState(() {
      _image = imageFile;
      registerData.photo = image.path;
    });
  }
}
