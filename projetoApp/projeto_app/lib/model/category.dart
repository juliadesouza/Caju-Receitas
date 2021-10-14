class CategoryModel {
  int _id;
  String _name;
  String _url;

  CategoryModel(this._id, this._name, this._url);

  int get id => _id;
  String get name => _name;
  String get urlImage => _url;

  set id(i) => _id = i;
  set name(n) => _name = n;
  set urlImage(u) => _url = u;
}
