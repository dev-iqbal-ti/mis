import 'package:dronees/widgets/submit_confirmation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart' as gmaps;

class FieldTaskController extends GetxController {
  final taskFormKey = GlobalKey<FormState>();

  // Controllers
  final clientNameController = TextEditingController();
  final phoneController = TextEditingController();
  final locationController = TextEditingController();

  // Observable Selections
  Rxn<String> selectedProject = Rxn<String>(null);
  Rxn<String> selectedWorkType = Rxn<String>(null);
  Rxn<String> selectedNatureOfJob = Rxn<String>(null);
  var selectedTeamMembers = <String>[].obs; // Multi-select
  var locationName = "".obs;
  var currentPosition = Rxn<gmaps.LatLng>();
  var isReady = false.obs;

  final teamMembers = [
    "Alex Johnson",
    "Jordan Smith",
    "Sarah Williams",
    "Michael Brown",
    "Priya Das",
  ];

  // Mock Data
  final projects = ["Skyline Residency", "Metro Bridge", "Global Tech Hub"];
  final workTypes = ["Installation", "Maintenance", "Survey", "Repair"];
  final teamMembersList = ["Alex", "Jordan", "Sarah", "Mike", "Priya"];
  final jobNatureList = ["Urgent", "Routine", "Follow-up", "Consultation"];

  @override
  void onInit() {
    super.onInit();
    getLocation();
  }

  Future<void> getLocation() async {
    try {
      // Assuming 'service' is your location service instance
      // final info = await service.getCurrentPlaceInfo();
      // final place = await service.getPlaceInfo(info.latitude, info.longitude);

      // Mocking the result for implementation
      locationName.value = "123 Tech Park, Bangalore, India";
      locationController.text = locationName.value;
      currentPosition.value = const gmaps.LatLng(12.9716, 77.5946);
      isReady.value = true;
    } catch (e) {
      Get.snackbar("Error", "Could not fetch location");
    }
  }

  void toggleTeamMember(String name) {
    if (selectedTeamMembers.contains(name)) {
      selectedTeamMembers.remove(name);
    } else {
      selectedTeamMembers.add(name);
    }
  }

  void submitTask() {
    taskFormKey.currentState!.save();

    // Logic to save data
    Get.snackbar(
      "Success",
      "Task report submitted successfully",
      snackPosition: SnackPosition.BOTTOM,
    );
  }
}
