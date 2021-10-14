import 'package:flutter/material.dart';
import 'package:projeto_app/view/auth/LoginScreen.dart';
import 'package:projeto_app/view/auth/RegisterScreen.dart';

class AuthScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _AuthScreenState();
  }
}

class _AuthScreenState extends State<AuthScreen> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        body: TabBarView(
          children: [
            LoginScreen(),
            RegisterScreen(),
          ],
        ),
        appBar: AppBar(
          backgroundColor: Color(0xFF778375),
          title: TabBar(
            indicatorColor: Colors.white,
            tabs: [
              Tab(
                  child: Text(
                "Login",
                style: TextStyle(fontSize: 20),
              )),
              Tab(
                  child: Text(
                "Cadastro",
                style: TextStyle(fontSize: 20),
              ))
            ],
          ),
        ),
      ),
    );
  }
}
