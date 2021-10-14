import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:projeto_app/logic/manage_auth/auth_bloc.dart';
import 'package:projeto_app/logic/manage_auth/auth_event.dart';
import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return LoginScreenState();
  }
}

class LoginScreenState extends State<LoginScreen> {
  final GlobalKey<FormState> _formKey = new GlobalKey<FormState>();
  final LoginUser loginData = new LoginUser();
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Form(
          key: _formKey,
          child: Column(
            children: [
              buildLogotype(),
              buildLoginTitle(),
              buildEmailField(),
              buildPasswordField(),
              buildSubmitButton(context)
            ],
          )),
    );
  }

  Widget buildLogotype() {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height / 2.3,
      margin: EdgeInsets.only(bottom: 20),
      decoration: BoxDecoration(
          color: Color(0xFF778375),
          image: DecorationImage(
            image: AssetImage('assets/images/logo_login.png'),
            fit: BoxFit.fill,
          ),
          borderRadius: BorderRadius.only(
              bottomRight: Radius.circular(20),
              bottomLeft: Radius.circular(20))),
    );
  }

  Widget buildLoginTitle() {
    return Container(
      margin: EdgeInsets.all(20),
      child: Align(
        alignment: Alignment.center,
        child: Text(
          "LOGIN",
          style: TextStyle(
            fontSize: 30,
            fontWeight: FontWeight.bold,
            color: Color(0xFF778375),
          ),
        ),
      ),
    );
  }

  Widget buildEmailField() {
    return Container(
      margin: EdgeInsets.only(left: 20, right: 20, bottom: 15),
      child: TextFormField(
        keyboardType: TextInputType.emailAddress,
        autocorrect: true,
        //initialValue: userList[0].email,
        decoration: InputDecoration(
          hintText: 'Email',
          prefixIcon: Icon(Icons.email, color: Color(0xFF778375)),
          hintStyle: TextStyle(color: Colors.grey),
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
        validator: (String inValue) {
          if (inValue.isEmpty) {
            return "Insira um email.";
          }
          return null;
        },
        onSaved: (value) {
          loginData.email = value;
        },
      ),
    );
  }

  Widget buildPasswordField() {
    return Container(
      margin: EdgeInsets.only(left: 20, right: 20, bottom: 20),
      child: TextFormField(
        obscureText: true,
        // initialValue: userList[0].password,
        decoration: InputDecoration(
          hintText: 'Senha',
          prefixIcon: Icon(Icons.vpn_key, color: Color(0xFF778375)),
          hintStyle: TextStyle(color: Colors.grey),
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
        validator: (String inValue) {
          if (inValue.length < 10) {
            return "A senha deve ter pelo menos 10 caracteres.";
          }
          return null;
        },
        onSaved: (value) {
          loginData.password = value;
        },
      ),
    );
  }

  Widget buildSubmitButton(BuildContext context) {
    return Container(
      height: 50,
      width: MediaQuery.of(context).size.width / 2,
      margin: EdgeInsets.only(bottom: 15),
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
            BlocProvider.of<AuthBloc>(context).add(loginData);
          }
        },
        child: Center(
          child: Text(
            'Entrar',
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
}
