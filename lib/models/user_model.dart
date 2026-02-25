import 'dart:convert';

User userFromJson(String str) => User.fromJson(json.decode(str));

String userToJson(User data) => json.encode(data.toJson());

class UserRole {
  static const manager = "Manager";
  static const employee = "Employee";
  static const finance = "Finance";
  static const operations = "Operations";
  static const hr = "HR";
}

class User {
  String accessToken;
  String refreshToken;
  String sessionId;
  UserDetails userDetails;

  User({
    required this.accessToken,
    required this.refreshToken,
    required this.sessionId,
    required this.userDetails,
  });

  factory User.fromJson(Map<String, dynamic> json) => User(
    accessToken: json["accessToken"],
    refreshToken: json["refreshToken"],
    sessionId: json["sessionId"],
    userDetails: UserDetails.fromJson(json["userDetails"]),
  );

  Map<String, dynamic> toJson() => {
    "accessToken": accessToken,
    "refreshToken": refreshToken,
    "sessionId": sessionId,
    "userDetails": userDetails.toJson(),
  };
}

class UserDetails {
  int id;
  String firstName;
  String lastName;
  String username;
  String emailId;
  String contactNo;
  String emergencyContactNo;
  String currentAddress;
  String permanentAddress;
  DateTime dateOfBirth;
  DateTime createdAt;
  DateTime updatedAt;
  int employerId;
  int workLocationId;
  String orgEmailId;
  dynamic profilePic;
  final String rolesDisplayNames;
  List<int> roles;
  String fullName;

  UserDetails({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.username,
    required this.emailId,
    required this.contactNo,
    required this.emergencyContactNo,
    required this.currentAddress,
    required this.workLocationId,
    required this.permanentAddress,

    required this.dateOfBirth,

    required this.createdAt,
    required this.updatedAt,

    required this.employerId,
    required this.orgEmailId,
    required this.profilePic,
    required this.rolesDisplayNames,
    required this.roles,
    required this.fullName,
  });

  factory UserDetails.fromJson(Map<String, dynamic> json) => UserDetails(
    id: json["id"],
    firstName: json["first_name"],
    lastName: json["last_name"],
    username: json["username"],
    emailId: json["email_id"],
    contactNo: json["contact_no"],
    emergencyContactNo: json["emergency_contact_no"],
    currentAddress: json["current_address"],

    permanentAddress: json["permanent_address"],
    workLocationId: json["work_location_id"],
    dateOfBirth: DateTime.parse(json["date_of_birth"]),

    createdAt: DateTime.parse(json["created_at"]),
    updatedAt: DateTime.parse(json["updated_at"]),

    employerId: json["employer_id"],
    orgEmailId: json["org_email_id"],
    profilePic: json["profile_pic"],
    rolesDisplayNames: json["roles_display_names"],
    roles: List<int>.from(json["roles"].map((x) => x)),
    fullName: json["full_name"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "first_name": firstName,
    "last_name": lastName,
    "username": username,
    "email_id": emailId,
    "contact_no": contactNo,
    "emergency_contact_no": emergencyContactNo,
    "current_address": currentAddress,
    "work_location_id": workLocationId,
    "permanent_address": permanentAddress,
    "date_of_birth": dateOfBirth.toIso8601String(),
    "created_at": createdAt.toIso8601String(),
    "updated_at": updatedAt.toIso8601String(),
    "employer_id": employerId,
    "org_email_id": orgEmailId,
    "profile_pic": profilePic,
    "roles_display_names": rolesDisplayNames,
    "roles": List<dynamic>.from(roles.map((x) => x)),
    "full_name": fullName,
  };
}
