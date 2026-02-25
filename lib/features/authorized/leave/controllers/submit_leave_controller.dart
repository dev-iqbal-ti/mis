import 'dart:convert';
import 'dart:developer';

import 'package:dronees/controllers/auth_controller.dart';
import 'package:dronees/features/authorized/leave/controllers/leave_calender_controller.dart';
import 'package:dronees/features/authorized/leave/controllers/leave_controller.dart';
import 'package:dronees/features/authorized/leave/models/comp_off.dart';
import 'package:dronees/features/authorized/leave/models/day_type.dart';

import 'package:dronees/features/authorized/leave/models/holiday_leave.dart';
import 'package:dronees/features/authorized/leave/models/leave_category.dart';
import 'package:dronees/features/authorized/leave/models/leave_duration.dart';
import 'package:dronees/features/authorized/leave/models/leaves.dart';
import 'package:dronees/utils/http/api.dart';
import 'package:dronees/utils/http/http_client.dart';
import 'package:dronees/utils/logging/logger.dart';
import 'package:dronees/utils/popups/loaders.dart';
import 'package:dronees/widgets/custom_alert_sheet.dart';
import 'package:dronees/widgets/custom_blur_bottom_sheet.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:intl/intl.dart';

class SubmitLeaveController extends GetxController {
  static SubmitLeaveController get to => Get.find();
  Rx<DateTime> startDate = DateTime.now().obs;
  Rx<DateTime?> endDate = Rx<DateTime?>(null);
  GlobalKey<FormState> leaveFormKey = GlobalKey<FormState>();
  Rx<DateTime> get selectedDate => startDate;
  var selectedCategory = Rxn<LeaveCategory>(null);
  RxList<LeaveCategory> leaveCategory = <LeaveCategory>[].obs;
  RxBool isLoadingHolidays = RxBool(false);
  final Rx<HolidayLeave?> selectedHoliday = Rx(null);
  final RxList<HolidayLeave> floatingHolidays = <HolidayLeave>[].obs;
  final RxList<HolidayLeave> holidays = <HolidayLeave>[].obs;
  RxList<CompOff> compOffList = <CompOff>[].obs;
  Rx<CompOff?> selectedCompOff = Rx<CompOff?>(null);

  var emergencyContact = ''.obs;

  TextEditingController purposeController = TextEditingController();
  Rx<LeaveType> selectedLeaveType = LeaveType.fullDay.obs;
  Rx<HalfDaySession?> startHalfDay = Rx<HalfDaySession?>(null);
  Rx<HalfDaySession?> endHalfDay = Rx<HalfDaySession?>(null);

  @override
  void onInit() {
    super.onInit();
    _loadType();
    _loadHolidays();
  }

  Future<void> _loadHolidays() async {
    isLoadingHolidays.value = true;
    final response = await THttpHelper.getRequest(
      API.getApis.getLocationHolidays,
    );
    isLoadingHolidays.value = false;
    if (response == null) return;
    if (response["data"].isEmpty) {
      return;
    }
    for (final holiday in response["data"]) {
      if (holiday["type"] != "Optional") {
        holidays.add(HolidayLeave.fromJson(holiday));
      }
    }
  }

