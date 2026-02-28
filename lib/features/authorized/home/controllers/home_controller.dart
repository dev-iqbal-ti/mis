import 'package:dronees/controllers/auth_controller.dart';
import 'package:dronees/features/authorized/gallery/controllers/gallery_controller.dart';
import 'package:dronees/features/authorized/gallery/models/gallery_item.dart';
import 'package:dronees/utils/http/api.dart';
import 'package:dronees/utils/http/http_client.dart';
import 'package:dronees/utils/logging/logger.dart';
import 'package:dronees/utils/popups/loaders.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class PendingAllowance {
  final int id;
  final String taNo;
  final DateTime transactionDate;
  final double amount;
  final String purpose;
  final int taType;
  final int status;

  PendingAllowance({
    required this.id,
    required this.taNo,
    required this.transactionDate,
    required this.amount,
    required this.purpose,
    required this.taType,
    required this.status,
  });

  String get statusLabel {
    switch (status) {
      case 0:
        return 'Pending';
      case 1:
        return 'Approved';
      case 2:
        return 'Rejected';
      default:
        return 'Unknown';
    }
  }

  String get formattedAmount => '₹${amount.toStringAsFixed(0)}';
  String get formattedDate =>
      DateFormat('MMM dd, yyyy').format(transactionDate.toLocal());

  factory PendingAllowance.fromJson(Map<String, dynamic> json) =>
      PendingAllowance(
        id: json['id'],
        taNo: json['ta_no'],
        transactionDate: DateTime.parse(json['transation_date']),
        amount: double.parse(json['amount'].toString()),
        purpose: json['purpose'],
        taType: json['ta_type'],
        status: json['status'],
      );
}

class LeaveEntry {
  final int id;
  final int leaveTypeId;
  final DateTime fromDate;
  final int duration;
  final String status;
  final String reason;

  LeaveEntry({
    required this.id,
    required this.leaveTypeId,
    required this.fromDate,
    required this.duration,
    required this.status,
    required this.reason,
  });

  bool get isApproved => status.toLowerCase() == 'approved';

  String get leaveTypeName {
    switch (leaveTypeId) {
      case 1:
        return 'Casual Leave';
      case 2:
        return 'Sick Leave';
      case 3:
        return 'Earned Leave';
      default:
        return 'Leave';
    }
  }

  String get formattedDate =>
      DateFormat('MMM dd, yyyy').format(fromDate.toLocal());

  String get daysLabel => duration == 1 ? '1 day' : '$duration days';

  factory LeaveEntry.fromJson(Map<String, dynamic> json) => LeaveEntry(
    id: json['id'],
    leaveTypeId: json['leave_type_id'],
    fromDate: DateTime.parse(json['from_date']),
    duration: json['duration'],
    status: json['status'],
    reason: json['reason'],
  );
}

// ─── Controller ─────────────────────────────────────────────────
class HomeController extends GetxController {
  static HomeController get to => Get.find();

  RxString fullName = ''.obs;
  RxString initials = ''.obs;
  RxBool isCheckedIn = RxBool(false);

  // Live data observables
  final Rx<DateTime?> today = Rx<DateTime?>(null);
  final Rx<DateTime?> nextHolidayDate = Rx<DateTime?>(null);
  final Rx<LeaveEntry?> nextLeave = Rx<LeaveEntry?>(null);
  final RxList<GalleryItem> galleryImages = <GalleryItem>[].obs;
  Rxn<GalleryItem> selectedImage = Rxn<GalleryItem>(null);
  final RxList<PendingAllowance> pendingAllowances = <PendingAllowance>[].obs;
  final RxList<LeaveEntry> upcomingLeaves = <LeaveEntry>[].obs;

  // Derived stats
  String get formattedToday =>
      today.value != null ? DateFormat('EEE, MMM d').format(today.value!) : '';

  String get formattedHoliday => nextHolidayDate.value != null
      ? DateFormat('MMM d').format(nextHolidayDate.value!.toLocal())
      : 'N/A';

  String get nextLeaveDate =>
      nextLeave.value != null ? nextLeave.value!.formattedDate : 'N/A';

  @override
  void onInit() {
    super.onInit();
    _initName();
    loadDashboardData();
  }

  void _initName() {
    fullName.value = AuthController.instance.fullName.value;
    final parts = fullName.value.trim().split(' ');
    if (parts.length > 1) {
      initials.value = parts[0][0].toUpperCase() + parts[1][0].toUpperCase();
    } else if (parts.isNotEmpty && parts[0].isNotEmpty) {
      initials.value = parts[0][0].toUpperCase();
    }
    TLoggerHelper.customPrint(fullName.value);
  }

  Future<void> onRefresh() async {
    await loadDashboardData();
  }

  /// Call this with your actual API response JSON
  Future<void> loadDashboardData([Map<String, dynamic>? json]) async {
    final repsonse = await THttpHelper.getRequest(API.getApis.initializeApp);

    if (repsonse == null) return;
    final data = repsonse["data"];

    today.value = DateTime.parse(data['today']);

    if (data['holidays'] != null && data['holidays']['date'] != null) {
      nextHolidayDate.value = DateTime.parse(data['holidays']['date']);
    }

    if (data['nextLeave'] != null) {
      nextLeave.value = LeaveEntry.fromJson(data['nextLeave']);
    }

    galleryImages.value = (data['galleryImages'] as List)
        .map((e) => GalleryItem.fromJson(e))
        .toList();

    pendingAllowances.value = (data['pendingAllowance'] as List)
        .map((e) => PendingAllowance.fromJson(e))
        .toList();

    upcomingLeaves.value = (data['upcommingLeave'] as List)
        .map((e) => LeaveEntry.fromJson(e))
        .toList();
  }

  Future<void> deleteImage(int id) async {
    final response = await THttpHelper.deleteRequest(
      API.deleteApis.deleteImage(id),
    );

    if (response == null) {
      return;
    }
    TLoggerHelper.customPrint(response.toString());
    if (response["success"] == true) {
      // remove image from the list and select next eitheir from left or right and if no image left go back.
      // Find index of current item
      final index = galleryImages.indexWhere((item) => item.id == id);

      if (index != -1) {
        // Remove the item
        galleryImages.removeAt(index);

        if (galleryImages.isNotEmpty) {
          // Prefer selecting next (right side)
          final newIndex = index < galleryImages.length
              ? index
              : galleryImages.length - 1;

          selectedImage.value = galleryImages[newIndex];
        } else {
          // No items left → go back
          Get.back();
        }
      }

      if (Get.isRegistered<GalleryController>()) {
        GalleryController.instance.removeImageAtIndex(id);
      }
      // Get.back();
      TLoaders.successSnackBar(
        title: "Success",
        message: "Image Deleted Successfully",
      );
    }
  }

  void removeImageAtIndex(int id) {
    final index = galleryImages.indexWhere((item) => item.id == id);

    if (index != -1) {
      // Remove the item
      galleryImages.removeAt(index);
    }
  }
}
