import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:projeto_app/data/firebase_server.dart';
import 'package:projeto_app/logic/monitor_auth/monitor_auth_event.dart';
import 'package:projeto_app/model/user.dart';
import 'monitor_auth_state.dart';

class MonitorAuthBloc extends Bloc<MonitorAuthEvent, MonitorAuthState> {
  UserModel newUser = new UserModel("");
  List<String> idRecipeList = [];

  MonitorAuthBloc() : super(MonitorAuthState(user: new UserModel(""))) {
    add(AskUser());
  }

  @override
  Stream<MonitorAuthState> mapEventToState(MonitorAuthEvent event) async* {
    try {
      if (event is AskUser) {
        var response = await FirebaseServer.helper.getUserInfo();
        UserModel currentUser = response;
        yield MonitorAuthState(user: currentUser);
      }
    } on Exception {
      print("Erro no monitor_recipe_bloc");
    }
  }
}
