import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:projeto_app/data/firebase_server.dart';
import 'package:projeto_app/logic/manage_auth/auth_event.dart';
import 'package:projeto_app/model/user.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:firebase_core/firebase_core.dart' as firebase_core;
import 'package:path/path.dart' as p;
import 'dart:io';

class FirebaseAuthenticationService {
  FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  FirebaseFirestore _database = FirebaseFirestore.instance;

  Stream<UserModel> get user {
    return _firebaseAuth
        .authStateChanges()
        .map((User user) => _userFromFirebaseUser(user));
  }

  UserModel _userFromFirebaseUser(User user) {
    return user != null ? UserModel(user.uid) : null;
  }

  String getUid() {
    return _firebaseAuth.currentUser.uid;
  }

  signInWithEmailAndPassword({String email, String password}) async {
    UserCredential authResult = await _firebaseAuth.signInWithEmailAndPassword(
        email: email, password: password);
    User user = authResult.user;
    return UserModel(user.uid);
  }

  createUserWithEmailAndPassword(RegisterUser current) async {
    UserCredential authResult =
        await _firebaseAuth.createUserWithEmailAndPassword(
            email: current.email, password: current.password);
    User user = authResult.user;
    FirebaseServer.helper.includeUserData(user.uid, current);

    return UserModel(user.uid);
  }

  Future uploadImageToFirebase(File fileImage) async {
    try {
      final filename = p.basename(fileImage.path);
      await firebase_storage.FirebaseStorage.instance
          .ref('images/users/$filename')
          .putFile(fileImage);
    } on firebase_core.FirebaseException catch (e) {
      print(e);
    }
  }

  updateUser(UpdateUser newUser) async {
    await _firebaseAuth.currentUser.updateEmail(newUser.email);
    await _firebaseAuth.currentUser.updatePassword(newUser.password);

    _database
        .collection("users")
        .where("uid", isEqualTo: _firebaseAuth.currentUser.uid)
        .snapshots()
        .listen((event) {
      var document = event.docs[0].id;
      _database
          .collection('users')
          .doc(document)
          .update({
            'name': newUser.name,
            'email': newUser.email,
            'password': newUser.password,
            'gender': newUser.gender
          })
          .then((value) => print("User Updated"))
          .catchError((value) => print("User NOT Updated"));
    });
    return UserModel(_firebaseAuth.currentUser.uid);
  }

  signOut() async {
    await _firebaseAuth.signOut();
  }
}
