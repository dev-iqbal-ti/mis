import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:camera/camera.dart';
import 'package:dronees/controllers/auth_controller.dart';
import 'package:dronees/utils/helpers/add_water_mark.dart';
import 'package:dronees/utils/helpers/image_picker_helper.dart';
import 'package:dronees/utils/http/api.dart';
import 'package:dronees/utils/http/http_client.dart';
import 'package:dronees/utils/logging/logger.dart';
import 'package:dronees/utils/popups/loaders.dart';
import 'package:get/get.dart' hide FormData, MultipartFile;
import 'package:google_maps_flutter/google_maps_flutter.dart' as gmaps;

import 'package:intl/intl.dart';
import 'package:latlong_to_place/latlong_to_place.dart';

import 'package:dronees/features/authorized/attendance/models/attendance_record.dart';
import 'package:flutter/Material.dart';
import 'package:get/get.dart';

class AttendanceController extends GetxController {
  static AttendanceController get instance => Get.find();
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

  var currentPosition = Rxn<gmaps.LatLng>();
  RxString locationName = "".obs;
  RxString currentDate = "".obs;
  var isReady = false.obs;
  final service = GeocodingService();
  PlaceInfo? place;
  var selfieFile = Rxn<File>();

  @override
  void onInit() {
    super.onInit();

    // _loadData();
    _loadHistory();
    _startDurationUpdater();
  }

  Future<void> refreshData() async {
    // await _loadData();
    await _loadHistory();
  }

  void initMarkScreen() {
    getLocation();
    final DateTime now = DateTime.now();
    final DateFormat formatter = DateFormat('dd MMMM yyyy');
    currentDate.value = formatter.format(now);
  }

  Future<void> getLocation() async {
    if (!isReady.value) {
      isLoading.value = true;
    }
    final info = await service.getCurrentPlaceInfo();
    final place = await service.getPlaceInfo(info.latitude, info.longitude);
    locationName.value = place.formattedAddress;
    currentPosition.value = gmaps.LatLng(info.latitude, info.longitude);
    isReady.value = true;
    isLoading.value = false;
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
      final Map<String, String> data = {
        "address": locationName.value,
        "latitude": currentPosition.value!.latitude.toString(),
        "longitude": currentPosition.value!.longitude.toString(),
        "punch_in_time": dateTime,
        "punch_mode": "MOBILE",
        "date": DateFormat('yyyy-MM-dd').format(DateTime.now()),
        "created_at": dateTime,
      };
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
    _loadData(AttendanceRecord.fromJson(response["data"]));
  }

  Future<void> _loadData(AttendanceRecord? record) async {
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

  Future<void> _loadHistory() async {
    isLoadingHistory.value = true;
    final response = await THttpHelper.getRequest(
      API.getApis.getPunchingData(
        AuthController.instance.authUser!.userDetails.id,
      ),
    );
    isLoadingHistory.value = false;
    if (response == null) return;
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
      _loadData(todayRecord.first);
      attendanceHistory.removeAt(0);
    }
  }

