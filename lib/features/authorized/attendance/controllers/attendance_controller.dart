import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:dronees/controllers/auth_controller.dart';
import 'package:dronees/features/authorized/money_receive/models/projects_model.dart';

import 'package:dronees/utils/http/api.dart';
import 'package:dronees/utils/http/http_client.dart';
import 'package:dronees/utils/logging/logger.dart';
import 'package:dronees/utils/popups/loaders.dart';
import 'package:dronees/widgets/custom_alert_sheet.dart';
import 'package:dronees/widgets/custom_blur_bottom_sheet.dart';
import 'package:get/get.dart' hide FormData, MultipartFile;
import 'package:iconsax_flutter/iconsax_flutter.dart';

import 'package:intl/intl.dart';
import 'package:latlong_to_place/latlong_to_place.dart';
import 'package:dronees/features/authorized/attendance/models/attendance_record.dart';
import 'package:flutter/Material.dart';
import 'package:get/get.dart';

class AttendanceController extends GetxController {
  static AttendanceController get instance => Get.find();

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  GlobalKey driverFormKey = GlobalKey<FormState>();
  Timer? _durationTimer;
  // Observable for current attendance
  final Rx<AttendanceRecord?> currentAttendance = Rx<AttendanceRecord?>(null);

  // Observable for attendance history
  final RxList<AttendanceRecord> attendanceHistory = <AttendanceRecord>[].obs;

  // Loading state
  final RxBool isLoading = false.obs;

  final RxBool isLoadingHistory = false.obs;

  // Processing state for punch in/out
  final RxBool isProcessing = false.obs;

  // Today's completed record (for acknowledgment display)
  final Rx<AttendanceRecord?> todayCompletedRecord = Rx<AttendanceRecord?>(
    null,
  );

  // Show acknowledgment card
  final RxBool showAcknowledgment = false.obs;

  final RxBool isIdle = false.obs;
  RxList<ProjectsModel> projects = <ProjectsModel>[].obs;
  Rxn<ProjectsModel> selectedProject = Rxn<ProjectsModel>(
    null,
  ); // Rxn<ProjectsModel>

  PlaceInfo? place;
  var selfieFile = Rxn<File>();

  RxString totalWorkingHoursThisMonth = RxString("00:00:00");
  RxString averageDailyHoursThisMonth = RxString("00:00:00");

  @override
  void onInit() {
    super.onInit();
    _loadHistory();
    _loadAnalytics();
    _startDurationUpdater();
  }

  @override
  void onClose() {
    _durationTimer?.cancel(); // VERY IMPORTANT
    super.onClose();
  }

