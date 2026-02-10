import 'dart:convert';
import 'dart:developer';

import 'package:dronees/features/authorized/travel_allowance/controllers/allowance_list_record_controller.dart';
import 'package:dronees/features/authorized/travel_allowance/models/ta_status.dart';
import 'package:dronees/features/authorized/travel_allowance/models/travel_allowance_model.dart';
import 'package:dronees/features/authorized/travel_allowance/models/travel_allowance_stats.dart';
import 'package:dronees/utils/http/api.dart';
import 'package:dronees/utils/http/http_client.dart';
import 'package:dronees/utils/logging/logger.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class TravelAllowanceController extends GetxController {
  static TravelAllowanceController get instance => Get.find();

  RxBool isLoading = RxBool(false);
  RxBool isLoadingMore = RxBool(false);
  RxBool loadingStats = RxBool(false);
  RxList<TravelAllowance> allowances = RxList<TravelAllowance>([]);

  // Pagination
  RxInt currentPage = RxInt(1);
  RxInt totalPages = RxInt(1);
  RxInt total = RxInt(0);
  final int limit = 10;

  // Filter
  RxString selectedStatus = RxString('Pending');
  final ScrollController scrollController = ScrollController();

  TextEditingController remarkController = TextEditingController();

  // Summary counts
  RxInt pendingCount = RxInt(0);
  RxInt approvedCount = RxInt(0);
  RxInt rejectedCount = RxInt(0);
  RxString pendingAmount = RxString('₹1250');
  RxString rejectedAmount = RxString('₹200');
  RxString approvedAmount = RxString('₹15230');

  @override
  void onInit() {
    super.onInit();
    _setupScrollListener();
    loadAllowances();
    _loadSummary();
  }

  @override
  void onClose() {
    scrollController.dispose();
    remarkController.dispose();
    super.onClose();
  }

  void _setupScrollListener() {
    scrollController.addListener(() {
      if (scrollController.position.pixels >=
          scrollController.position.maxScrollExtent - 200) {
        if (!isLoadingMore.value && currentPage.value < totalPages.value) {
          loadMoreAllowances();
        }
      }
    });
  }

  Future<void> loadAllowances({bool refresh = false}) async {
    if (refresh) {
      currentPage.value = 1;
      allowances.clear();
    }

    isLoading.value = true;
    final url =
        '${API.getApis.getTravelAllowance}?limit=$limit&page=${currentPage.value}&status=$_getStatusQuery';

    final response = await THttpHelper.getRequest(url);

    isLoading.value = false;

    if (response == null) return;

    final List<TravelAllowance> newAllowances = travelAllowanceFromJson(
      json.encode(response["data"]),
    );

    if (refresh) {
      allowances.value = newAllowances;
    } else {
      allowances.addAll(newAllowances);
    }

    // Update pagination info
    if (response['pagination'] != null) {
      currentPage.value = response['pagination']['page'] ?? 1;
      totalPages.value = response['pagination']['totalPages'] ?? 1;
      total.value = response['pagination']['total'] ?? 0;
    }
  }

  Future<void> loadMoreAllowances() async {
    if (currentPage.value >= totalPages.value) return;

    isLoadingMore.value = true;
    currentPage.value++;

    final response = await THttpHelper.getRequest(
      '${API.getApis.getTravelAllowance}?limit=$limit&page=${currentPage.value}&status=$_getStatusQuery',
    );

    isLoadingMore.value = false;

    if (response == null) {
      currentPage.value--;
      return;
    }

    final List<TravelAllowance> newAllowances = travelAllowanceFromJson(
      json.encode(response["data"]),
    );

    allowances.addAll(newAllowances);
  }

  Future<void> _loadSummary() async {
    loadingStats.value = true;
    final response = await THttpHelper.getRequest(
      API.getApis.getTravelAllowanceStats,
    );
    loadingStats.value = false;
    if (response == null) return;

    final stats = TravelAllowanceStats.fromJson(response["data"]);
    pendingAmount.value = stats.pendingAmount;
    approvedAmount.value = stats.approvedAmount;
    rejectedAmount.value = stats.rejectedAmount;
    log(stats.pendingCount.toString());
    pendingCount.value = stats.pendingCount;
    approvedCount.value = stats.approvedCount;
    rejectedCount.value = stats.rejectedCount;
  }

  // Future<void> _loadStatusCount(String status) async {
  //   final response = await THttpHelper.getRequest(
  //     '${API.getApis.getTravelAllowance}?limit=1&page=1&status=$status',
  //   );

  //   if (response != null && response['pagination'] != null) {
  //     final count = response['pagination']['total'] ?? 0;

  //     switch (status) {
  //       case 'Pending':
  //         pendingCount.value = count;
  //         break;
  //       case 'Approved':
  //         approvedCount.value = count;
  //         break;
  //       case 'Rejected':
  //         rejectedCount.value = count;
  //         break;
  //     }
  //   }
  // }

  void changeFilter(String status) {
    if (selectedStatus.value == status) return;

    selectedStatus.value = status;
    currentPage.value = 1;
    allowances.clear();
    loadAllowances();
  }

  String get _getStatusQuery {
    switch (selectedStatus.value) {
      case 'Approved':
        return 'Approved';
      case 'Rejected':
        return 'Rejected';
      default:
        return 'Pending';
    }
  }

  Future<void> refreshAllowances() async {
    await loadAllowances(refresh: true);
    await _loadSummary();
  }

  Future<void> deleteTAReqast(int taId) async {
    isLoading.value = true;
    final response = await THttpHelper.deleteRequest(
      API.deleteApis.deleteTravelAllowance(taId),
    );
    // await Future.delayed(const Duration(seconds: 5));

    if (response == null) {
      isLoading.value = false;
      return;
    }
    await TravelAllowanceController.instance.refreshAllowances();
    isLoading.value = false;
    Get.back();
  }

  Future<void> approveTAReqast(int taId) async {
    isLoading.value = true;
    final response = await THttpHelper.postRequest(API.postApis.approveTA, {
      "id": taId,
      "by": TAStatus.approvedByDepartment,
    });

    if (response == null) {
      isLoading.value = false;
      return;
    }
    await AllowanceListRecordController.instance.refreshAllowances();
    isLoading.value = false;
    Get.back();
  }

  Future<void> initializeTAReqast(int taId) async {
    isLoading.value = true;
    final response = await THttpHelper.postRequest(API.postApis.approveTA, {
      "id": taId,
      "by": TAStatus.approvedByFinance,
    });
    if (response == null) {
      isLoading.value = false;
      return;
    }
    await AllowanceListRecordController.instance.refreshAllowances();
    isLoading.value = false;
    Get.back();
  }

  Future rejectTAReqast(int taId) async {
    isLoading.value = true;
    final response = await THttpHelper.postRequest(API.postApis.rejectTA, {
      "id": taId,
      "remark": remarkController.text.isEmpty ? null : remarkController.text,
    });
    if (response == null) {
      isLoading.value = false;
      return;
    }
    remarkController.clear();
    await AllowanceListRecordController.instance.refreshAllowances();
    isLoading.value = false;
    Get.back();
    Get.back();
  }
}
