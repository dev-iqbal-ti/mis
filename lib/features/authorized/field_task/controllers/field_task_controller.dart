import 'dart:async';
import 'dart:convert';

import 'package:dronees/models/employees_model.dart';
import 'package:dronees/utils/http/api.dart';
import 'package:dronees/utils/http/http_client.dart';
import 'package:dronees/widgets/submit_confirmation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart' as gmaps;

class FieldTaskController extends GetxController {
  final taskFormKey = GlobalKey<FormState>();
  Timer? _debounce;
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
  var isLoadingUser = false.obs;
  RxList<Employees> teamMembers = <Employees>[].obs;
  RxList<Employees> selectedTeamMembersList = <Employees>[].obs;
  var searchController = TextEditingController();

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

  @override
  void onClose() {
    _debounce?.cancel();
    clientNameController.dispose();
    super.onClose();
  }

  Future<void> getTeamMembers({String? search}) async {
    isLoadingUser.value = true;
    final queryParams = <String, dynamic>{};
    if (search != null && search.trim().isNotEmpty) {
      queryParams["search"] = search;
    }
    final response = await THttpHelper.getRequest(
      API.getApis.getUsers,
      queryParams: queryParams,
    );

    if (response == null) {
      isLoadingUser.value = false;
      return;
    }

    isLoadingUser.value = false;
    teamMembers.value = employeesFromJson(json.encode(response["data"]));
    // selectedTeamMembersList.value = teamMembers;
  }

  void searchTeamMembers(String search) {
    if (_debounce?.isActive ?? false) _debounce!.cancel();

    // Start new timer
    _debounce = Timer(const Duration(milliseconds: 500), () {
      getTeamMembers(search: search);
      searchController.text = search;
    });
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

  void toggleTeamMember(Employees emp, FormFieldState<List<Employees>> field) {
    if (selectedTeamMembersList.contains(emp)) {
      selectedTeamMembersList.remove(emp);
    } else {
      selectedTeamMembersList.add(emp);
    }
    field.didChange(selectedTeamMembersList);
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
