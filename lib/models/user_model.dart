class UserModel {
  String name;
  String email;
  String employeeID;

  UserModel({
    required this.name,
    required this.email,
    required this.employeeID
  });

  Map<String, String> toJson() {
    return {
      "name": name,
      "email": email,
      "employeeId":employeeID
    };
  }

  static UserModel fromJson(Map<String, dynamic> data) {
    UserModel user = UserModel(name: data['name'], email: data['email'],employeeID: data['employeeID']);
    return user;
  }
}
