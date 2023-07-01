class UserEditFormModel {
  String? name;
  String? username;
  String? email;
  String? password;

  UserEditFormModel({
    this.name,
    this.username,
    this.email,
    this.password,
  });

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'username': username,
      'email': email,
      'password': password,
    };
  }
}
