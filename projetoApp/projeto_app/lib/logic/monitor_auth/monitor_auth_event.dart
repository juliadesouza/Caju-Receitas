import 'package:projeto_app/model/user.dart';

abstract class MonitorAuthEvent {}

class AskUser extends MonitorAuthEvent {
  UserModel user;
  AskUser({this.user});
}
