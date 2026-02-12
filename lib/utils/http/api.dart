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
  final String getTravelAllowanceReportList = "/travel/list";
  final String getUsers = "/users/getUsers";
  final String getGallery = "/gallery";

  final String getEquipments = "/equipment";
  final String getAssignedEquipments = "/equipment/assigned";

  final String getProjects = "/payment-received/projects";
  final String moneyReceivedList = "/payment-received";
  final String modenyCollection = "/payment-received/collection";
  String verifyPayment(int id) => "/payment-received/approve/$id";
}

class PostApis {
  // final String checkUser = "/check-user";
  // auth....
  final String login = "/auth/login";
  final String markPunchIn = "/attendance/punchingData";
  final String markPunchOut = "/attendance/punch-out";
  final String submitAllowance = "/travel";
  final String approveTA = "/travel/approve";
  final String rejectTA = "/travel/reject";

  // -- gallary --
  final String uploadImage = "/gallery/upload";
  String deleteImage(int id) => "/gallery/delete$id";

  final String assignEquipment = "/equipment/assign";
  final String unassignEquipment = "/equipment/unassign";

  final String submitMoneyReceived = "/payment-received";
}
