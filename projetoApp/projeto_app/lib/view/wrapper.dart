import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:projeto_app/logic/manage_auth/auth_bloc.dart';
import 'package:projeto_app/logic/manage_auth/auth_state.dart';
import 'package:projeto_app/view/auth/AuthScreen.dart';
import 'package:projeto_app/view/bottom_navigation_bar.dart';

class Wrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthBloc, AuthState>(
      builder: (BuildContext blocContext, AuthState state) {
        if (state is Authenticated) {
          return MyBottomNavigationBar();
        } else {
          return AuthScreen();
        }
      },
      listener: (blocContext, state) {
        if (state is AuthError) {
          showDialog(
              context: context,
              builder: (context) {
                return AlertDialog(
                  title: Text("Erro do Servidor"),
                  content: Text("${state.message}"),
                  actions: [
                    ElevatedButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: Text("Ok"))
                  ],
                );
              });
        }
      },
    );
  }
}
