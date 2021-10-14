import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:projeto_app/logic/manage_auth/auth_bloc.dart';
import 'package:projeto_app/logic/manage_auth/auth_event.dart';
import 'package:projeto_app/logic/monitor_auth/monitor_auth_bloc.dart';
import 'package:projeto_app/logic/monitor_auth/monitor_auth_state.dart';
import 'package:projeto_app/model/user.dart';
import 'package:projeto_app/view/profile_menu.dart';

class MyProfileScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return MyProfileScreenState();
  }
}

class MyProfileScreenState extends State<MyProfileScreen> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MonitorAuthBloc, MonitorAuthState>(
      builder: (context, state) {
        return Scaffold(
            appBar: AppBar(
              title: Center(child: Text('MEU PERFIL')),
            ),
            body: SingleChildScrollView(
              padding: EdgeInsets.symmetric(vertical: 20),
              child: Column(
                children: <Widget>[
                  state.user.photo == ""
                      ? Container()
                      : buildUserImage(state.user, context),
                  ProfileMenu(
                    text: "Sair",
                    icon: "assets/images/sair.png",
                    press: () =>
                        {BlocProvider.of<AuthBloc>(context).add(Logout())},
                  ),
                ],
              ),
            ));
      },
    );
  }

  Widget buildUserImage(UserModel user, BuildContext context) {
    return Column(
      children: [
        CircleAvatar(
          radius: 100,
          child: ClipRRect(
              borderRadius: BorderRadius.circular(40),
              child: Image(
                  image: NetworkImage(user.photo),
                  fit: BoxFit.fill,
                  height: 600,
                  width: 600)),
        ),
        Container(
            margin: EdgeInsets.all(20),
            child: Text("${user.name}",
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)))
      ],
    );
  }
}
