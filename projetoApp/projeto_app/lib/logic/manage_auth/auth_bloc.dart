import 'dart:async';

import 'package:projeto_app/auth_provider/firebase_auth.dart';
import 'package:projeto_app/data/firebase_server.dart';
import 'package:projeto_app/logic/manage_auth/auth_event.dart';
import 'package:projeto_app/logic/manage_auth/auth_state.dart';
import 'package:projeto_app/model/user.dart';
import 'package:bloc/bloc.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  FirebaseAuthenticationService _authenticationService;
  StreamSubscription _authenticationStream;

  AuthBloc() : super(Unauthenticated()) {
    _authenticationService = FirebaseAuthenticationService();

    _authenticationStream =
        _authenticationService.user.listen((UserModel userModel) {
      add(InnerServerEvent(userModel));
    });
  }

  @override
  Stream<AuthState> mapEventToState(AuthEvent event) async* {
    try {
      if (event == null) {
        yield Unauthenticated();
      } else if (event is RegisterUser) {
        await _authenticationService.createUserWithEmailAndPassword(event);
      } else if (event is UpdateUser) {
        await _authenticationService.updateUser(event);
      } else if (event is LoginUser) {
        await _authenticationService.signInWithEmailAndPassword(
            email: event.email, password: event.password);
      } else if (event is InnerServerEvent) {
        if (event.userModel == null) {
          yield Unauthenticated();
        } else {
          FirebaseServer.uid = event.userModel.uid;
          yield Authenticated(user: event.userModel);
        }
      } else if (event is Logout) {
        print("ASKED FOR LOGOUT");
        await _authenticationService.signOut();
      }
    } catch (e) {
      yield AuthError(message: e.toString());
    }
  }
}
