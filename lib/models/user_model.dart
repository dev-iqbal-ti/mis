import 'dart:convert';

User userFromJson(String str) => User.fromJson(json.decode(str));

String userToJson(User data) => json.encode(data.toJson());

class User {
  int id;
  String role;
  String name;
  String? phoneNumber;
  String? email;
  String token;

  User({
    required this.id,
    required this.role,
    required this.name,
    this.phoneNumber,
    this.email,
    required this.token,
  });

  factory User.fromJson(Map<String, dynamic> json) => User(
    id: json["id"],
    role: json["role"],
    name: json["name"],
    phoneNumber: json["phoneNumber"],
    email: json["email"],
    token: json["token"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "role": role,
    "name": name,
    "phoneNumber": phoneNumber,
    "email": email,
    "token": token,
  };
}
