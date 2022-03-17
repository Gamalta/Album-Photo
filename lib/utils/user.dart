class User {

  String _uuid = "";
  String _name = "";

  User(this._uuid, this._name);

  User.fromJson(Map<String, dynamic> json) {
    _uuid = json['uuid'];
    _name = json['name'];
  }

  Map<String, dynamic> toJson() => {
        '"uuid"': '"$_uuid"',
        '"name"': '"$_name"',
  };

  String getUniqueId() {
    return _uuid;
  }

  String getName() {
    return _name;
  }
}