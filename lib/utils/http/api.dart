class API {
  static const String baseUrl = 'http://10.0.2.2:3000/api';
  // static const String _baseUrl =
  //     'https://fa28-103-249-6-210.ngrok-free.app/api';

  static final getApis = GetApis();
  static final postApis = PostApis();
  static final deleteApis = DeleteApis();

  static const String apiVersion = "v1";
}

class DeleteApis {
  String deleteTravelAllowance(int id) => "/travel/$id";
}

class GetApis {
  // final String userDetails = "/user-details"
  String getPunchingData(int userId) => "/attendance/punchingData/$userId";
  String getPunchingDataById(int id) => "/attendance/punch/$id";
  final String getTravelAllowance = "/travel/my";
  final String getTravelAllowanceStats = "/travel/stats";
}

class PostApis {
  // final String checkUser = "/check-user";
  // auth....
  final String login = "/auth/login";
  final String markPunchIn = "/attendance/punchingData";
  final String markPunchOut = "/attendance/punch-out";
  final String submitAllowance = "/travel";
  final String approveTAByDepartment = "/travel/approve-department";
}