  Future<void> refreshData() async {
    // await _loadData();
    await _loadHistory();
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

  // Future<void> _getAttendanceById(int id) async {
  //   final response = await THttpHelper.getRequest(
  //     API.getApis.getPunchingDataById(id),
  //   );
  //   if (response == null) return;
  //   log('log response in getAttendanceById :${response["data"].toString()}');
  //   _loadData(AttendanceRecord.fromJson(response["data"]));
  // }

  Future<void> loadData(AttendanceRecord? record) async {
    if (record == null) {
      currentAttendance.value = null;
      todayCompletedRecord.value = null;
      showAcknowledgment.value = false;
      return;
    }

    if (record.outTime == null) {
      currentAttendance.value = record;
      return;
    }
    currentAttendance.value = null;
    todayCompletedRecord.value = record;
    showAcknowledgment.value = true;
  }

  Future<void> _loadAnalytics() async {
    final response = await THttpHelper.getRequest(API.getApis.getAnalytics);
    if (response == null) return;
    TLoggerHelper.customPrint(response["data"].toString());
    totalWorkingHoursThisMonth.value =
        response["data"]["totalWorkingHoursThisMonth"].toString();
    averageDailyHoursThisMonth.value =
        response["data"]["averageDailyHoursThisMonth"].toString();
    // analytics.value = Analytics.fromJson(response["data"]);
  }

  Future<void> _loadHistory() async {
    isLoadingHistory.value = true;
    final response = await THttpHelper.getRequest(
      API.getApis.getPunchingData(
        AuthController.instance.authUser!.userDetails.id,
      ),
    );
    isLoadingHistory.value = false;
    if (response == null) return;
    if (response["data"] == null) return;
    log(jsonEncode(response["data"]));
    attendanceHistory.value = attendanceFromJson(response["data"]);
    //  if today record found then then call
    final today = DateTime.now();
    final todayRecord = attendanceHistory
        .where(
          (element) =>
              element.date.year == today.year &&
              element.date.month == today.month &&
              element.date.day == today.day,
        )
        .toList();
    log(todayRecord.toString());
    if (todayRecord.isNotEmpty) {
      loadData(todayRecord.first);
      attendanceHistory.removeAt(0);
    }
  }

  void _startDurationUpdater() {
    _durationTimer = Timer.periodic(const Duration(minutes: 1), (timer) {
      if (currentAttendance.value?.isActive == true) {
        currentAttendance.refresh();
      }
    });
  }

  // Check if user can punch in today
  bool get canPunchInToday {
    // User can't punch in if:
    // 1. There's an active session
    // 2. Already completed today's attendance
    return currentAttendance.value == null &&
        todayCompletedRecord.value == null;
  }

  // Check if user can punch out
  bool get canPunchOut {
    return currentAttendance.value?.isActive == true;
  }

  // Toggle Idle State
  Future<void> toggleIdleState(
    BuildContext context,
    bool status,
    Widget widget,
  ) async {
    if (projects.isEmpty) {
      _loadProjects();
    }
    isIdle.value = status;
    CustomBlurBottomSheet.show(
      context,
      widget: widget,
      isDismissible: false,
      enaleDrag: false,
    );
  }

  Future<void> updateIdleStatus(AttendanceRecord record) async {
    TLoggerHelper.customPrint("updateIdleStatus start");
    if (!formKey.currentState!.validate()) {
      return;
    }
    isLoading.value = true;
    final data = {
      "attendance_id": record.id,
      'idle_state': isIdle.value,
      'project_id': selectedProject.value?.id,
    };
    final response = await THttpHelper.postRequest(
      API.postApis.updateIdleStatus,
      data,
    );
    isLoading.value = false;
    if (response == null) return;

    TLoggerHelper.customPrint("updateIdleStatus end");
    Get.back();
    _getAttendanceById(record.id);
  }

  Future<void> _getAttendanceById(int id) async {
    final response = await THttpHelper.getRequest(
      API.getApis.getPunchingDataById(id),
    );
    if (response == null) return;
    log('log response in getAttendanceById :${response["data"].toString()}');
    loadData(AttendanceRecord.fromJson(response["data"]));
  }

  // Punch Out
  Future<void> clockOut() async {
    if (currentAttendance.value == null) return;

    if (!canPunchOut) {
      Get.snackbar(
        'No Active Session',
        'Please punch in first!',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: const Color(0xFFFF9800),
        colorText: Colors.white,
        icon: const Icon(Icons.info, color: Colors.white),
        margin: const EdgeInsets.all(20),
        borderRadius: 12,
      );
      return;
    }

    try {
      isLoading.value = true;
      final dateTime = DateFormat('yyyy-MM-dd HH:mm:ss').format(DateTime.now());
      final Map<String, String> data = {
        "punch_out_time": dateTime,
        "date": DateFormat('yyyy-MM-dd').format(DateTime.now()),
        "total_work_hours": currentAttendance.value!.formattedDuration,
        "status": "Present",
      };
      final response = await THttpHelper.postRequest(
        API.postApis.markPunchOut,
        data,
      );
      if (response == null) {
        isLoading.value = false;
        return;
      }
      log('log response in clockOut :${response.toString()}');
      await _getAttendanceById(response["data"]["id"]);
      isLoading.value = false;
    } catch (e) {
      log('error in clockOut ${e.toString()}');
      TLoaders.errorSnackBar(title: "Error", message: "Something went wrong");
    } finally {
      isProcessing.value = false;
    }
  }

  // Dismiss acknowledgment card
  void dismissAcknowledgment() {
    showAcknowledgment.value = false;
  }

  // Calculate total work hours for current month
  String get monthlyWorkHours {
    final time = totalWorkingHoursThisMonth.value.split(":");
    final hours = time[0];
    final minutes = time[1];
    return '${hours}h ${minutes}m';
  }

  // Get average work hours per day
  String get averageWorkHours {
    final time = averageDailyHoursThisMonth.value.split(":");
    final hours = time[0];
    final minutes = time[1];
    return '${hours}h ${minutes}m';
  }
}