  Future<void> _loadType() async {
    final response = await THttpHelper.getRequest(API.getApis.getLeaveTypes);
    if (response == null) {
      return;
    }
    if (response["data"].isEmpty) {
      CustomBlurBottomSheet.show(
        Get.context!,
        widget: CustomAlertSheet(
          title: 'Leave Category',
          message: 'Leave Category not found. Please contact admin',
          buttonText: 'Go Back',
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

    leaveCategory.value = leaveCategoryFromJson(jsonEncode(response["data"]));

    // selectedValue.value = response["data"][0]["name"];
  }

  void onHolidaySelected(HolidayLeave holiday) {
    selectedHoliday.value = holiday;
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

  void setStartHalfDay(HalfDaySession session) {
    startHalfDay.value = session;
  }

  void setEndHalfDay(HalfDaySession? session) {
    endHalfDay.value = session;
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

  Future<void> submitLeave(LeaveCalendarController calenderController) async {
    final data = {
      "leave_type_id": selectedCategory.value?.id,
      "reason": purposeController.text,
      "workedDates": [],
    };

    final leaveDates = calenderController.selectedDays.map((day) {
      return {
        "date": DateFormat('yyyy-MM-dd').format(day.date),
        "dayType": DayType.getValue(day.selectionType.name),
      };
    });
    data["leave_dates"] = leaveDates.toList();

    if (selectedCategory.value?.name == "Comp Off") {
      if (selectedCompOff.value?.date == null) {
        TLoaders.errorSnackBar(
          title: "Error",
          message: "Please select comp off date",
        );
        return;
      }
      data["workedDates"] = [
        {"date": DateFormat('yyyy-MM-dd').format(selectedCompOff.value!.date)},
      ];
    }

    TLoggerHelper.customPrint(data);

    // "leave_dates"
    // [{"date":"2026-02-27","dayType":"SECOND_HALF"},{"date":"2026-02-28","dayType":"FIRST_HALF"},{"date":"2026-03-09","dayType":"FULL_DAY"}]
    final response = await THttpHelper.postRequest(
      API.postApis.applyLeave,
      data,
    );

    if (response == null) return;
    LeaveController.to.refresh();
    Get.back();
    TLoaders.successSnackBar(
      title: "Success",
      message: "Leave applied successfully",
    );
  }

  void selectCategory(
    LeaveCategory category,
    FormFieldState<LeaveCategory> state,
  ) async {
    if (category.name == "Floating Holiday") {
      final status = await getHolidayList();
      TLoggerHelper.customPrint(status);
      if (status == false) {
        return;
      }
    }
    if (category.name == "Comp Off") {
      final status = await getCompOffList();
      TLoggerHelper.customPrint(status);
      if (status == false) {
        return;
      }
    }
    if (selectedCategory.value?.name != category.name) {
      LeaveCalendarController.instance.clearSelections();
    }

    selectedHoliday.value = null;
    selectedCategory.value = category;
    state.didChange(category);
  }

  Future<bool> getCompOffList() async {
    // if (floatingHolidays.isNotEmpty) return;
    isLoadingHolidays.value = true;
    final response = await THttpHelper.getRequest(
      API.getApis.getPunchingData(
        AuthController.instance.authUser!.userDetails.id,
      ),
      queryParams: {"compOff": true.toString(), "limit": 50.toString()},
    );
    isLoadingHolidays.value = false;
    if (response == null) return false;
    if (response["data"].isEmpty) {
      CustomBlurBottomSheet.show(
        Get.context!,
        widget: CustomAlertSheet(
          icon: Iconsax.empty_wallet_copy,
          title: 'Comp Off List',
          message: 'Your comp Off List is empty. Please contact Manager',
          buttonText: 'Go Back',
          onAction: () {
            Get.back();
          },
        ),
        isDismissible: false,
        enaleDrag: false,
      );
      return false;
    }

    compOffList.value = compOffFromJson(jsonEncode(response["data"]));
    return true;
  }

  Future<bool> getHolidayList() async {
    if (floatingHolidays.isNotEmpty) return true;
    isLoadingHolidays.value = true;
    final response = await THttpHelper.getRequest(API.getApis.getHolidaysDate);
    isLoadingHolidays.value = false;
    if (response == null) return false;
    if (response["data"].isEmpty) {
      CustomBlurBottomSheet.show(
        Get.context!,
        widget: CustomAlertSheet(
          title: 'Holiday List',
          message: 'Holiday List not found. Please contact Manager.',
          buttonText: 'Go Back',
          onAction: () {
            Get.back();
          },
        ),
        isDismissible: false,
        enaleDrag: false,
      );
      return false;
    }

    floatingHolidays.value = holidayLeaveFromJson(jsonEncode(response["data"]));
    return true;
  }
}
