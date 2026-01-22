// import 'package:editora/controller/auth_controller.dart';
// import 'package:editora/controller/global_data_controller.dart';
// import 'package:editora/features/authorized/controllers/custom_notification_bell_controller.dart';
import 'package:dronees/controllers/auth_controller.dart';
import 'package:get/get.dart';

import '../utils/helpers/network_manager.dart';

class GeneralBindings extends Bindings {
  @override
  void dependencies() {
    Get.put(NetworkManager());
    Get.put(AuthController());
    // Get.put(GlobalDataController());
    // Get.put(CustomNotificationBellController());
  }
}
