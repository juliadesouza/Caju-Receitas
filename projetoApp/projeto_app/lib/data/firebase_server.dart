import 'dart:async';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:projeto_app/logic/manage_auth/auth_event.dart';
import 'package:projeto_app/model/item.dart';
import 'package:projeto_app/model/recipe.dart';
import 'package:path/path.dart' as p;
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:projeto_app/model/user.dart';

class FirebaseServer {
  static FirebaseServer helper = FirebaseServer._createInstance();
  FirebaseServer._createInstance();

  final recipeCollection = FirebaseFirestore.instance.collection('recipes');
  final userCollection = FirebaseFirestore.instance.collection('users');
  final shoppingCollection =
      FirebaseFirestore.instance.collection('shopping_list');
  final favoriteCollection = FirebaseFirestore.instance.collection('favorites');

  static String uid;
  //static String uid = FirebaseAuth.instance.currentUser.uid;

  includeUserData(String uidUser, RegisterUser user) async {
    final filename = p.basename(user.photo);
    File f = new File(user.photo);

    await firebase_storage.FirebaseStorage.instance
        .ref('images/users/$filename')
        .putFile(f);
    firebase_storage.FirebaseStorage.instance
        .ref()
        .child("images/users/$filename")
        .getDownloadURL()
        .then((path) => {
              userCollection.add({
                'uid': uidUser,
                'name': user.name,
                'birthdate': user.birthdate,
                'email': user.email,
                'gender': user.gender,
                'photo': path
              })
            });
  }

  insertRecipe(RecipeModel recipe) async {
    final filename = p.basename(recipe.photo);
    File f = new File(recipe.photo);

    await firebase_storage.FirebaseStorage.instance
        .ref('images/recipes/$filename')
        .putFile(f);
    firebase_storage.FirebaseStorage.instance
        .ref()
        .child("images/recipes/$filename")
        .getDownloadURL()
        .then((path) {
      recipeCollection.add({
        'idUser': uid,
        'title': recipe.title,
        'cookingTime': recipe.cookingTime,
        'portions': recipe.portions,
        'ingredients': recipe.ingredients,
        'steps': recipe.steps,
        'photo': path,
        'video': recipe.video,
        'category': recipe.category,
        'level': recipe.level,
        'dietary': recipe.dietary
      });
    });
  }

  Future<List<dynamic>> getShoppingList() async {
    QuerySnapshot snapshot =
        await shoppingCollection.doc(uid).collection("my_items").get();
    return _shoppingListFromSnapshot(snapshot);
  }

  List _shoppingListFromSnapshot(QuerySnapshot snapshot) {
    List<ItemModel> itemList = [];
    List<String> idList = [];

    for (var doc in snapshot.docs) {
      ItemModel item = ItemModel.fromMap(doc.data());
      itemList.add(item);
      idList.add(doc.id);
    }
    return [itemList, idList];
  }

  insertItem(ItemModel item) async {
    await shoppingCollection
        .doc(uid)
        .collection("my_items")
        .add({"title": item.title, "clicked": item.clicked});
  }

  updateItem(String itemId, ItemModel item) async {
    await shoppingCollection
        .doc(uid)
        .collection("my_items")
        .doc("$itemId")
        .update({"title": item.title, "clicked": item.clicked});
  }

  deleteItem(String itemId) async {
    await shoppingCollection
        .doc(uid)
        .collection("my_items")
        .doc("$itemId")
        .delete();
  }

  deleteRecipe(String idRecipe) async {
    await recipeCollection.doc("$idRecipe").delete();
  }

  List _recipeListFromSnapshot(QuerySnapshot snapshot) {
    List<String> idRecipeList = [];
    List<RecipeModel> recipeList = [];

    for (var doc in snapshot.docs) {
      if (doc['title'] != "" && doc['photo'] != "") {
        RecipeModel recipe = new RecipeModel();
        recipe.idUser = doc['idUser'];
        recipe.photo = doc['photo'];
        recipe.title = doc['title'];
        recipe.category = doc['category'];
        recipeList.add(recipe);
        idRecipeList.add(doc.id);
      }
    }
    return [recipeList, idRecipeList];
  }

  Future<List<dynamic>> getRecipeList() async {
    QuerySnapshot snapshot = await recipeCollection.get();
    return _recipeListFromSnapshot(snapshot);
  }

  Future<List<dynamic>> getMyRecipesList() async {
    QuerySnapshot snapshot =
        await recipeCollection.where('idUser', isEqualTo: uid).get();
    return _recipeListFromSnapshot(snapshot);
  }

  Future<dynamic> getRecipe(String idRecipe) async {
    DocumentSnapshot snapshot = await recipeCollection.doc(idRecipe).get();
    return _recipeFromSnapshot(snapshot);
  }

  Future<UserModel> getUserInfo() async {
    QuerySnapshot snapshot =
        await userCollection.where('uid', isEqualTo: uid).get();
    return _userFromSnapshot(snapshot);
  }

  UserModel _userFromSnapshot(QuerySnapshot snapshots) {
    var doc = snapshots.docs[0];
    UserModel user = UserModel.fromMap(doc.data());
    return user;
  }

  List _recipeFromSnapshot(DocumentSnapshot doc) {
    RecipeModel recipe = new RecipeModel();
    recipe.idUser = doc['idUser'];
    recipe.photo = doc['photo'];
    recipe.title = doc['title'];
    recipe.cookingTime = doc['cookingTime'];
    recipe.ingredients = doc['ingredients'].cast<String>();
    recipe.portions = doc['portions'];
    recipe.steps = doc['steps'].cast<String>();
    recipe.video = doc['video'];
    recipe.category = doc['category'];
    recipe.level = doc['level'];
    recipe.dietary = doc['dietary'].cast<int>();
    return [recipe, doc.id];
  }

  /*
    STREAM
  */
  Stream get streamRecipesDisplay {
    return recipeCollection.snapshots().map(_recipeListFromSnapshot);
  }

  Stream get streamMyRecipes {
    return recipeCollection
        .where('idUser', isEqualTo: uid)
        .snapshots()
        .map(_recipeListFromSnapshot);
  }

  Stream get streamUserInfo {
    return userCollection
        .where('uid', isEqualTo: uid)
        .snapshots()
        .map(_userFromSnapshot);
  }

  Stream get streamItems {
    return shoppingCollection
        .doc(uid)
        .collection("my_items")
        .snapshots()
        .map(_shoppingListFromSnapshot);
  }
}
