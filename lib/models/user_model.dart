class UserModel {
  String name;
  String email;

  UserModel({
    required this.name,
    required this.email,
  });

  Map<String, String> toJson() {
    return {
      "name": name,
      "email": email,
    };
  }

  static UserModel fromJson(Map<String, dynamic> data) {
    UserModel user = UserModel(name: data['name'], email: data['email']);
    return user;
  }
}
