class RecipeModel {
  String _idUser;
  String _title;
  String _photo;
  String _video;
  int _cookingTime;
  int _portions;
  int _category;
  int _level;
  List<String> _ingredients;
  List<String> _steps;
  List<int> _dietary;

  RecipeModel() {
    _idUser = "";
    _title = "";
    _photo = "";
    _video = "";
    _cookingTime = 0;
    _category = 0;
    _portions = 0;
    _level = 1;
    _ingredients = [];
    _steps = [];
    _dietary = [];
  }

  String get title => _title;
  String get idUser => _idUser;
  int get cookingTime => _cookingTime;
  int get portions => _portions;
  List<String> get ingredients => _ingredients;
  List<String> get steps => _steps;
  String get photo => _photo;
  String get video => _video;
  int get category => _category;
  int get level => _level;
  List<int> get dietary => _dietary;

  set idUser(String newId) {
    if (newId.length > 0) {
      this._idUser = newId;
    }
  }

  set title(String newTitle) {
    if (newTitle.length > 0) {
      this._title = newTitle;
    }
  }

  set cookingTime(int newTime) {
    if (newTime >= 0) {
      this._cookingTime = newTime;
    }
  }

  set portions(int newPortion) {
    if (newPortion >= 0) {
      this._portions = newPortion;
    }
  }

  set ingredients(List<String> newIngredients) {
    if (newIngredients.length > 0) {
      this._ingredients = newIngredients;
    }
  }

  set steps(List<String> newSteps) {
    if (newSteps.length > 0) {
      this._steps = newSteps;
    }
  }

  set photo(String newPhoto) {
    if (newPhoto.length > 0) {
      this._photo = newPhoto;
    }
  }

  set video(String newUrl) {
    if (newUrl.length > 0) {
      this._video = newUrl;
    }
  }

  set category(int newCategory) {
    if (newCategory > 0) {
      this._category = newCategory;
    }
  }

  set level(int newLevel) {
    if (newLevel > 0) {
      this._level = newLevel;
    }
  }

  set dietary(List<int> newDietary) {
    this._dietary = newDietary;
  }

  toMap() {
    var map = Map<String, dynamic>();
    map["title"] = _title;
    map["cookingTime"] = _cookingTime;
    map["portions"] = _portions;
    map["ingredients"] = _ingredients;
    map["steps"] = _steps;
    map["photo"] = _photo;
    map["_video"] = _video;
    map["category"] = _category;
    map["level"] = _level;
    map["dietary"] = _dietary;
    return map;
  }

  /*RecipeModel.fromMap(map) {
    this._title = map["title"];
    this._cookingTime = map["cookingTime"];
    this._portions = map["portions"];
    this._ingredients = map["ingredients"];
    this._steps = map["steps"];
    this._photo = map["photo"];
    this._video = map["video"];
    this._category = map["category"];
    this._level = map["level"];
    this._dietary = map["dietary"];
  }*/
}
