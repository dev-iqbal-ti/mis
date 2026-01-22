import 'dart:developer';

import 'package:dronees/features/authorized/leave/models/leave_duration.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LeaveController extends GetxController {
  // Reactive variable for tab switching
  var selectedTabIndex = 1.obs;
  final int availableLeave = 20;
  final int usedLeave = 2;
  Rxn<String> selectedValue = Rxn<String>(null);
  GlobalKey<FormState> leaveFormKey = GlobalKey<FormState>();
  // TextEditingController emergencyContactController = TextEditingController();
  TextEditingController purposeController = TextEditingController();
  // final selectedDate = DateTime.now().obs;
  var emergencyContact = ''.obs;

  Rx<LeaveType> selectedLeaveType = LeaveType.fullDay.obs;
  Rx<DateTime> startDate = DateTime.now().obs;
  Rx<DateTime?> endDate = Rx<DateTime?>(null);
  Rx<HalfDaySession?> startHalfDay = Rx<HalfDaySession?>(null);
  Rx<HalfDaySession?> endHalfDay = Rx<HalfDaySession?>(null);

  void setTab(int index) => selectedTabIndex.value = index;

  Rx<DateTime> get selectedDate => startDate;

  void setDate(DateTime date) {
    selectedDate.value = date;
  }

  void updateValue(String? value) {
    selectedValue.value = value;
  }

  @override
  void onClose() {
    purposeController.dispose();
    super.onClose();
  }

  // --- Submit Leave Logic ---
  var selectedCategory = "".obs;
  var selectedDuration = "".obs;
  var taskDelegation = "".obs;
  var contactController = TextEditingController();
  var descriptionController = TextEditingController();

  // Sample data
  List<Map<String, dynamic>> get leaves => [
    {
      "submitDate": "18 September 2024",
      "range": "20 Sept - 22 Sept",
      "totalDays": 2,
      "status": "Pending",
      "reviewedDate": "",
      "reviewer": "",
    },
    {
      "submitDate": "18 September 2024",
      "range": "20 Sept - 22 Sept",
      "totalDays": 2,
      "status": "Approved",
      "reviewedDate": "19 Sept 2024",
      "reviewer": "Elaine",
    },
    {
      "submitDate": "18 September 2024",
      "range": "25 Sept",
      "totalDays": 1,
      "status": "Approved",
      "reviewedDate": "19 Sept 2024",
      "reviewer": "Elaine",
    },
    {
      "submitDate": "18 September 2024",
      "range": "10 Oct",
      "totalDays": 1,
      "status": "Rejected",
      "reviewedDate": "19 Sept 2024",
      "reviewer": "Sandeep",
    },
  ];

  // void submitLeave() {
  //   // Basic validation logic
  //   if (selectedCategory.isEmpty || selectedDuration.isEmpty) {
  //     Get.snackbar(
  //       "Error",
  //       "Please fill in the required fields",
  //       snackPosition: SnackPosition.BOTTOM,
  //       backgroundColor: Colors.redAccent,
  //       colorText: Colors.white,
  //     );
  //     return;
  //   }

  //   // Simulate API Call
  //   Get.back(); // Go back after success
  //   Get.snackbar(
  //     "Success",
  //     "Leave request submitted successfully!",
  //     snackPosition: SnackPosition.BOTTOM,
  //     backgroundColor: Colors.green,
  //     colorText: Colors.white,
  //   );
  // }

  void setLeaveType(LeaveType type) {
    selectedLeaveType.value = type;

    // Reset half day selections based on type
    if (type == LeaveType.fullDay) {
      startHalfDay.value = null;
      endHalfDay.value = null;
      endDate.value = null;
    } else if (type == LeaveType.halfDay) {
      startHalfDay.value = HalfDaySession.firstHalf;
      endHalfDay.value = null;
      endDate.value = null;
    } else {
      // multipleDays - initialize end date
      endDate.value = startDate.value.add(Duration(days: 1));
    }
  }

  void setStartDate(DateTime date) {
    startDate.value = date;

    // If end date is before start date, update it
    if (endDate.value != null && endDate.value!.isBefore(date)) {
      endDate.value = date.add(Duration(days: 1));
    }
  }

  void setEndDate(DateTime date) {
    endDate.value = date;
  }

  void setStartHalfDay(HalfDaySession session) {
    startHalfDay.value = session;
  }

  void setEndHalfDay(HalfDaySession? session) {
    endHalfDay.value = session;
  }

  LeaveDuration getLeaveDuration() {
    return LeaveDuration(
      startDate: startDate.value,
      endDate: endDate.value,
      leaveType: selectedLeaveType.value,
      startHalfDay: startHalfDay.value,
      endHalfDay: endHalfDay.value,
    );
  }

  // Submit leave method
  void submitLeave() {
    final leaveDuration = getLeaveDuration();

    print("Leave Submitted:");
    print("Total Days: ${leaveDuration.getTotalDays()}");
    print("Leave Data: ${leaveDuration.toJson()}");

    final data = {
      "type": selectedValue.value,
      "startDate": startDate.value.toString(),
      "endDate": endDate.value.toString(),
      "emergencyContact": emergencyContact.value,
      "purpose": purposeController.text,
      "submitDate": DateTime.now().toString(),
      "range": leaveDuration.getDescription(),
      "totalDays": leaveDuration.getTotalDays(),
      "status": "Pending",
      "reviewedDate": "",
      "reviewer": "",
    };

    log(data.toString());

    Get.snackbar(
      "Success",
      "Leave submitted for ${leaveDuration.getTotalDays()} days",
      snackPosition: SnackPosition.BOTTOM,
    );
  }

  // Sample data
  List<Map<String, dynamic>> get approvedLeaves => [
    {
      "submitDate": "18 September 2024",
      "range": "20 Sept - 22 Sept",
      "totalDays": 2,
      "approvedDate": "19 Sept 2024",
      "approver": "Elaine",
    },
  ];
}
