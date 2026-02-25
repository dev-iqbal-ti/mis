import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:camera/camera.dart';
import 'package:dronees/controllers/auth_controller.dart';
import 'package:dronees/features/authorized/attendance/controllers/attendance_controller.dart';
import 'package:dronees/features/authorized/attendance/models/attendance_record.dart';
import 'package:dronees/features/authorized/money_receive/models/projects_model.dart';
import 'package:dronees/models/vehicle.dart';
import 'package:dronees/utils/helpers/add_water_mark.dart';
import 'package:dronees/utils/helpers/image_picker_helper.dart';
import 'package:dronees/utils/http/api.dart';
import 'package:dronees/utils/http/http_client.dart';
import 'package:dronees/utils/logging/logger.dart';
import 'package:dronees/widgets/custom_alert_sheet.dart';
import 'package:dronees/widgets/custom_blur_bottom_sheet.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:intl/intl.dart';
import 'package:latlong_to_place/latlong_to_place.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart' as gmaps;

class AttendanceMarkController extends GetxController {
  static AttendanceMarkController get to => Get.find();

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  var isReady = false.obs;
  final RxBool isLoading = false.obs;
  final service = GeocodingService();

  var currentPosition = Rxn<gmaps.LatLng>();
  RxString locationName = "".obs;
  RxString currentDate = "".obs;
  RxList<Vehicle> vehicles = <Vehicle>[].obs;
  Rx<Vehicle?> selectedVehicle = Rxn<Vehicle>(null);
  var selfieFile = Rxn<File>();

  final meterReadingController = TextEditingController();
  final coPassengerController = TextEditingController();
  RxBool isIdle = false.obs;
  RxList<ProjectsModel> projects = <ProjectsModel>[].obs;
  Rxn<ProjectsModel> selectedProject = Rxn<ProjectsModel>(null);

  @override
  void onInit() {
    super.onInit();
    initMarkScreen();
    if (AuthController.instance.authUser?.userDetails.rolesDisplayNames ==
        "Driver") {
      _loadVehicles();
    } else {
      _loadProjects();
    }
  }

  @override
  void onClose() {
    meterReadingController.dispose();
    coPassengerController.dispose();
    super.onClose();
  }

  Future<void> _loadProjects() async {
    final response = await THttpHelper.getRequest(API.getApis.getProjects);

    if (response == null) return;
    if (response["data"].isEmpty) {
      CustomBlurBottomSheet.show(
        Get.context!,
        widget: CustomAlertSheet(
          icon: Iconsax.car,
          title: "No Projects Found",
          message: "No projects found. Please contact your manager.",
          buttonText: "Go Back",
          onAction: () {
            Get.back();
            Get.back();
          },
        ),
        isDismissible: false,
        enaleDrag: false,
      );
      return;
    }
    projects.value = projectsModelFromJson(jsonEncode(response["data"]));
  }

  Future<void> _loadVehicles() async {
    final response = await THttpHelper.getRequest(API.getApis.getVehicles);

    if (response == null) return;

    if (response["data"].isEmpty) {
      CustomBlurBottomSheet.show(
        Get.context!,
        widget: CustomAlertSheet(
          icon: Iconsax.car,
          title: "No Vehicles Found",
          message: "No vehicles found. Please contact your manager.",
          buttonText: "Go Back",
          onAction: () {
            Get.back();
            Get.back();
          },
        ),
        isDismissible: false,
        enaleDrag: false,
      );
      return;
    }

    vehicles.value = vehicleFromJson(jsonEncode(response["data"]));
  }

  void initMarkScreen() {
    getLocation();
    final DateTime now = DateTime.now();
    final DateFormat formatter = DateFormat('dd MMMM yyyy');
    currentDate.value = formatter.format(now);
  }

  Future<void> getLocation() async {
    TLoggerHelper.customPrint("Getting location");
    if (!isReady.value) {
      isLoading.value = true;
    }
    final info = await service.getCurrentPlaceInfo();
    final place = await service.getPlaceInfo(info.latitude, info.longitude);
    TLoggerHelper.customPrint(place.toString());
    locationName.value = place.formattedAddress;
    currentPosition.value = gmaps.LatLng(info.latitude, info.longitude);
    isReady.value = true;
    isLoading.value = false;
  }

  void goBack() {
    selfieFile.value = null;
    isLoading.value = false;
    Get.back();
  }

  Future<void> takeSelfieAndTag() async {
    final pickImage = await ImageUploadService.takePhoto(xFile: true);
    if (pickImage == null || pickImage is! XFile) return;
    final picture = pickImage;

    final raw = File(picture.path);

    final stamped = await addWatermark(
      originalImage: raw,
      address: locationName.value,
      latLng:
          "Lat: ${currentPosition.value!.latitude} long: ${currentPosition.value!.longitude}",
      dateTime: DateFormat('yyyy-MM-dd HH:mm:ss').format(DateTime.now()),
    );
    selfieFile.value = stamped;
  }

  Future<void> clockIn() async {
    try {
      isLoading.value = true;

      // Create FormData
      final dateTime = DateFormat('yyyy-MM-dd HH:mm:ss').format(DateTime.now());
      final Map<String, dynamic> data = {
        "address": locationName.value,
        "latitude": currentPosition.value!.latitude.toString(),
        "longitude": currentPosition.value!.longitude.toString(),
        "punch_in_time": dateTime,
        "punch_mode": "MOBILE",
        "date": DateFormat('yyyy-MM-dd').format(DateTime.now()),
        "idle_state": isIdle.value,
        "created_at": dateTime,
      };

      if (!isIdle.value) {
        data["project_id"] = selectedProject.value!.id.toString();
      }

      if (AuthController.instance.authUser?.userDetails.rolesDisplayNames ==
          "Driver") {
        data["vehicle_id"] = selectedVehicle.value!.id.toString();
        data["meter_reading"] = meterReadingController.text;
        data["co_passenger"] = coPassengerController.text;
      }

      final response = await THttpHelper.formDataRequest(
        API.postApis.markPunchIn,
        selfieFile.value!,
        data,
      );

      if (response == null) {
        isLoading.value = false;
        return;
      }

      await _getAttendanceById(response["data"]["insertId"]);
      isLoading.value = false;

      Get.back();
    } catch (e) {
      log(e.toString());
    }
  }

  Future<void> _getAttendanceById(int id) async {
    final response = await THttpHelper.getRequest(
      API.getApis.getPunchingDataById(id),
    );
    if (response == null) return;
    log('log response in getAttendanceById :${response["data"].toString()}');
    AttendanceController.instance.loadData(
      AttendanceRecord.fromJson(response["data"]),
    );
  }
}