  // Start duration updater for active session
  void _startDurationUpdater() {
    // Update duration every minute
    Future.doWhile(() async {
      await Future.delayed(const Duration(minutes: 1));
      if (currentAttendance.value?.isActive == true) {
        // Force update to refresh duration display
        currentAttendance.refresh();
      }
      return true; // Continue loop
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
  void toggleIdleState() {
    // TODO: Write logic to toggle idle state
    // if (currentAttendance.value == null) return;

    // final newIdleState = !currentAttendance.value!.idleState;
    // currentAttendance.value = currentAttendance.value!.copyWith(
    //   idleState: newIdleState,
    // );

    // // In real app, update API
    // // await AttendanceAPI.updateIdleState(newIdleState);

    // Get.snackbar(
    //   newIdleState ? 'Idle Mode ON' : 'Idle Mode OFF',
    //   newIdleState
    //       ? 'You are now in idle mode. Remember to stay active!'
    //       : 'You are back to active mode. Keep up the good work!',
    //   snackPosition: SnackPosition.BOTTOM,
    //   backgroundColor: newIdleState
    //       ? const Color(0xFFFF9800)
    //       : const Color(0xFF00B894),
    //   colorText: Colors.white,
    //   icon: Icon(
    //     newIdleState ? Icons.pause_circle : Icons.play_circle,
    //     color: Colors.white,
    //   ),
    //   margin: const EdgeInsets.all(20),
    //   borderRadius: 12,
    //   duration: const Duration(seconds: 2),
    // );
  }

  // Punch In
  // Future<void> punchIn() async {
  //   if (!canPunchInToday) {
  //     Get.snackbar(
  //       'Already Marked',
  //       'You have already completed attendance for today!',
  //       snackPosition: SnackPosition.BOTTOM,
  //       backgroundColor: const Color(0xFFFF9800),
  //       colorText: Colors.white,
  //       icon: const Icon(Icons.info, color: Colors.white),
  //       margin: const EdgeInsets.all(20),
  //       borderRadius: 12,
  //     );
  //     return;
  //   }

  //   try {
  //     isProcessing.value = true;

  //     // Simulate getting location (replace with actual location service)
  //     await Future.delayed(const Duration(seconds: 2));

  //     // Create new attendance record
  //     final newRecord = AttendanceRecord(
  //       idleState: false,
  //       latitude: 22.5726, // Replace with actual location
  //       longitude: 88.3639,
  //       address:
  //           'Tech Park, Salt Lake Sector V, Kolkata', // Replace with geocoded address
  //       photoUrl:
  //           'https://via.placeholder.com/150', // Replace with actual photo
  //       punchInTime: DateTime.now(),
  //       punchOutTime: null,
  //     );

  //     currentAttendance.value = newRecord;

  //     // In real app, send to API here
  //     // await AttendanceAPI.punchIn(newRecord);

  //     Get.snackbar(
  //       'Success',
  //       'Punched in successfully!',
  //       snackPosition: SnackPosition.BOTTOM,
  //       backgroundColor: const Color(0xFF00B894),
  //       colorText: Colors.white,
  //       icon: const Icon(Icons.check_circle, color: Colors.white),
  //       margin: const EdgeInsets.all(20),
  //       borderRadius: 12,
  //       duration: const Duration(seconds: 2),
  //     );
  //   } catch (e) {
  //     Get.snackbar(
  //       'Error',
  //       'Failed to punch in. Please try again.',
  //       snackPosition: SnackPosition.BOTTOM,
  //       backgroundColor: const Color(0xFFFF6B6B),
  //       colorText: Colors.white,
  //       icon: const Icon(Icons.error, color: Colors.white),
  //       margin: const EdgeInsets.all(20),
  //       borderRadius: 12,
  //     );
  //   } finally {
  //     isProcessing.value = false;
  //   }
  // }

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
    final now = DateTime.now();
    final monthRecords = attendanceHistory.where(
      (record) =>
          record.inTime.month == now.month && record.inTime.year == now.year,
    );

    int totalMinutes = 0;
    for (var record in monthRecords) {
      totalMinutes += record.workDuration.inMinutes;
    }

    // Add current session if active
    if (currentAttendance.value?.isActive == true) {
      totalMinutes += currentAttendance.value!.workDuration.inMinutes;
    }

    // Add today's completed record if exists
    if (todayCompletedRecord.value != null) {
      totalMinutes += todayCompletedRecord.value!.workDuration.inMinutes;
    }

    final hours = totalMinutes ~/ 60;
    final minutes = totalMinutes % 60;
    return '${hours}h ${minutes}m';
  }

  // Get attendance percentage for current month
  double get monthlyAttendancePercentage {
    final now = DateTime.now();
    final workingDaysInMonth = 22; // Average working days
    final daysWorked =
        attendanceHistory
            .where(
              (record) =>
                  record.inTime.month == now.month &&
                  record.inTime.year == now.year,
            )
            .length +
        (currentAttendance.value != null ? 1 : 0) +
        (todayCompletedRecord.value != null ? 1 : 0);

    return (daysWorked / workingDaysInMonth * 100).clamp(0, 100);
  }

  // Get average work hours per day
  String get averageWorkHours {
    if (attendanceHistory.isEmpty && todayCompletedRecord.value == null) {
      return '0h 0m';
    }

    int totalMinutes = 0;
    int completedDays = 0;

    for (var record in attendanceHistory) {
      if (record.outTime != null) {
        totalMinutes += record.workDuration.inMinutes;
        completedDays++;
      }
    }

    // Add today's completed record
    if (todayCompletedRecord.value != null) {
      totalMinutes += todayCompletedRecord.value!.workDuration.inMinutes;
      completedDays++;
    }

    if (completedDays == 0) return '0h 0m';

    final avgMinutes = totalMinutes ~/ completedDays;
    final hours = avgMinutes ~/ 60;
    final minutes = avgMinutes % 60;
    return '${hours}h ${minutes}m';
  }
}
