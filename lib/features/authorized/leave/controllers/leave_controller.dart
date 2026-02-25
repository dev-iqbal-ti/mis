import 'dart:convert';

import 'package:dronees/controllers/auth_controller.dart';

import 'package:dronees/features/authorized/leave/models/leave_entitlement.dart';
import 'package:dronees/features/authorized/leave/models/leaves.dart';
import 'package:dronees/utils/http/api.dart';
import 'package:dronees/utils/http/http_client.dart';
import 'package:dronees/utils/popups/loaders.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LeaveController extends GetxController {
  static LeaveController get to => Get.find();
  // Reactive variable for tab switching
  var selectedTabIndex = 1.obs;
  final int availableLeave = 20;
  final int usedLeave = 2;
  Rxn<String> selectedValue = Rxn<String>(null);

  Rx<DateTime> startDate = DateTime.now().obs;
  Rx<DateTime?> endDate = Rx<DateTime?>(null);

  void setTab(int index) => selectedTabIndex.value = index;

  Rx<DateTime> get selectedDate => startDate;

  // new ui...
  final ScrollController scrollController = ScrollController();

  final selectedStatus = 'All'.obs;
  final selectedDateForFilter = Rxn<DateTime>();

  // Pagination
  final isLoadingMore = false.obs;
  final isRefreshing = false.obs;
  final hasMore = true.obs;
  static const int _pageSize = 10;

  Rx<LeaveEntitlement> casualLeaveEntitlements = Rx<LeaveEntitlement>(
    LeaveEntitlement(
      id: 1,
      userId: 0,
      entitlement: 12,
      used: 0,
      leaveTypeName: "Casual Leave",
      remaining: 0,
    ),
  );
  Rx<LeaveEntitlement> earnedLeaveEntitlements = Rx<LeaveEntitlement>(
    LeaveEntitlement(
      id: 2,
      userId: 1,
      entitlement: 2,
      used: 0,
      leaveTypeName: 'Earned Leave',
      remaining: 2,
    ),
  );
  Rx<LeaveEntitlement> floatingHolidayEntitlements = Rx<LeaveEntitlement>(
    LeaveEntitlement(
      id: 3,
      userId: 1,
      entitlement: 2,
      used: 0,
      leaveTypeName: "Floating Holiday",
      remaining: 1,
    ),
  );

  RxDouble totalLeave = 0.0.obs;

  RxList<Leaves> leaves = RxList<Leaves>([]);
  int _currentPage = 0;

  final casualDays = 18.obs;
  final sickDays = 12.obs;
  final privilegeDays = 10.obs;

  @override
  void onInit() {
    super.onInit();
    _loadleaves();
    _getLeaveStates();
    scrollController.addListener(_onScroll);
  }

  void setDate(DateTime date) {
    selectedDate.value = date;
  }

  @override
  void onClose() {
    scrollController.dispose();
    super.onClose();
  }

  Future<void> _getLeaveStates() async {
    final response = await THttpHelper.getRequest(
      API.getApis.getLeaveEntitlement(
        AuthController.instance.authUser!.userDetails.id,
      ),
    );
    if (response == null) {
      return;
    }

    final List<dynamic> data = response['data'] ?? [];
    if (data.isEmpty) {
      return;
    }
    for (var d in data) {
      if (d["leave_type_name"] == "Casual Leave") {
        casualLeaveEntitlements.value = LeaveEntitlement.fromJson(d);
        totalLeave.value += casualLeaveEntitlements.value.remaining;
      }
      if (d["leave_type_name"] == "Earned Leave") {
        earnedLeaveEntitlements.value = LeaveEntitlement.fromJson(d);
        totalLeave.value += earnedLeaveEntitlements.value.remaining;
      }
      if (d["leave_type_name"] == "Floating Holiday") {
        floatingHolidayEntitlements.value = LeaveEntitlement.fromJson(d);
        totalLeave.value += floatingHolidayEntitlements.value.remaining;
      }
    }
  }

  Future<void> _loadleaves({bool isLoadMore = false}) async {
    try {
      if (!isLoadMore) {
        isRefreshing.value = true;
        _currentPage = 1;
      }

      final response = await THttpHelper.getRequest(
        API.getApis.getLeave(AuthController.instance.authUser!.userDetails.id),
        queryParams: {
          "page": _currentPage.toString(),
          "limit": _pageSize.toString(),
          "status": selectedStatus.value.toLowerCase(),
        },
      );

      if (response == null) return;

      final List<dynamic> data = response['data'] ?? [];
      final pagination = response['pagination'];

      final newLeaves = leavesFromJson(jsonEncode(data));

      if (isLoadMore) {
        leaves.addAll(newLeaves);
      } else {
        leaves.value = newLeaves;
      }

      // ✅ Pagination handling from backend
      hasMore.value = pagination['hasNext'] ?? false;
    } catch (e) {
      debugPrint("Error loading leaves: $e");
    } finally {
      isLoadingMore.value = false;
      isRefreshing.value = false;
    }
  }

  void _onScroll() {
    if (scrollController.position.pixels >=
            scrollController.position.maxScrollExtent - 100 &&
        !isLoadingMore.value &&
        hasMore.value) {
      loadMore();
    }
  }

  Future<void> loadMore() async {
    if (isLoadingMore.value || !hasMore.value) return;

    isLoadingMore.value = true;
    _currentPage++;

    await _loadleaves(isLoadMore: true);
  }

  Future<void> refresh() async {
    hasMore.value = true;
    await _loadleaves(isLoadMore: false);
    await _getLeaveStates();
  }

  void applyFilter(String status, DateTime? date) {
    selectedStatus.value = status;
    selectedDateForFilter.value = date;

    hasMore.value = true;
    _currentPage = 1;

    _loadleaves();
  }

  void resetFilter() {
    applyFilter('All', null);
  }

  Color statusColor(String status) {
    switch (status) {
      case 'Approved':
        return const Color(0xFF00C17C);
      case 'Pending':
        return const Color(0xFFFF9800);
      case 'Cancelled':
        return const Color(0xFFFF4D4D);
      default:
        return Colors.grey;
    }
  }

  Future<void> cancelLeave(Leaves leave) async {
    final response = await THttpHelper.postRequest(API.postApis.cancelLeave, {
      "leave_application_id": leave.id,
    });
    if (response == null) return;
    await refresh();
    TLoaders.successSnackBar(
      title: "Success",
      message: "Leave Cancelled Successfully",
    );
  }
}
