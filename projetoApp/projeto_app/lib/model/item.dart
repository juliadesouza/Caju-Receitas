class ItemModel {
  String _title;
  bool _clicked;

  ItemModel() {
    _title = "";
    _clicked = false;
  }

  ItemModel.fromMap(map) {
    this._title = map["title"];
    this._clicked = map["clicked"];
  }

  String get title => _title;
  set title(String newTitle) {
    if (newTitle.length > 0) {
      this._title = newTitle;
    }
  }

  bool get clicked => _clicked;
  set clicked(bool newClick) {
    this._clicked = newClick;
  }

  toMap() {
    var map = Map<String, dynamic>();
    map["title"] = _title;
    map["clicked"] = _clicked;
    return map;
  }
}
