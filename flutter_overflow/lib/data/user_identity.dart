class UserIdentity {
  bool ok;
  User user;

  UserIdentity.fromMap(Map json) {
    ok = json['ok'];
    user = User.fromMap(json['user']);
  }
}

class User {
  String name;
  String id;

  User.fromMap(Map json) {
    id = json['id'];
    name = json['name'];
  }
}
