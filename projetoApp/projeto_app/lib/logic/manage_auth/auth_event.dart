import 'package:projeto_app/model/user.dart';

abstract class AuthEvent {}

class RegisterUser extends AuthEvent {
  String name;
  String birthdate;
  String email;
  String password;
  int gender = 1;
  String photo;
}

class UpdateUser extends AuthEvent {
  String name;
  String email;
  String password;
  int gender = 1;
}

class LoginUser extends AuthEvent {
  String email;
  String password;
}

class Logout extends AuthEvent {}

class InnerServerEvent extends AuthEvent {
  final UserModel userModel;
  InnerServerEvent(this.userModel);
}
