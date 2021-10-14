class UserModel {
  String _uid;
  String _name;
  String _birthdate;
  String _email;
  String _photo;
  int _gender;

  UserModel(String uid) {
    this._uid = uid;
    _name = "";
    _birthdate = "";
    _email = "";
    _photo = "";
    _gender = 1;
  }

  UserModel.fromMap(map) {
    this._uid = map["uid"];
    this._name = map["name"];
    this._birthdate = map["birthdate"];
    this._email = map["email"];
    this._gender = map["gender"];
    this._photo = map["photo"];
  }

  String get uid => _uid;
  String get name => _name;
  String get birthdate => _birthdate;
  String get email => _email;
  String get photo => _photo;
  int get gender => _gender;

  set uid(String newUid) {
    if (newUid.length > 0) {
      this._uid = newUid;
    }
  }

  set name(String newName) {
    if (newName.length > 0) {
      this._name = newName;
    }
  }

  set birthdate(String newBirthdate) {
    if (newBirthdate.length > 0) {
      this._birthdate = newBirthdate;
    }
  }

  set email(String newEmail) {
    if (newEmail.length > 0) {
      this._email = newEmail;
    }
  }

  set gender(int newGender) {
    if (newGender > 0 && newGender < 4) {
      this._gender = newGender;
    }
  }

  set photo(String newPhoto) {
    this._photo = newPhoto;
  }

  toMap() {
    var map = Map<String, dynamic>();
    map["uid"] = _uid;
    map["name"] = _name;
    map["birthdate"] = _birthdate;
    map["email"] = _email;
    map["gender"] = _gender;
    map["photo"] = _photo;
    return map;
  }
}
