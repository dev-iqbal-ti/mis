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
  int isSameAddress;
  String permanentAddress;
  int genderId;
  int bloodgroupId;
  int maritalstatusId;
  DateTime dateOfBirth;
  String aadhaarNo;
  String panNo;
  String prranNo;
  String uanNo;
  int empstatusId;
  String profileCompletionStatus;
  DateTime createdAt;
  DateTime updatedAt;
  dynamic createdBy;
  int employerId;
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
    required this.isSameAddress,
    required this.permanentAddress,
    required this.genderId,
    required this.bloodgroupId,
    required this.maritalstatusId,
    required this.dateOfBirth,
    required this.aadhaarNo,
    required this.panNo,
    required this.prranNo,
    required this.uanNo,
    required this.empstatusId,
    required this.profileCompletionStatus,
    required this.createdAt,
    required this.updatedAt,
    required this.createdBy,
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
    isSameAddress: json["is_same_address"],
    permanentAddress: json["permanent_address"],
    genderId: json["gender_id"],
    bloodgroupId: json["bloodgroup_id"],
    maritalstatusId: json["maritalstatus_id"],
    dateOfBirth: DateTime.parse(json["date_of_birth"]),
    aadhaarNo: json["aadhaar_no"],
    panNo: json["pan_no"],
    prranNo: json["prran_no"],
    uanNo: json["uan_no"],
    empstatusId: json["empstatus_id"],
    profileCompletionStatus: json["profile_completion_status"],
    createdAt: DateTime.parse(json["created_at"]),
    updatedAt: DateTime.parse(json["updated_at"]),
    createdBy: json["created_by"],
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
    "is_same_address": isSameAddress,
    "permanent_address": permanentAddress,
    "gender_id": genderId,
    "bloodgroup_id": bloodgroupId,
    "maritalstatus_id": maritalstatusId,
    "date_of_birth": dateOfBirth.toIso8601String(),
    "aadhaar_no": aadhaarNo,
    "pan_no": panNo,
    "prran_no": prranNo,
    "uan_no": uanNo,
    "empstatus_id": empstatusId,
    "profile_completion_status": profileCompletionStatus,
    "created_at": createdAt.toIso8601String(),
    "updated_at": updatedAt.toIso8601String(),
    "created_by": createdBy,
    "employer_id": employerId,
    "org_email_id": orgEmailId,
    "profile_pic": profilePic,
    "roles_display_names": rolesDisplayNames,
    "roles": List<dynamic>.from(roles.map((x) => x)),
    "full_name": fullName,
  };
}
